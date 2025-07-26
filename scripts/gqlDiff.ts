import { parse, buildSchema, printSchema, GraphQLSchema, DocumentNode, visit, Kind, FieldDefinitionNode, ObjectTypeDefinitionNode, DefinitionNode, print } from 'graphql';
import { diffLines, Change } from 'diff';
import fs from 'fs';
import path, { resolve } from 'path';
//import chalk from 'chalk';
import { argv } from 'process';

const {default:chalk}=require('chalk')

/**
 * Deeply sorts all parts of a GraphQL AST:
 * - definitions by kind and name
 * - object, interface, input fields by name
 * - field arguments by name
 * - enum values
 * - union member types
 * - directive arguments
 */
function deepSortAst(ast: DocumentNode): DocumentNode {
  return visit(ast, {
    Document(node) {
      const definitions = [...node.definitions].sort((a, b) => {
        const kindOrder = a.kind.localeCompare(b.kind);
        const nameA = (a as any).name?.value || '';
        const nameB = (b as any).name?.value || '';
        return kindOrder !== 0 ? kindOrder : nameA.localeCompare(nameB);
      });
      return { ...node, definitions };
    },
    ObjectTypeDefinition(node) {
      const fields = [...(node.fields || [])].sort((a, b) => a.name.value.localeCompare(b.name.value));
      const sortedArgs = fields.map(f => ({
        ...f,
        arguments: [...(f.arguments || [])].sort((x, y) => x.name.value.localeCompare(y.name.value))
      }));
      return { ...node, fields: sortedArgs };
    },
    InterfaceTypeDefinition(node) {
      const fields = [...(node.fields || [])].sort((a, b) => a.name.value.localeCompare(b.name.value));
      const sortedArgs = fields.map(f => ({
        ...f,
        arguments: [...(f.arguments || [])].sort((x, y) => x.name.value.localeCompare(y.name.value))
      }));
      return { ...node, fields: sortedArgs };
    },
    InputObjectTypeDefinition(node) {
      const fields = [...(node.fields || [])].sort((a, b) => a.name.value.localeCompare(b.name.value));
      return { ...node, fields };
    },
    EnumTypeDefinition(node) {
      const values = [...(node.values || [])].sort((a, b) => a.name.value.localeCompare(b.name.value));
      return { ...node, values };
    },
    UnionTypeDefinition(node) {
      const types = [...(node.types || [])]
        .map(t => t.name.value)
        .sort()
        .map(name => ({ kind: 'NamedType', name: { kind: 'Name', value: name } }));
      return { ...node, types };
    },
    DirectiveDefinition(node) {
      const args = [...(node.arguments || [])].sort((a, b) => a.name.value.localeCompare(b.name.value));
      return { ...node, arguments: args };
    }
  });
}

/**
 * Splits a full SDL string into top-level definitions (including preceding comments),
 * skipping description blocks like """ ... """ or """single line""".
 */
function splitDefinitions(sdl: string): Map<string, string> {
  const map = new Map<string, string>();
  const lines = sdl.split(/\r?\n/);
  let currentName: string | null = null;
  let buffer: string[] = [];
  let insideDescription = false;

  const flush = () => {
    if (currentName && buffer.length) {
      map.set(currentName, buffer.join('\n').trim());
    }
    buffer = [];
  };

  for (let i = 0; i < lines.length; i++) {
    const rawLine = lines[i];
    const line = rawLine.trim();

    // Track triple-quoted description blocks
    const tripleQuoteCount = (line.match(/"""/g) || []).length;
    if (tripleQuoteCount === 1) {
      insideDescription = !insideDescription; // toggled by each """ if only one found on the line
    }

    if (!insideDescription) {
      // Match top-level SDL type definitions
      const match = line.match(/^(type|input|enum|union|interface|scalar|directive)\s+(\w+)/);
      if (match) {
        flush();
        currentName = match[2];
      }
    }

    if (currentName) buffer.push(rawLine);
  }

  flush();
  return map;
}


export function stripGraphQLCommentsAndDescriptions(sdl: string): string {
  return sdl
    // Remove triple-quoted descriptions (""" ... """)
    .replace(/"""\s*([\s\S]*?)\s*"""\n?/g, '')
    // Remove single-line descriptions ('"' ... '"') — rare but sometimes used
    .replace(/"\s*([^"]*?)\s*"\n?/g, '')
    // Remove # comments
    .replace(/#[^\n]*/g, '')
    // Trim and normalize extra newlines
    .replace(/\n{2,}/g, '\n\n')
    .trim();
}

/**
 * Compare two GraphQL schema strings, sorted and split per-definition,
 * and print a colored diff per node only when definitions differ.
 */
export function compareGraphqlSchemas(
  schemaA: string,
  schemaB: string,
  labelA = 'Reference',
  labelB = 'Input',
  filterFn?:(params:{definitionName:string,definitionA?:string,definitionB?:string})=>boolean,
  cleanFn?:(str:string)=>string,
) {

  // 0. optional: remove comments and descriptions to simplify diff using a cleanFn
  // const cleanA=cleanFn
  //   ?cleanFn(schemaA)
  //   :schemaA;
  // const cleanB=cleanFn
  //   ?cleanFn(schemaB)
  //   :schemaB;

  // 1. Validate schemas
  try { buildSchema(schemaA); } catch (err: any) {
    console.error(chalk.red(`❌ ${labelA} schema invalid: ${err.message}`));
    return;
  }
  try { buildSchema(schemaB); } catch (err: any) {
    console.error(chalk.red(`❌ ${labelB} schema invalid: ${err.message}`));
    return;
  }

  // 2. Parse & deep-sort ASTs
  const astA = deepSortAst(parse(schemaA, { noLocation: true }));
  const astB = deepSortAst(parse(schemaB, { noLocation: true }));

  // 3. Print sorted SDLs
  const sdlA = print(astA);
  const sdlB = print(astB);

  // 4. Extract per-definition blocks
  const defsA = splitDefinitions(sdlA);
  const defsB = splitDefinitions(sdlB);

  // 5. Compare definitions as whole blocks
  console.log(chalk.bold('📐 Deep GraphQL Schema Diff:'));
  console.log();
  const allNames = Array.from(new Set([...defsA.keys(), ...defsB.keys()])).sort();
  let diffCount=0,count=0,skipped=0;
  allNames.forEach(name => {

    let blockA = defsA.get(name) || '';
    let blockB = defsB.get(name) || '';

    if(filterFn)
      if(!filterFn({definitionName:name,definitionA:blockA,definitionB:blockB})){
        skipped++;
        return;
      }
    count++;

  
    //console.dir({name,blockA,blockB});

    if (!defsA.has(name)) {
      console.log(chalk.green(`+ Definition '${name}' present in '${labelB}', `),chalk.red(`missing in '${labelA}'`));
      diffCount++;
      return;
    }
    if (!defsB.has(name)) {
      console.log(chalk.red(`- Definition '${name}' missing in '${labelB}'`),chalk.green(`present in '${labelA}'`));
      diffCount++;
      throw new Error('Halted! (remove me)');
      return;
    }

    // optional: remove comments and descriptions to simplify diff using a cleanFn
    blockA=cleanFn
      ?cleanFn(blockA)
      :blockA;
    blockB=cleanFn
      ?cleanFn(blockB)
      :blockB;
    
    if (blockA === blockB) {
      // Identical definition, skip
      return;
    }

    diffCount++;
    // Diff the two blocks line-by-line (per definition only)
    console.log(chalk.yellow(`~ Definition '${name}' differs:`));
    const changes: Change[] = diffLines(blockA, blockB);
    changes.forEach(change => {
      const prefix = change.added ? '+ ' : change.removed ? '- ' : '  ';
      const lineFunc = change.added
        ? chalk.green
        : change.removed
        ? chalk.red
        : chalk.reset;
      change.value.split(/\r?\n/).forEach(line => {
        if (line.length) console.log(lineFunc(prefix + line));
      });
    });
    console.log('');
  });
  
  console.log('');
  
  if(diffCount===0)
    console.log(chalk.green(`✅ All ${count} definitions are equal between schemas (${skipped} skipped)`));
  else
    console.log(chalk.red(`❌ ${diffCount}/${count} definitions are different between schemas (${skipped} skipped)`));
  
  console.log('');

  return {
    diffCount,
    count,
  }
}

const presets={
  allChecks:(options?:any)=>({definitionName,definitionA,definitionB}):boolean=>{
    return true;
  },     
  onlyExtras:(options?:any)=>({definitionName,definitionA,definitionB}):boolean=>{
      if(!definitionA)
        return true;
      return false;
  },   
  onlyMissing:(options?:any)=>({definitionName,definitionA,definitionB}):boolean=>{
      if(!definitionB)
        return true;
      return false;
  },  
  onlyDifferencies:(options?:any)=>({definitionName,definitionA,definitionB}):boolean=>{
      if(!!definitionA && definitionB && definitionA!==definitionB)
        return true;
      return false;
  },    
  onlyDifferencesWithoutRootTypes:(options?:any)=>({definitionName,definitionA,definitionB}):boolean=>{
      if((!['query_root','mutation_root','subscription_root'].includes(definitionName)) &&
        (!!definitionA && definitionB && definitionA!==definitionB))
        return true;
      return false;
  },
  whitelist:(options?:{whitelist:string[]})=>({definitionName,definitionA,definitionB}):boolean=>{
      if(options?.whitelist && options?.whitelist.includes(definitionName))
        return true;
      return false;
  },  
};


(async function main() {
    if (require.main === module) {
        const inputFileA = process.argv[2];
        const inputFileB = process.argv[3];
        const presetName  = process.argv[4];
        const whitelistCsv  = process.argv[5];
        
        if (!inputFileA || !inputFileB) {
          console.error(chalk.red(`Usage: ts-node ${argv[1]} <path/to/A.graphql> <path/to/B.graphql> <preset> <preset-options> `));
          return;
        }

        const inputA    = fs.readFileSync(resolve(inputFileA), 'utf8');
        const inputB    = fs.readFileSync(resolve(inputFileB), 'utf8');
        // let labelA    = path.basename(inputFileA);
        // let labelB    = path.basename(inputFileB);
        let labelA    = 'Hasura';
        let labelB    = 'Test';

        const whitelist=whitelistCsv
          ?whitelistCsv.split(',')
          :undefined;
        
        const filterFn=presets[presetName||'allChecks']({whitelist});

        compareGraphqlSchemas(inputA,inputB,labelA,labelB,filterFn,stripGraphQLCommentsAndDescriptions);
        console.log(chalk.bold(`Schema comparison complete between ${labelA} ('${inputFileA}') and ${labelB} ('${inputFileB}').`));
    }
})();


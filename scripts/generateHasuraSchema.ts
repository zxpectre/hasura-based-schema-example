import fs from 'fs';
import path, { resolve } from 'path';
import { CustomRootFields, HasuraMetadataV2, Permissions, QualifiedTable } from "@hasura/metadata"

import { DbInfo, DbWalkerCursor,GeneratorFunction } from './common';
import { argv } from 'process';
import './utils';
import { autoNormalizeCase, normalizeCamelCase, normalizeSnakeCase, toCamelCase, toPascalCase } from './utils';


/// About this script:
///     This script aims to generate the same Hasura generated gql schema using same inputs they are using from a project in production
///     Is quick solution based on text templates, without a proper gql node dependency tree, a work in progress!!! 
///     In order to tackle this complex task I made a smart .graphql schema file diff tool with dynamic test case selection presets
///         📐 to generate, validate and fully compare with Hasura reference file run the shortcut "npm run test"
///

/// Hasura Metadata:
///     Hasura generates the gql schema combining db introspection + metadata files
///     This files are provided in yaml or JSON format and the one used on this project was compiled from many sources into a single JSON file using Hasura web UI
///     Metadata is used for defining/overriding collections, field names, "object and array relations", and permissions like "select", "aggregates", "delete","insert",etc..
///     

/**
 * A wrapper type for the Hasura Metadata File Format
 */
export type HasuraMetadata = {
    tables: { [tableKey: string]: HasuraMetadataV2['tables'][0] }
}


const gqlNumericalTypes = [
    'smallint',
    'Int',
    'bigint',
    'Float',
    'numeric',
    'Boolean'
];
const gqlStringTypes = [
    'bpchar',
    'String',
];
const gqlSortableTypes = [
    'String',
    'smallint',
    'Int',
    'bigint',
    'Float',
    'float8',
    'numeric'
];


/**
 * Type mapping from db schema (normalize postgres types) to GraphQL types used by Hasura
 * 
 * TODO: check, cleanup 
 * 
 * @param dbType 
 * @param isEnum 
 * @returns 
 */
function mapDbTypeToGraphQLType(dbType: string, isEnum: boolean = false): string {
    let gqlType: string;
    if (isEnum) {
        gqlType = dbType; // Enum type name
    } else {
        switch (dbType.toLowerCase()) {
            case 'smallint':
                gqlType = 'smallint';
                break;
            case 'integer':
            case 'int':
                gqlType = 'Int';
                break;
            case 'bigint':
                gqlType = 'bigint';
                break;
            case 'real':
            case 'double precision':
                gqlType = 'Float';
                break;
            case 'float':
                gqlType = 'float8';
                break;
            case 'numeric':
            case 'decimal':
                gqlType = 'numeric';
                break;
            case 'boolean':
                gqlType = 'Boolean';
                break;
            case 'char':
            case 'varchar':
            case 'text':
                gqlType = 'String';
                break;
            case 'character':
                gqlType = 'bpchar';
                break;
            case 'bytea':
            case 'hash32type': // Custom type mapped to bytea
                gqlType = 'bytea';
                break;
            case 'json':
            case 'jsonb':
                gqlType = 'jsonb';
                break;
            case 'timestamp':
            case 'timestamptz':
                gqlType = 'timestamp';
                break;
            case 'date':
                gqlType = 'date';
                break;
            case 'time':
                gqlType = 'time';
                break;
            case 'timetz':
                gqlType = 'timetz';
                break;
            case 'uuid':
                gqlType = 'uuid';
                break;
            case 'interval':
                gqlType = 'interval';
                break;
            default:
                gqlType = 'String'; // Fallback
        }
    }
    return gqlType;
}

function isNumerical(type: string) {
    return gqlNumericalTypes.includes(type);
}
function isSortable(type: string) {
    return gqlSortableTypes.includes(type);
}
/**
 * A db schema walker that calls callbacks on each db, schema, collection, and column.
 * 
 * Callback functions (`callEvent()`) are provided through plugins "events".
 * 
 * Each plugin can 'hook' for events, i.e. "collection end" for running code after walking through all columns in a collection
 * 
 * `callEvent()` generates a `cursor`, a flattened object containing the state of the step being walked on, cursor object is used by plugins to get column names, types, table names, etc..
 * 
 * @param dbInfo The database schema rendered as a JSON using `DbInfo` file format
 * @param plugins List of plugins
 * @returns 
 */
export async function dbWalker<T>(dbInfo: DbInfo, plugins: GeneratorFunction<T>[]): Promise<T> {
    let result: T;

    for (const plugin of plugins) {
        const callEvent = (result: T, cursor: DbWalkerCursor) => plugin(cursor, result, dbInfo);
        result = await callEvent(result, { eventType: 'file', event: 'start', });
        for (const dbName in dbInfo.dbs) {
            result = await callEvent(result, { eventType: 'db', event: 'start', dbName });
            const dbs = dbInfo.dbs[dbName]
            for (const schemaName in dbs.schemas) {
                result = await callEvent(result, { eventType: 'schema', event: 'start', dbName, schemaName });
                const schemas = dbs.schemas[schemaName]
                for (const tableName in schemas.tables) {
                    const table = schemas.tables[tableName]
                    const { isView } = table;
                    result = await callEvent(result, { eventType: 'collection', event: 'start', dbName, schemaName, tableName, isView }); // tables and views
                    for (const fieldName in table.fields) {
                        
                        const field = table.fields[fieldName]
                        result = await callEvent(result, {
                            eventType: 'field', // columns
                            event: 'start',
                            dbName,
                            schemaName,
                            tableName,
                            fieldName,
                            isView,
                            ...field,
                        });

                    }
                    result = await callEvent(result, { eventType: 'collection', event: 'end', dbName, schemaName, tableName, isView });
                }
                result = await callEvent(result, { eventType: 'schema', event: 'end', dbName, schemaName });
            }
            result = await callEvent(result, { eventType: 'db', event: 'end', dbName });
        }
        result = await callEvent(result, { eventType: 'file', event: 'end', });
    }

    return result;
}


/// Hasura Root Field Names: 
///     Default root field name pattern is `${permissionName}_${fieldType}${permissionVariant}` and 'select' permissionName is '' , like `delete_Asset_by_pk` or `Asset`
///
/**
 * Function that return the default Hasura generated root field names 
 * 
 * @param cursor 
 * @returns 
 */
function getRootFieldNames(cursor: DbWalkerCursor) {
    const name = cursor.tableName;
    return {
        delete: `delete_${name}`,
        delete_by_pk: `delete_${name}_by_pk`,
        insert: `insert_${name}`,
        insert_one: `insert_${name}_one`,
        select: `${name}`,
        select_aggregate: `${name}_aggregate`,
        select_by_pk: `${name}_by_pk`,
        update: `update_${name}`,
        update_by_pk: `update_${name}_by_pk`,
    }
}

/// Hasura field names:
///     Preserved as in db, overriden by metadata if override present. i.e. 
///     const fieldName = tableMetadata?.configuration?.custom_column_names?.[cursor.fieldName] ?? getFieldName(cursor);
///
function getFieldName(cursor: DbWalkerCursor) {
    return cursor.fieldName;
}
/// Hasura field type names:
///     Custom field type names from db are preserved as in db unless mapped to gql types, probably overriden by metadata if override present. 
///     Scalar type are mapped, see `mapDbTypeToGraphQLType()` for a raw but somewhat working mapping
///     Derivated definitions from these fieldTypes follow simple patterns and is unknown if metadata can override them. ie `txCount_order_by`
///
function getFieldType(name: string, cursor: DbWalkerCursor) {
    return name;    
}

/**
 * Renders as gql the very basic root types and types definitions required for other definitions, such as scalar types 
 * 
 * Requires for the plugin that calls it to fully populate the `context` record first.
 * @param context object that holds all the required data at schema level to render gql output
 * @returns 
 */
function renderGlobalTypes(context:SchemaContext){
    let result=''

    const allTypes  = Object.values(context.types);

    const gqlCustomTypes = allTypes.filter(item=>item.isUserDefined).map(item=>item.type);
    const gqlTypes=allTypes.filter(item=>!item.isUserDefined).map(item=>item.type);

    result = (result || '') + `
schema {
  query: query_root
  mutation: mutation_root
  subscription: subscription_root
}

"""whether this query should be cached (Hasura Cloud only)"""
directive @cached(
  """measured in seconds"""
  ttl: Int! = 60

  """refresh the cache entry"""
  refresh: Boolean! = false
) on QUERY


"""column ordering options"""
enum order_by {
  """in ascending order, nulls last"""
  asc

  """in ascending order, nulls first"""
  asc_nulls_first

  """in ascending order, nulls last"""
  asc_nulls_last

  """in descending order, nulls first"""
  desc

  """in descending order, nulls first"""
  desc_nulls_first

  """in descending order, nulls last"""
  desc_nulls_last
}


"""ordering argument of a cursor"""
enum cursor_ordering {
  """ascending ordering of the cursor"""
  ASC

  """descending ordering of the cursor"""
  DESC
}

input jsonb_cast_exp {
  String: String_comparison_exp
}

`;



    for (const type of [...gqlTypes, ...gqlCustomTypes]) {
        result = result + `scalar ${type}\n`;
    }

    for (const type of [...gqlTypes, ...gqlCustomTypes]) {
        if (gqlStringTypes.includes(type))
            result = result + `
"""
Boolean expression to compare columns of type "${type}". All fields are combined with logical 'AND'.
"""
input ${type}_comparison_exp {
  _eq: ${type}
  _gt: ${type}
  _gte: ${type}

  """does the column match the given case-insensitive pattern"""
  _ilike: ${type}
  _in: [${type}!]

  """
  does the column match the given POSIX regular expression, case insensitive
  """
  _iregex: ${type}
  _is_null: Boolean

  """does the column match the given pattern"""
  _like: ${type}
  _lt: ${type}
  _lte: ${type}
  _neq: ${type}

  """does the column NOT match the given case-insensitive pattern"""
  _nilike: ${type}
  _nin: [${type}!]

  """
  does the column NOT match the given POSIX regular expression, case insensitive
  """
  _niregex: ${type}

  """does the column NOT match the given pattern"""
  _nlike: ${type}

  """
  does the column NOT match the given POSIX regular expression, case sensitive
  """
  _nregex: ${type}

  """does the column NOT match the given SQL regular expression"""
  _nsimilar: ${type}

  """
  does the column match the given POSIX regular expression, case sensitive
  """
  _regex: ${type}

  """does the column match the given SQL regular expression"""
  _similar: ${type}
}

`;
    else
        result = result + `
"""
Boolean expression to compare columns of type "${type}". All fields are combined with logical 'AND'.
"""
input ${type}_comparison_exp {
  _eq: ${type}
  _gt: ${type}
  _gte: ${type}
  _in: [${type}!]
  _is_null: Boolean
  _lt: ${type}
  _lte: ${type}
  _neq: ${type}
  _nin: [${type}!]
}

`;
}

    return result;
}

/**
 * Renders as gql the definition of root types (query, mutation and subscription), without dependencies
 * 
 * Requires for the plugin that calls it to fully populate the `context` record first.
 * @param context object that holds all the required data at schema level to render gql output
 * @returns 
 */
function renderRootTypes(context: SchemaContext) {

    const allCollections = Object.values(context.collections);
    //console.dir({allCollections});

    function withCollections(
        list: Array<CollectionContext>,
        wrapperCb: (items: string[]) => string,
        itemCb: (item: CollectionContext) => string
    ) {
        if (!list || list.length === 0)
            return '';
        const renderedItems = list.map(item => itemCb(item));
        return wrapperCb(renderedItems);
    }

    function wrap(
        list: Array<ColumnContext>,
        wrapperCb: (items: string[]) => string,
        itemCb: (item: ColumnContext) => string
    ) {
        if (!list || list.length === 0)
            return '';
        const renderedItems = list.map(item => itemCb(item));
        return wrapperCb(renderedItems);
    }


    const result = `

${withCollections(allCollections.filter(collection => !!collection.rootFields.select || !!collection.rootFields.select_aggregate || !!collection.rootFields.select_by_pk),
        lines => `
"""query root"""
type query_root {
${lines.join('\n')}
}    
`,
        collection => {
            let res = '';

            if (collection.rootFields.select)
                res = res + `
  """
  fetch data from the table: "${collection.type}"
  """
  ${collection.rootFields.select}(
    """distinct select on columns"""
    distinct_on: [${collection.type}_select_column!]

    """limit the number of rows returned"""
    limit: Int

    """skip the first n rows. Use only with order_by"""
    offset: Int

    """sort the rows by one or more columns"""
    order_by: [${collection.type}_order_by!]

    """filter the rows returned"""
    where: ${collection.type}_bool_exp
  ): [${collection.type}!]!
  `;

            if (collection.rootFields.select_aggregate)
                res = res + `
  """
  fetch aggregated fields from the table: "${collection.type}"
  """
  ${collection.rootFields.select_aggregate}_aggregate(
    """distinct select on columns"""
    distinct_on: [${collection.type}_select_column!]

    """limit the number of rows returned"""
    limit: Int

    """skip the first n rows. Use only with order_by"""
    offset: Int

    """sort the rows by one or more columns"""
    order_by: [${collection.type}_order_by!]

    """filter the rows returned"""
    where: ${collection.type}_bool_exp
  ): ${collection.type}_aggregate!
`;

            if (collection.rootFields.select_by_pk && collection.primaryKey)
                res = res + `
  """fetch data from the table: "${collection.type}" using primary key columns"""
  ${collection.rootFields.select_by_pk}_by_pk(${collection.primaryKey.fieldName}: ${collection.primaryKey.fieldType}!): Asset
`;

            return res;
        }
    )}













${withCollections(allCollections.filter(collection =>
        !!collection.rootFields.delete || !!collection.rootFields.delete_by_pk ||
        !!collection.rootFields.insert || !!collection.rootFields.insert_one ||
        !!collection.rootFields.update || !!collection.rootFields.update_by_pk),
        lines => `
"""mutation root"""
type mutation_root {
${lines.join('\n')}
}    
`,
        collection => {
            let res = '';

            if (collection.rootFields.delete_by_pk)
                res = res +
                    `
  """
  delete single row from the table: "${collection.type}"
  """
  ${collection.rootFields.delete_by_pk}(${collection.primaryKey.fieldName}: ${collection.primaryKey.fieldType}!): ${collection.type}
`

            if (collection.rootFields.delete)
                res = res +
                    `
  """
  delete data from the table: "${collection.type}"
  """
  ${collection.rootFields.delete}(
    """filter the rows which have to be deleted"""
    where: ${collection.type}_bool_exp!
  ): ${collection.type}_mutation_response
`;

            if (collection.rootFields.insert_one)
                res = res +
                    `
  """
  insert a single row into the table: "${collection.type}"
  """
  ${collection.rootFields.insert_one}(
    """the row to be inserted"""
    object: ${collection.type}_insert_input!

  ${collection?.primaryKey?`
    """upsert condition"""
    on_conflict: ${collection.type}_on_conflict
`:''}
  ): ${collection.type}
`;

            if (collection.rootFields.insert)
                res = res +
                    `
 """
  insert data into the table: "${collection.type}"
  """
  ${collection.rootFields.insert}(
    """the rows to be inserted"""
    objects: [${collection.type}_insert_input!]!
  ): ${collection.type}_mutation_response
`;

            if (collection.rootFields.update)
                res = res +
                    `
  """
  update multiples rows of table: "${collection.type}"
  """
  ${collection.rootFields.update}(
    """updates to execute, in order"""
    updates: [${collection.type}_updates!]!
  ): [${collection.type}_mutation_response]
`;


            if (collection.rootFields.update_by_pk)
                res = res +
                    `
  """
  update single row of the table: "${collection.type}"
  """
  ${collection.rootFields.update_by_pk}(
    """increments the numeric columns with given value of the filtered values"""
    _inc: ${collection.type}_inc_input

    """sets the columns of the filtered rows to the given values"""
    _set: ${collection.type}_set_input
    pk_columns: ${collection.type}_pk_columns_input!
  ): ${collection.type}
`;

            return res;
        }
    )}




${withCollections(allCollections.filter(collection => !!collection.rootFields.select || !!collection.rootFields.select_aggregate || !!collection.rootFields.select_by_pk),// WARNING: not sure about these conditions
        lines => `
"""subscription root"""
type subscription_root {
${lines.join('\n')}
}    
`,
        collection => {
            let res = '';

            if (!!collection.rootFields.select || !!collection.rootFields.select_by_pk) // WARNING: not sure about these conditions
                res = res +
                    `
  """
  fetch data from the table: "${collection.type}"
  """
  ${collection.type}(
    """distinct select on columns"""
    distinct_on: [${collection.type}_select_column!]

    """limit the number of rows returned"""
    limit: Int

    """skip the first n rows. Use only with order_by"""
    offset: Int

    """sort the rows by one or more columns"""
    order_by: [${collection.type}_order_by!]

    """filter the rows returned"""
    where: ${collection.type}_bool_exp
  ): [${collection.type}!]!
`;


            if (!!collection.rootFields.select || !!collection.rootFields.select_by_pk)
                res = res +
                    `
  """
  fetch data from the table in a streaming manner: "${collection.type}"
  """
  ${collection.type}_stream(
    """maximum number of rows returned in a single batch"""
    batch_size: Int!

    """cursor to stream the results returned by the query"""
    cursor: [${collection.type}_stream_cursor_input]!

    """filter the rows returned"""
    where: ${collection.type}_bool_exp
  ): [${collection.type}!]!
`


            if (!!collection.rootFields.select_aggregate)
                res = res +
                    `
  """
  fetch aggregated fields from the table: "${collection.type}"
  """
  ${collection.type}_aggregate(
    """distinct select on columns"""
    distinct_on: [${collection.type}_select_column!]

    """limit the number of rows returned"""
    limit: Int

    """skip the first n rows. Use only with order_by"""
    offset: Int

    """sort the rows by one or more columns"""
    order_by: [${collection.type}_order_by!]

    """filter the rows returned"""
    where: ${collection.type}_bool_exp
  ): ${collection.type}_aggregate!
`


            return res;
        }
    )}

`;


    return result;
}

/// Hasura Permissions and Collection Types
///     In this schema generation permissions over roles (i.e.`cardano_graphql`) specified in Metadata File triggers the generation of a lot of derivated definitions. i.e. `Asset_aggregate` for permission selection aggregate.
///     WARNING: This script generates these derivatives in a clumsy way, generating extra definitions only to make schema valid. Permission-based logic is completely broken. WIP.
///         📐 to check for these extras run "npm run generate:hasura && npm run test:hasura:extras"
///         📐 to check for critically missing definitions run "npm run generate:hasura && npm run test:hasura:missing"
///     Fragments of these definitions depend on fieldType, if type isUserDefined, if it isNumerical, etc..
///     While not perfect, most of this logic has been already figured it out or require polishing, see `renderCollectionTypes() and renderRootTypes()`
///         📐 to check for differences comparing with Hasura reference file run "npm run generate:hasura && npm run test:hasura:differencies"
///

/**
 * Renders as gql the definition of collection types and their dependencies 
 * 
 * Requires for the plugin that calls it to fully populate the `context` and `schemaContext` records first.
 * @param context object that holds all the required data at collection at cursor level to render gql output
 * @param schemaContext object that holds all the required data at schema level to render gql output
 * @returns 
 */
function renderCollectionTypes(context: CollectionContext,schemaContext: SchemaContext) {
    const type = context.type;

    const allFields = Object.values(context.columns);
    const allTypes  = Object.values(schemaContext.types);

    const gqlCustomTypes = allTypes.filter(item=>item.isUserDefined).map(item=>item.type);
    const gqlTypes=allTypes.filter(item=>!item.isUserDefined).map(item=>item.type);

    /*
    console.dir({
        gqlCustomTypes,
        gqlTypes,
    });

    {
        gqlCustomTypes: [
            'scriptpurposetype',
            'rewardtype',
            'scripttype',
            'voterrole',
            'vote',
            'govactiontype',
            'anchortype'
        ],
        gqlTypes: [
            'bigint',    'bytea',
            'Int',       'jsonb',
            'timestamp', 'String',
            'numeric',   'smallint',
            'Boolean',   'float8',
            'bpchar'
        ]
    }
    */

    function wrap(
        list: Array<ColumnContext> | undefined | false,
        wrapperCb: (items: string[]) => string,
        itemCb: (item: ColumnContext) => string,
        removeOnEmptyRender?:boolean,
    ) {
        if (!list || !Array.isArray(list) || list.length === 0)
            return '';
        try{
            const renderedItems = list
                .map(item => itemCb(item))
                .filter(line=>!!line?.trim())
            if(removeOnEmptyRender && renderedItems.length===0)
                return '';
            return wrapperCb(renderedItems);
        }catch(err){
            if(err?.message==='Pass'||err==='Pass')
                return '';
        }
    }

    const must = (...permissions:Permission[]) => context.permissions.every(v => permissions.includes(v));
    const can  = (...permissions:Permission[]) => context.permissions.some(v => permissions.includes(v));

    const result = `
${wrap( allFields,
        lines => `
"""
columns and relationships of "${type}"
"""
type ${type} {
${lines.join('\n')}
}`, item => {
        let res = ''
        if (!item.isUserDefinedType || item.isEnum){
            if(item.fieldType==='jsonb'){
                res=res+`
  ${item.fieldName}(
    """JSON select path"""
    path: String
  ): jsonb${item.isUnique?'!':''}
`
            }else
                res = res + `  ${item.fieldName}: ${item.fieldType}${item.isNotNull ? '!' : ''}${item.comment}`;


        }else {
            if (item.relType === 'obj')
                res = res + `\n  """An object relationship"""\n  ${item.fieldName}: ${item.fieldType}`;
            else
                if (item.relType === 'arr')
                    res = res + `
  """An array relationship"""
  ${item.fieldName}(
    """distinct select on columns"""
    distinct_on: [${item.fieldType}_select_column!]

    """limit the number of rows returned"""
    limit: Int

    """skip the first n rows. Use only with order_by"""
    offset: Int

    """sort the rows by one or more columns"""
    order_by: [${item.fieldType}_order_by!]

    """filter the rows returned"""
    where: ${item.fieldType}_bool_exp
  ): [${item.fieldType}!]!

  ${!schemaContext.collections[`${item.fieldName}_aggregate`]?'':` 
  """An aggregate relationship"""
  ${item.fieldName}_aggregate(
    """distinct select on columns"""
    distinct_on: [${item.fieldType}_select_column!]

    """limit the number of rows returned"""
    limit: Int

    """skip the first n rows. Use only with order_by"""
    offset: Int

    """sort the rows by one or more columns"""
    order_by: [${item.fieldType}_order_by!]

    """filter the rows returned"""
    where: ${item.fieldType}_bool_exp
  ): ${item.fieldType}_aggregate!

  `}
    
`;
        }
        return res;
    })}



${!true?'':  
`
######################################################
# With permission 'select_aggregate' on "${type}" 
######################################################

"""
aggregated selection of "${type}"
"""
type ${type}_aggregate {
  aggregate: ${type}_aggregate_fields
  nodes: [${type}!]!
}


input ${type}_aggregate_bool_exp {
  bool_and: ${type}_aggregate_bool_exp_bool_and
  bool_or: ${type}_aggregate_bool_exp_bool_or
  count: ${type}_aggregate_bool_exp_count
}

input ${type}_aggregate_bool_exp_bool_and {
  arguments: ${type}_select_column_${type}_aggregate_bool_exp_bool_and_arguments_columns!
  distinct: Boolean
  filter: ${type}_bool_exp
  predicate: Boolean_comparison_exp!
}

input ${type}_aggregate_bool_exp_bool_or {
  arguments: ${type}_select_column_${type}_aggregate_bool_exp_bool_or_arguments_columns!
  distinct: Boolean
  filter: ${type}_bool_exp
  predicate: Boolean_comparison_exp!
}

input ${type}_aggregate_bool_exp_count {
  arguments: [${type}_select_column!]
  distinct: Boolean
  filter: ${type}_bool_exp
  predicate: Int_comparison_exp!
}


"""
aggregate fields of "${type}"
"""
type ${type}_aggregate_fields {
  avg: ${type}_avg_fields
  count(columns: [${type}_select_column!], distinct: Boolean): Int!
  max: ${type}_max_fields
  min: ${type}_min_fields
  stddev: ${type}_stddev_fields
  stddev_pop: ${type}_stddev_pop_fields
  stddev_samp: ${type}_stddev_samp_fields
  sum: ${type}_sum_fields
  var_pop: ${type}_var_pop_fields
  var_samp: ${type}_var_samp_fields
  variance: ${type}_variance_fields
}

"""
order by aggregate values of table "${type}"
"""
input ${type}_aggregate_order_by {
  avg: ${type}_avg_order_by
  count: order_by
  max: ${type}_max_order_by
  min: ${type}_min_order_by
  stddev: ${type}_stddev_order_by
  stddev_pop: ${type}_stddev_pop_order_by
  stddev_samp: ${type}_stddev_samp_order_by
  sum: ${type}_sum_order_by
  var_pop: ${type}_var_pop_order_by
  var_samp: ${type}_var_samp_order_by
  variance: ${type}_variance_order_by
}



${wrap(allFields/*WARNING: UNKNOWN CONDITION HERE, APPLYING FOR ALL FIELDS JUST IN CASES.filter(item=>['bool','Boolean'].includes(item.fieldType))*/,
lines => `
"""
select "${type}_aggregate_bool_exp_bool_and_arguments_columns" columns of table "${type}"
"""
enum ${type}_select_column_${type}_aggregate_bool_exp_bool_and_arguments_columns {
${lines.join('\n')}
}`, item => `  """column name"""\n  ${item.fieldName}\n`)}


${wrap(allFields/*WARNING: UNKNOWN CONDITION HERE, APPLYING FOR ALL FIELDS JUST IN CASES.filter(item=>['bool','Boolean'].includes(item.fieldType))*/,
lines => `
"""
select "${type}_aggregate_bool_exp_bool_or_arguments_columns" columns of table "${type}"
"""
enum ${type}_select_column_${type}_aggregate_bool_exp_bool_or_arguments_columns {
${lines.join('\n')}
}`, item => `  """column name"""\n  ${item.fieldName}\n`)}



`
}    





${!can('insert','insert_one')?'':  
`
######################################################
# With permission 'insert' on "${type}" 
######################################################

`}


"""
input type for inserting array relation for remote table "${type}"
"""
input ${type}_arr_rel_insert_input {
  data: [${type}_insert_input!]!
}


"""
input type for inserting object relation for remote table "${type}"
"""
input ${type}_obj_rel_insert_input {
  data: ${type}_insert_input!

  ${context?.primaryKey?`
    """upsert condition"""
    on_conflict: ${type}_on_conflict
`:''}
}

${wrap(allFields.filter(item => !item.isAggregateType),
                    lines => `


"""
input type for inserting data into table "${type}"
"""
input ${type}_insert_input {
${lines.join('\n')}
}`, item => (!item.isUserDefinedType || item.isEnum )
                    ?  `  ${item.fieldName}: ${item.fieldType}`
                    :  `  ${item.fieldName}: ${item.fieldType}_${item.relType}_rel_insert_input`
                    // ?  schemaContext.collections[`${item.fieldType}_${item.relType}_rel_insert_input`]       ?`  ${item.fieldName}: ${item.fieldType}_${item.relType}_rel_insert_input`:''
                    // :  schemaContext.collections[`${item.fieldName}: ${item.fieldType}`]                     ?`  ${item.fieldName}: ${item.fieldType}`:''
,false)}



${wrap(allFields.filter(item => item.fieldType==='jsonb'),
        lines => `
"""append existing jsonb value of filtered columns with new jsonb value"""
input ${type}_append_input {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: ${item.fieldType}`)}




${wrap(allFields.filter(item => item.isNumericalType && !['Boolean'].includes(item.fieldType)),
        lines => `
"""aggregate avg on columns"""
type ${type}_avg_fields {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: Float`)}
${wrap(allFields.filter(item => item.isNumericalType && !['Boolean'].includes(item.fieldType)),
            lines => `
"""
order by avg() on columns of table "${type}"
"""
input ${type}_avg_order_by {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: order_by`)}
${wrap(allFields,
                lines => `
"""
Boolean expression to filter rows from the table "${type}". All fields are combined with a logical 'AND'.
"""
input ${type}_bool_exp {
  _and: [${type}_bool_exp!]
  _not: ${type}_bool_exp
  _or: [${type}_bool_exp!]
${lines.join('\n')}
}`, item => (item.isUserDefinedType && !item.isEnum)
                // ? schemaContext.collections[`${item.fieldType}_bool_exp`]       ?`  ${item.fieldName}: ${item.fieldType}_bool_exp`:''
                // : schemaContext.collections[`${item.fieldType}_comparison_exp`] ?`  ${item.fieldName}: ${item.fieldType}_comparison_exp`:''
                ? `  ${item.fieldName}: ${item.fieldType}_bool_exp`
                : `  ${item.fieldName}: ${item.fieldType}_comparison_exp`
)}




${wrap(allFields.filter(item => item.fieldType==='jsonb'),
        lines => `
"""
delete the field or element with specified path (for JSON arrays, negative integers count from the end)
"""
input ${type}_delete_at_path_input {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: [String!]`)}



${wrap(allFields.filter(item => item.fieldType==='jsonb'),
        lines => `
"""
delete the array element with specified index (negative integers count from the end). throws an error if top level container is not an array
"""
input ${type}_delete_elem_input {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: Int`)}



${wrap(allFields.filter(item => item.fieldType==='jsonb'),
        lines => `
"""
delete key/value pair or string element. key/value pairs are matched based on their key value
"""
input ${type}_delete_key_input {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: String`)}


${wrap(allFields.filter(item => item.fieldType==='jsonb'),
        lines => `
"""prepend existing jsonb value of filtered columns with new jsonb value"""
input ${type}_prepend_input {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: ${item.fieldType}`)}


${wrap(allFields.filter(item => item.fieldName===context?.primaryKey?.fieldName),
            lines => `
"""
on_conflict condition type for table "${type}"
"""
input ${type}_on_conflict {
  constraint: ${type}_constraint!
  update_columns: [${type}_update_column!]! = []
  where: ${type}_bool_exp
}

"""
unique or primary key constraints on table "${type}"
"""
enum ${type}_constraint {
${lines.join('\n')}
}`, item => {
    let res='';

    if(item.isPrimaryKey)        
        res=res+ `  
  """
  unique or primary key constraint on columns "${item.fieldName}"
  """
  ${type}_pkey
`;

    if(item.isUnique)        
        res=res+ `  
  """
  unique or primary key constraint on columns "${item.fieldName}"
  """
  unique_${type}
`;

    return res;
},true)}


${wrap(allFields.filter(item => item.isNumericalType && !['Boolean'].includes(item.fieldType)),
            lines => `
"""
input type for incrementing numeric columns in table "${type}"
"""
input ${type}_inc_input {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: ${item.fieldType}`)}



${wrap(allFields.filter(item => item.isSortableType || item.isEnum),
                        lines => `
"""aggregate max on columns"""
type ${type}_max_fields {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: ${item.fieldType}`)}
${wrap(allFields.filter(item => item.isSortableType),
                            lines => `
"""
order by max() on columns of table "${type}"
"""
input ${type}_max_order_by {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: order_by`)}


"""
response of any mutation on the table "${type}"
"""
type ${type}_mutation_response {
  """number of rows affected by the mutation"""
  affected_rows: Int!

  """data from the rows affected by the mutation"""
  returning: [${type}!]!
}





${wrap(allFields.filter(item => item.fieldName===context?.primaryKey?.fieldName),
            lines => `
"""primary key columns input for table: ${type}"""
input ${type}_pk_columns_input {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: ${item.fieldType}!`)}


${wrap(allFields.filter(item => !item?.isUserDefinedType || item?.isEnum),
                    lines => `
"""
input type for updating data in table "${type}"
"""
input ${type}_set_input {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: ${item.fieldType}`)}

${wrap(allFields.filter(item => !item?.isUserDefinedType || item?.isEnum),
lines => `
"""
update columns of table "${type}"
"""
enum ${type}_update_column {
${lines.join('\n')}
}`, item => `  """column name"""\n  ${item.fieldName}\n`)}


input ${type}_updates {

${!/*can('delete')*/false?'':`
    
  """
  delete the field or element with specified path (for JSON arrays, negative integers count from the end)
  """
  _delete_at_path: ${type}_delete_at_path_input

  """
  delete the array element with specified index (negative integers count from the end). throws an error if top level container is not an array
  """
  _delete_elem: ${type}_delete_elem_input
   
`}

${!/*can('delete_by_pk')*/false?'':`
  """
  delete key/value pair or string element. key/value pairs are matched based on their key value
  """
  _delete_key: ${type}_delete_key_input
`}

${!/*can('insert_one')*/false?'':`
  """append existing jsonb value of filtered columns with new jsonb value"""
  _append: ${type}_append_input

  """
  prepend existing jsonb value of filtered columns with new jsonb value
  """
  _prepend: ${type}_prepend_input

`}

"""
  increments the numeric columns with given value of the filtered values
  """
  _inc: ${type}_inc_input

  """
  sets the columns of the filtered rows to the given values
  """
  _set: ${type}_set_input

  """
  filter the rows which have to be updated
  """
  where: ${type}_bool_exp!
}


${wrap(allFields.filter(item => item.isSortableType || item.isEnum),
                                lines => `
"""aggregate min on columns"""
type ${type}_min_fields {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: ${item.fieldType}`)}
${wrap(allFields.filter(item => item.isSortableType || item.isEnum),
                                    lines => `
"""
order by min() on columns of table "${type}"
"""
input ${type}_min_order_by {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: order_by`)}


${wrap(allFields.filter(item => true/*item?.relType !== 'arr'*/),
lines => `
"""Ordering options when selecting data from "${type}"."""
input ${type}_order_by {
${lines.join('\n')}
}`, item => (item.isUserDefinedType && !item.isEnum)
                ? `  ${item.fieldName}: ${item.fieldType}_order_by`
                : `  ${item.fieldName}: order_by`
)}

${wrap(allFields.filter(item => !item?.isUserDefinedType || item.isEnum),
                                            lines => `
"""
select columns of table "${type}"
"""
enum ${type}_select_column {
${lines.join('\n')}
}`, item => `  """column name"""\n  ${item.fieldName}\n`)}





${wrap(allFields.filter(item => item.isNumericalType && !['Boolean'].includes(item.fieldType)),
                                                lines => `
"""aggregate stddev on columns"""
type ${type}_stddev_fields {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: Float`)}
${wrap(allFields.filter(item => item.isNumericalType && !['Boolean'].includes(item.fieldType)),
                                                    lines => `
"""
order by stddev() on columns of table "${type}"
"""
input ${type}_stddev_order_by {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: order_by`)}
${wrap(allFields.filter(item => item.isNumericalType && !['Boolean'].includes(item.fieldType)),
                                                        lines => `
"""aggregate stddev_pop on columns"""
type ${type}_stddev_pop_fields {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: Float`)}
${wrap(allFields.filter(item => item.isNumericalType && !['Boolean'].includes(item.fieldType)),
                                                            lines => `
"""
order by stddev_pop() on columns of table "${type}"
"""
input ${type}_stddev_pop_order_by {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: order_by`)}
${wrap(allFields.filter(item => item.isNumericalType && !['Boolean'].includes(item.fieldType)),
                                                                lines => `
"""aggregate stddev_samp on columns"""
type ${type}_stddev_samp_fields {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: Float`)}
${wrap(allFields.filter(item => item.isNumericalType && !['Boolean'].includes(item.fieldType)),
                                                                    lines => `
"""
order by stddev_samp() on columns of table "${type}"
"""
input ${type}_stddev_samp_order_by {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: order_by`)}


"""
Streaming cursor of the table "${type}"
"""
input ${type}_stream_cursor_input {
  """Stream column input with initial value"""
  initial_value: ${type}_stream_cursor_value_input!

  """cursor ordering"""
  ordering: cursor_ordering
}


${wrap(allFields.filter(item => !item?.isUserDefinedType || item.isEnum/* && !gqlCustomTypes.includes(item.fieldType)*/),
                                                                        lines => `
"""Initial value of the column from where the streaming should start"""
input ${type}_stream_cursor_value_input {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: ${item.fieldType}`)}


${wrap(allFields.filter(item => item.isNumericalType && !['Boolean'].includes(item.fieldType)),
lines => `
"""aggregate sum on columns"""
type ${type}_sum_fields {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: ${item.fieldType}`)}


${wrap(allFields.filter(item => item.isNumericalType && !['Boolean'].includes(item.fieldType)),
                                                                                lines => `
"""
order by sum() on columns of table "${type}"
"""
input ${type}_sum_order_by {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: order_by`)}
${wrap(allFields.filter(item => item.isNumericalType && !['Boolean'].includes(item.fieldType)),
                                                                                    lines => `
"""aggregate var_pop on columns"""
type ${type}_var_pop_fields {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: Float`)}
${wrap(allFields.filter(item => item.isNumericalType && !['Boolean'].includes(item.fieldType)),
                                                                                        lines => `
"""
order by var_pop() on columns of table "${type}"
"""
input ${type}_var_pop_order_by {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: order_by`)}



${wrap(allFields.filter(item => item.isNumericalType && !['Boolean'].includes(item.fieldType)),
                                                                                            lines => `
"""aggregate var_samp on columns"""
type ${type}_var_samp_fields {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: Float`)}
${wrap(allFields.filter(item => item.isNumericalType && !['Boolean'].includes(item.fieldType)),
                                                                                                lines => `
"""
order by var_samp() on columns of table "${type}"
"""
input ${type}_var_samp_order_by {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: order_by`)}


${wrap(allFields.filter(item => item.isNumericalType && !['Boolean'].includes(item.fieldType)),
                                                                                                    lines => `
"""aggregate variance on columns"""
type ${type}_variance_fields {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: Float`)}
${wrap(allFields.filter(item => item.isNumericalType && !['Boolean'].includes(item.fieldType)),
                                                                                                        lines => `
"""
order by variance() on columns of table "${type}"
"""
input ${type}_variance_order_by {
${lines.join('\n')}
}`, item => `  ${item.fieldName}: order_by`)}
`;
    return result;

}


/**
 * Column record at cursor level
 */
type ColumnContext = {
    fieldName: string,
    fieldType: string,
    formerType?: string,
    isNumericalType?: boolean,
    isSortableType?: boolean,
    isUserDefinedType?: boolean,
    isEnum?: boolean,
    isAggregateType?: boolean,
    isNotNull?: boolean,
    isUnique?: boolean,
    isPrimaryKey?: boolean,
    relType?: 'arr' | 'obj',
    comment?: string,
}
/**
 * Hasura Metadata permissions as custom type
 */
type Permission = 
    'select' |
    'select_by_pk' |
    'select_aggregate' |
    'insert' |
    'insert_one' |
    'update' |
    'update_by_pk' |
    'delete' |
    'delete_by_pk';
/**
 * Table/View record at cursor level
 */
type CollectionContext = {
    type: string,
    rootFields: Partial<CustomRootFields>,
    permissions: Permission[],
    primaryKey?: ColumnContext,
    columns: { [fieldName: string]: ColumnContext }
}

/**
 * Custom field type record
 */
type TypeContext = {    
    type: string,
    dbType:string,
    isUserDefined?:boolean,
    isEnum?:boolean,
    isNumericalType?:boolean,
    isSortableType?:boolean,
    enumValues?:string[],
}

/**
 * Schema record at cursor level
 */
type SchemaContext = {
    collections: { [typeName: string]: CollectionContext },
    types: { [typeName: string]: TypeContext },
}

const EmptyContext = (): SchemaContext => ({
    collections: {},
    types:{}
});

/**
 * The global instance of the schema record at cursor level
 */
let context = EmptyContext();


/**
 * Plugin that populates the global `context` object and then call render functions to generate the gql output
 * @param param0 
 * @param param0.metadata Parsed/normalized Hasura Metadata file 
 * @param param0.schemaNames Schema whitelist for convenience
 * @param param0.role: Hasura role to render gql based on permissions in metadata file
 * @returns 
 */
const RenderHasuraPlugin: (options: {
    metadata?: HasuraMetadata,    
    schemaNames?: string[],
    role: string,
    //TODO: use cursor list with wildcards for filtering 
}) => GeneratorFunction<string> = ({ schemaNames, metadata, role }) => async function RenderHasuraPlugin(cursor, result, dbInfo) {

    if(!result)
        result='';

    if (cursor.eventType === 'file') {
        if (cursor.event === 'end') {
            //console.dir({context});
            result = result + renderGlobalTypes(context);
            result = result + renderRootTypes(context);
            return result;
        }
    }


    if (schemaNames && !schemaNames.includes(cursor.schemaName))
        return result;


    // if(!['ActiveStake'].includes(cursor.tableName))
    //     return result;


    const tableMetadata = metadata.tables[`${cursor?.schemaName}.${cursor?.tableName}`]
    const collectionTypeName = getFieldType(cursor.tableName, cursor);

    if (!tableMetadata)
        return result;

    if (cursor.eventType === 'collection' /*&& cursor.isView===isView*/) {
        if (cursor.event === 'start') {
            context.collections[collectionTypeName] = {
                type: '',
                rootFields: {},
                columns: {},
                permissions:[],
            }
            if (tableMetadata) {
                let permissions:Permission[]=[];
                const rootFields: Partial<CustomRootFields> = {
                    ...getRootFieldNames(cursor),
                    ...tableMetadata?.configuration?.custom_root_fields || {}
                }
                if (!(tableMetadata?.select_permissions || []).some(permission => permission.role === role)) {
                    delete rootFields.select;
                    delete rootFields.select_by_pk;
                }
                if (!(tableMetadata?.select_permissions || []).some(permission => permission.role === role && permission.permission.allow_aggregations)) {
                    delete rootFields.select_aggregate;
                }
                if (!(tableMetadata?.insert_permissions || []).some(permission => permission.role === role)) {
                    delete rootFields.insert;
                    delete rootFields.insert_one;
                }
                if (!(tableMetadata?.update_permissions || []).some(permission => permission.role === role)) {
                    delete rootFields.update;
                    delete rootFields.update_by_pk;
                }
                if (!(tableMetadata?.delete_permissions || []).some(permission => permission.role === role)) {
                    delete rootFields.delete;
                    delete rootFields.delete_by_pk;
                }
                context.collections[collectionTypeName].rootFields = rootFields;
            } else
                context.collections[collectionTypeName].rootFields = {};
            context.collections[collectionTypeName].permissions=Object.keys(context.collections[collectionTypeName].rootFields) as Permission[];
            context.collections[collectionTypeName].type = collectionTypeName;
            return result;
        }

        if (cursor.event === 'end') {
            result = result + renderCollectionTypes(context.collections[collectionTypeName],context);
            return result;
        }
    }

    if (cursor.eventType === 'field' /*&& cursor.isView===isView*/) {
        if (cursor.event === 'start') {

            // if (cursor.isForeign && cursor.relation) {
            //     const relatedTable = cursor.relation.table;
            //     result = result + `  ${relatedTable}: ${relatedTable}\n`;
            // }
            //console.dir({tableMetadata},{depth:8})
            const objectRelation = tableMetadata?.object_relationships?.find((item) => !!item.using.manual_configuration.column_mapping[cursor.fieldName]);
            if (objectRelation) {
                const fieldName = objectRelation?.name;
                const fieldType = (objectRelation?.using?.manual_configuration?.remote_table as QualifiedTable).name;
                context.collections[collectionTypeName].columns[fieldName] = {
                    fieldName,
                    fieldType,
                    isUserDefinedType: true,
                    relType: 'obj',
                };
            }
            const arrayRelation = tableMetadata?.array_relationships?.find((item) => !!item.using.manual_configuration.column_mapping[cursor.fieldName]);
            if (arrayRelation) {
                const fieldName = arrayRelation?.name;
                const fieldType = (arrayRelation?.using?.manual_configuration?.remote_table as QualifiedTable).name;
                const fieldTypeSchema = (arrayRelation?.using?.manual_configuration?.remote_table as QualifiedTable).schema;
                const relationTableMetadata = metadata.tables[`${fieldTypeSchema}.${fieldType}`]
                const relationCanBeAggregated = (relationTableMetadata?.select_permissions || []).some(permission => permission.role === role && permission.permission.allow_aggregations)
                context.collections[collectionTypeName].columns[fieldName] = {
                    fieldName,
                    fieldType,
                    isUserDefinedType: true,
                    relType: 'arr',
                };
                if(relationCanBeAggregated || true)
                    context.collections[collectionTypeName].columns[`${fieldName}_aggregate`] = {
                        fieldName: `${fieldName}_aggregate`,
                        fieldType: `${fieldType}_aggregate`,
                        isUserDefinedType: true,
                        isAggregateType: true,
                    };
            }


            const fieldName = tableMetadata?.configuration?.custom_column_names?.[cursor.fieldName] ?? getFieldName(cursor);
            const isEnum = cursor.isUserDefinedType && !!cursor.enumValues;
            const fieldType = mapDbTypeToGraphQLType(cursor.type, isEnum);   
            context.types[fieldType]={
                type:fieldType,
                dbType:cursor.type,
                isUserDefined:cursor.isUserDefinedType,
                isNumericalType: isNumerical(fieldType),
                isSortableType: isSortable(fieldType),
                isEnum,
                enumValues:cursor.enumValues,
            }
            //let comment=` # ${cursor.isAlias?' field is a view alias, ':''} ${cursor.type} -> ${fieldType}`
            const commentBadges = [
                cursor.isAlias && 'alias',
                cursor.isPrimaryKey && 'primary key',
                cursor.isUserDefinedType && 'custom type'
            ].filter(x => !!x).join('|');
            let comment = `${cursor.fieldName !== fieldName ? `(${cursor.fieldName})` : ''} ${cursor.type !== fieldType ? `(${cursor.type})` : ''} ${commentBadges ? `[${commentBadges}]` : ''}`;
            if (comment.trim())
                comment = ' # ' + comment;

            context.collections[collectionTypeName].columns[fieldName] = {
                fieldName,
                fieldType,
                formerType: cursor.type,
                isNumericalType: isNumerical(fieldType),
                isSortableType: isSortable(fieldType),
                isUserDefinedType: cursor.isUserDefinedType,
                isEnum: cursor.enumValues?.length>0,
                isNotNull: cursor.isNotNull || cursor.isPrimaryKey,
                isUnique: cursor.isUnique || cursor.isPrimaryKey,
                isPrimaryKey: cursor.isPrimaryKey,
                comment,
            };
            if (cursor.isPrimaryKey)
                context.collections[collectionTypeName].primaryKey = context.collections[collectionTypeName].columns[fieldName];

            return result;
        }
    }

    return result;
};

/**
 * CLI feature of the script
 */
(async function main() {
    if (require.main === module) {
        const inputDbSchemaFile = process.argv[2];
        const inputHasuraMetadataFile = process.argv[3];
        const outputFile = process.argv[4];
        if (!inputDbSchemaFile || !inputHasuraMetadataFile || !outputFile){ 
            console.error(`Usage: ts-node ${argv[1]} <path/to/db.json> <path/to/metadata.json> <path/to/output.graphql>`)
            return;
        };
        const dbInfo = JSON.parse(fs.readFileSync(resolve(inputDbSchemaFile), 'utf8'));
        const hasuraMetadataSources = JSON.parse(fs.readFileSync(resolve(inputHasuraMetadataFile), 'utf8'));
        const hasuraMetadataRaw = hasuraMetadataSources?.metadata?.sources[0]; // using compiled metadata exported from Hasura web UI, seems to be bundling all as only 1 source
        const hasuraMetadata: HasuraMetadata = {
            tables: {},
        }
        for (const tableMetadata of hasuraMetadataRaw?.tables ?? []) {
            const { name, schema } = tableMetadata?.table || {}
            hasuraMetadata.tables[`${schema}.${name}`] = tableMetadata;
            //console.log(`Loading table metadata for '${schema}.${name}'`);
        }
        const plugins = [            
            RenderHasuraPlugin({
                schemaNames: ['public'],
                metadata: hasuraMetadata,
                role: "cardano-graphql"
            })
        ];
        const outFile = await dbWalker(dbInfo, plugins);
        fs.writeFileSync(resolve(outputFile), outFile);

        console.log(`✅ Output file written to '${outputFile}' based on '${inputDbSchemaFile}'.`);
    }
})();


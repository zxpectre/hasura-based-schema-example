
export type DbInfo = {
    dbs: {
        [dbName: string]: {
            schemas: {
                [schemaName: string]: {
                    tables: {
                        [tableName: string]: {
                            isView: boolean;
                            description?:string;
                            fields: {
                                [fieldName: string]: {
                                    isNotNull?: boolean;
                                    isUnique?: boolean;
                                    isPrimaryKey?: boolean;
                                    isForeign?: boolean; 
                                    isAlias?: boolean;
                                    isUserDefinedType?:boolean; // for when is a user defined type
                                    type:string; // normalized type mapping
                                    udt:string; // postgresdb internal type (udt_type) 
                                    enumValues?:string[]; //for when isUserDefinedType is true and is an enum
                                    relation?:{ // for when isForeign is true, this is the referenced column
                                        schema: string;
                                        table:  string;
                                        column:  string;
                                    };
                                    description?:string;
                                };
                            };
                        };
                    };
                };
            };
        };
    };
};

export type ColumnInfo=DbInfo['dbs']['']['schemas']['']['tables']['']['fields']['']
export type DbWalkerCursor=({    
    event        : 'start' | 'end' ;
    eventType    : 'file'  | 'db' | 'schema' | 'collection' | 'field';
    dbName      ?: string;
    schemaName  ?: string;
    tableName   ?: string;
    fieldName   ?: string;
    isView      ?: boolean;
}) & Partial<ColumnInfo>;

export type GeneratorFunction<T>=(cursor:DbWalkerCursor,output:T,dbInfo:DbInfo)=>Promise<T|undefined>;


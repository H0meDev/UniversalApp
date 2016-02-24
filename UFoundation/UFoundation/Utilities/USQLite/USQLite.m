//
//  USQLite.m
//  UFoundation
//
//  Created by Think on 16/2/19.
//  Copyright © 2016年 think. All rights reserved.
//

#import "USQLite.h"
#import <sqlite3.h>
#import "UDefines.h"

#pragma mark - USQLiteStatement class

@interface USQLiteStatement : NSObject
{
    sqlite3_stmt *_statement;
}

@end

@implementation USQLiteStatement

- (sqlite3_stmt *)statement
{
    return _statement;
}

- (void)setStatuementWith:(sqlite3_stmt *)statement
{
    _statement = statement;
}

@end

@interface USQLite ()
{
    sqlite3 *_database;
}

@end

#pragma mark - USQLite class

@implementation USQLite

+ (id)sqlite
{
    return [self sqliteWith:nil];
}

+ (id)sqliteWith:(NSString *)dbName
{
    @autoreleasepool
    {
        return [[[self class]alloc]initWith:dbName];
    }
}

- (id)initWith:(NSString *)dbName
{
    self = [super init];
    if (self) {
        // Open database
        [self openWith:dbName];
    }
    
    return self;
}

- (BOOL)openWith:(NSString *)dbName
{
    // Close last
    [self close];
    
    // Open
    if (checkValidNSString(dbName)) {
        // Database path
        NSString *path = [currentDocumentsPath() stringByAppendingPathComponent:dbName];
        NSLog(@"%@", path);
        
        return (SQLITE_OK == sqlite3_open([path UTF8String], &_database));
    }
    
    return NO;
}

- (BOOL)excuteWith:(NSString *)expression
{
    if (_database) {
        char *errmsg = NULL;
        if (SQLITE_OK != sqlite3_exec(_database, [expression UTF8String], NULL, NULL, &errmsg)) {
            // Error
            NSLog(@"CREATE TABLE ERROR: %@", [NSString stringWithUTF8String:errmsg]);
            
            return NO;
        } else {
            // Success
            return YES;
        }
    }
    
    return NO;
}

- (USQLiteStatement *)prepareWith:(NSString *)expression
{
    @autoreleasepool
    {
        if (_database) {
            sqlite3_stmt *stmt;
            sqlite3_prepare_v2(_database, [expression UTF8String], -1, &stmt, NULL);
            
            if (stmt) {
                USQLiteStatement *statement = [[USQLiteStatement alloc]init];
                [statement setStatuementWith:stmt];
                
                return statement;
            }
        }
        
        return nil;
    }
}

- (int)stepWith:(USQLiteStatement *)statement
{
    if (checkClass(statement, USQLiteStatement)) {
        sqlite3_stmt *stmt = [statement statement];
        if (stmt) {
            return sqlite3_step(stmt);
        }
    }
    
    return -1;
}

- (BOOL)stepRowWith:(USQLiteStatement *)statement
{
    return (SQLITE_ROW == [self stepWith:statement]);
}

- (BOOL)stepDoneWith:(USQLiteStatement *)statement
{
    return (SQLITE_DONE == [self stepWith:statement]);
}

- (id)fieldValueWith:(USQLiteStatement *)statement index:(NSInteger)index
{
    id retValue = nil;
    
    if (checkClass(statement, USQLiteStatement) && index >= 0) {
        int column = (int)index;
        sqlite3_stmt *stmt = [statement statement];
        if (stmt) {
            int type = sqlite3_column_type(stmt, column);
            switch (type) {
                case SQLITE_INTEGER:
                {
                    int value = sqlite3_column_int(stmt, column);
                    retValue = [NSNumber numberWithInteger:value];
                }
                    break;
                    
                case SQLITE_FLOAT:
                {
                    double value = sqlite3_column_double(stmt, column);
                    retValue = [NSNumber numberWithDouble:value];
                }
                    break;
                    
                case SQLITE_TEXT:
                {
                    const char *value = (const char *)sqlite3_column_text(stmt, column);
                    if (value) {
                        retValue = [[NSString alloc]initWithUTF8String:value];
                    }
                }
                    break;
                    
                case SQLITE_BLOB:
                {
                    //
                }
                    break;
                    
                case SQLITE_NULL:
                {
                    //
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    return retValue;
}

- (int)fieldIntValueWith:(USQLiteStatement *)statement index:(NSInteger)index
{
    if (checkClass(statement, USQLiteStatement) && index >= 0) {
        int column = (int)index;
        sqlite3_stmt *stmt = [statement statement];
        if (stmt) {
            return sqlite3_column_int(stmt, column);
        }
    }
    
    return NSIntegerMax & 0xFFFFFFFF;
}

- (long long)fieldInt64ValueWith:(USQLiteStatement *)statement index:(NSInteger)index
{
    if (checkClass(statement, USQLiteStatement) && index >= 0) {
        int column = (int)index;
        sqlite3_stmt *stmt = [statement statement];
        if (stmt) {
            return sqlite3_column_int64(stmt, column);
        }
    }
    
    return LONG_MAX;
}

- (double)fieldDoubleValueWith:(USQLiteStatement *)statement index:(NSInteger)index
{
    if (checkClass(statement, USQLiteStatement) && index >= 0) {
        int column = (int)index;
        sqlite3_stmt *stmt = [statement statement];
        if (stmt) {
            return sqlite3_column_double(stmt, column);
        }
    }
    
    return MAXFLOAT;
}

- (const unsigned char*)fieldTextValueWith:(USQLiteStatement *)statement index:(NSInteger)index
{
    if (checkClass(statement, USQLiteStatement) && index >= 0) {
        int column = (int)index;
        sqlite3_stmt *stmt = [statement statement];
        if (stmt) {
            return sqlite3_column_text(stmt, column);
        }
    }
    
    return NULL;
}

- (const unsigned char*)fieldText16ValueWith:(USQLiteStatement *)statement index:(NSInteger)index
{
    if (checkClass(statement, USQLiteStatement) && index >= 0) {
        int column = (int)index;
        sqlite3_stmt *stmt = [statement statement];
        if (stmt) {
            return sqlite3_column_text16(stmt, column);
        }
    }
    
    return NULL;
}

- (void)fieldBindWith:(USQLiteStatement *)statement index:(NSInteger)index value:(id)value
{
    if (checkClass(statement, USQLiteStatement) && index >= 0 && value) {
        int column = (int)index;
        sqlite3_stmt *stmt = [statement statement];
        if (stmt) {
            int type = sqlite3_column_type(stmt, column);
            switch (type) {
                case SQLITE_INTEGER:
                {
                    sqlite3_bind_int(stmt, column, [value intValue]);
                }
                    break;
                    
                case SQLITE_FLOAT:
                {
                    sqlite3_bind_double(stmt, column, [value doubleValue]);
                }
                    break;
                    
                case SQLITE_TEXT:
                {
                    if (checkValidNSString(value)) {
                        sqlite3_bind_text(stmt, column, [value UTF8String], -1, SQLITE_TRANSIENT);
                    }
                }
                    break;
                    
                case SQLITE_BLOB:
                {
                    //
                }
                    break;
                    
                case SQLITE_NULL:
                {
                    //
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
}

- (void)fieldBindWith:(USQLiteStatement *)statement index:(NSInteger)index intValue:(int)value
{
    if (checkClass(statement, USQLiteStatement) && index >= 0) {
        int column = (int)index;
        sqlite3_stmt *stmt = [statement statement];
        if (stmt) {
            sqlite3_bind_int(stmt, column, value);
        }
    }
}

- (void)fieldBindWith:(USQLiteStatement *)statement index:(NSInteger)index int64Value:(int64_t)value
{
    if (checkClass(statement, USQLiteStatement) && index >= 0) {
        int column = (int)index;
        sqlite3_stmt *stmt = [statement statement];
        if (stmt) {
            sqlite3_bind_int64(stmt, column, value);
        }
    }
}

- (void)fieldBindWith:(USQLiteStatement *)statement index:(NSInteger)index doubleValue:(double)value
{
    if (checkClass(statement, USQLiteStatement) && index >= 0) {
        int column = (int)index;
        sqlite3_stmt *stmt = [statement statement];
        if (stmt) {
            sqlite3_bind_double(stmt, column, value);
        }
    }
}

- (void)fieldBindWith:(USQLiteStatement *)statement index:(NSInteger)index textValue:(const char*)value
{
    if (checkClass(statement, USQLiteStatement) && index >= 0) {
        int column = (int)index;
        sqlite3_stmt *stmt = [statement statement];
        if (stmt) {
            sqlite3_bind_text(stmt, column, value, -1, SQLITE_TRANSIENT);
        }
    }
}

- (void)fieldBindWith:(USQLiteStatement *)statement index:(NSInteger)index text16Value:(const char*)value
{
    if (checkClass(statement, USQLiteStatement) && index >= 0) {
        int column = (int)index;
        sqlite3_stmt *stmt = [statement statement];
        if (stmt) {
            sqlite3_bind_text16(stmt, column, value, -1, SQLITE_TRANSIENT);
        }
    }
}

- (void)finalizeWith:(USQLiteStatement *)statement
{
    if (checkClass(statement, USQLiteStatement)) {
        sqlite3_stmt *stmt = [statement statement];
        if (stmt) {
            sqlite3_finalize(stmt);
        }
    }
}

- (void)close
{
    if (_database) {
        sqlite3_close(_database);
    }
}

@end

#pragma mark - UModelSQLiteFieldDescription class

@implementation UModelSQLiteFieldDescription

+ (id)description
{
    @autoreleasepool
    {
        return [[[self class]alloc]init];
    }
}

@end

#pragma mark - UModelSQLite class

@implementation UModelSQLite

- (BOOL)createTableWith:(Class)model
{
    return [self createTableWith:model tableName:nil descriptions:nil];
}

- (BOOL)createTableWith:(Class)model tableName:(NSString *)tbName
{
    return [self createTableWith:model tableName:tbName descriptions:nil];
}

- (BOOL)createTableWith:(Class)model descriptions:(NSArray *)descriptions
{
    return [self createTableWith:model tableName:nil descriptions:descriptions];
}

- (BOOL)createTableWith:(Class)model tableName:(NSString *)tbName descriptions:(NSArray *)descriptions
{
    if (![model isSubclassOfClass:[UModel class]]) {
        return NO;
    }
    
    NSDictionary *fileds = [model propertyMap];
    NSString *expression = @"create table if not exists ";
    NSString *tableName = tbName;
    
    if (!checkValidNSString(tableName)) {
        tableName = NSStringFromClass([model class]);
    }
    
    if (checkValidNSDictionary(fileds)) {
        expression = [expression stringByAppendingString:tableName];
        
        NSString *allPrimaryKeys = @"";
        NSString *allIndexs = @"";
        
        BOOL containsPrimaryKey = NO;
        NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
        for (UModelSQLiteFieldDescription *description in descriptions) {
            [mdict setObject:description forKey:description.fieldName];
            
            if (description.autoincrement) {
                containsPrimaryKey = YES;
            }
            
            if (!containsPrimaryKey) {
                NSString *fieldName = [description.fieldName stringByAppendingString:@","];
                allPrimaryKeys = [allPrimaryKeys stringByAppendingString:fieldName];
            }
            
            if (description.index) {
                NSString *indexName = [description.fieldName stringByAppendingString:@","];
                allIndexs = [allIndexs stringByAppendingString:indexName];
            }
        }
        
        // Primary keys
        if (!containsPrimaryKey && allPrimaryKeys.length > 0) {
            allPrimaryKeys = [allPrimaryKeys substringToIndex:allPrimaryKeys.length - 1];
        } else {
            allPrimaryKeys = @"";
        }
        
        // Indexs
        if (allIndexs.length > 0) {
            allIndexs = [allIndexs substringToIndex:allIndexs.length - 1];
        }
        
        // All fields
        for (NSInteger i = 0; i < fileds.allKeys.count; i ++) {
            if (i == 0) {
                expression = [expression stringByAppendingString:@"("];
            }
            
            NSString *name = fileds.allKeys[i];
            NSString *type = fileds[name];
            
            if ([type hasPrefix:@"@"]) { // Object
                NSString *className = [type substringWithRange:NSMakeRange(2, type.length - 3)];
                Class class = NSClassFromString(className);
                if (class == NULL) {
                    continue;
                }
                
                // NSObject
                type = @"text";
            } else if ([type isEqualToString:@"q"] || [type isEqualToString:@"i"]) {
                type = @"integer";
            } else if ([type isEqualToString:@"d"]) {
                type = @"double";
            } else if ([type isEqualToString:@"f"]) {
                type = @"float";
            }
            
            NSString *component = [NSString stringWithFormat:@"%@ %@",name, type];
            UModelSQLiteFieldDescription *description = mdict[name];
            
            NSString *decoration = @"";
            if (description.autoincrement) {
                decoration = @" primary key autoincrement";
            }
            
            // Unique
            if (description.unique) {
                decoration = [decoration stringByAppendingString:@" unique"];
            }
            
            // Type and others
            if (decoration.length > 0) {
                component = [component stringByAppendingString:decoration];
            }
            
            expression = [expression stringByAppendingString:component];
            
            if (i < (fileds.count - 1)) {
                expression = [expression stringByAppendingString:@","];
            } else {
                // Primary keys
                if (checkValidNSString(allPrimaryKeys)) {
                    allPrimaryKeys = [@", primary key(" stringByAppendingString:allPrimaryKeys];
                    allPrimaryKeys = [allPrimaryKeys stringByAppendingString:@")"];
                    expression = [expression stringByAppendingString:allPrimaryKeys];
                }
                
                expression = [expression stringByAppendingString:@");"];
                
                if (checkValidNSString(allIndexs)) {
                    NSString *expression_ = [NSString stringWithFormat:@"create index if not exists idx_%@ on %@(%@);", tableName, tableName, allIndexs];
                    expression = [expression stringByAppendingString:expression_];
                }
            }
        }
        
        NSLog(@"%@", expression);
        
        return [self excuteWith:expression];
    }
    
    return NO;
}

- (BOOL)insertWith:(UModel *)model
{
    return [self insertWith:model tableName:nil];
}

- (BOOL)insertWith:(UModel *)model tableName:(NSString *)tbName
{
    if (checkClass(model, UModel)) {
        //
    }
    
    return NO;
}

@end

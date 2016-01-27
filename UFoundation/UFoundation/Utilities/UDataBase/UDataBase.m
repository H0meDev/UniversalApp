//
//  UDataBase.m
//  UFoundation
//
//  Created by Think on 16/1/11.
//  Copyright © 2016年 think. All rights reserved.
//

#import "UDataBase.h"
#import <sqlite3.h>
#import "UDefines.h"

@implementation UDataBaseInfo

@end

#pragma mark - UDataBaseTableField

@interface UDataBaseTableField : NSObject

@property (nonatomic, strong) NSString *fieldName;
@property (nonatomic, strong) NSString *fieldDescription; // Type etc.

+ (id)field;

@end

@implementation UDataBaseTableField

+ (id)field
{
    @autoreleasepool
    {
        return [[[self class] alloc]init];
    }
}

@end

#pragma mark - UDataBaseTableConstraint

@implementation UDataBaseTableConstraint

+ (id)constraint
{
    @autoreleasepool
    {
        return [[[self class] alloc]init];
    }
}

@end

#pragma mark - UDataBase

@interface UDataBase ()
{
    UDataBaseInfo *_info;
    sqlite3 *_database;
}

@end

@implementation UDataBase

- (id)initWith:(UDataBaseInfo *)info;
{
    self = [super init];
    if (self) {
        // Configure
        _info = info;
        
        // Open database
        [self openDataBase];
    }
    
    return self;
}

- (BOOL)openDataBase
{
    if (_isOpen) {
        return _isOpen;
    }
    
    if (!_info) {
        return _isOpen;
    }
    
    NSString *filePath = nil;
    if (checkValidNSString(_info.fileName)) {
        filePath = [currentDocumentsPath() stringByAppendingPathComponent:_info.fileName];
    } else if (checkValidNSString(_info.filePath)) {
        filePath = _info.filePath;
    }
    
    if (!checkValidNSString(filePath)) {
        return NO;
    }
    
    _isOpen = (SQLITE_OK == sqlite3_open([filePath UTF8String], &_database));
    
    NSLog(@"DATABASE PATH %@", filePath);
    
    return _isOpen;
}

- (BOOL)createTableWith:(NSString *)table fields:(NSArray *)fields
{
    if (!checkValidNSArray(fields)) {
        return NO;
    }
    
    NSString *expression = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(", table];
    for (UDataBaseTableField *field in fields) {
        if (!checkClass(field, UDataBaseTableField)) {
            continue;
        }
        
        NSString *component = [NSString stringWithFormat:@"%@ %@,", field.fieldName, field.fieldDescription];
        expression = [expression stringByAppendingString:component];
    }
    
    expression = [expression substringToIndex:expression.length - 1];
    expression = [expression stringByAppendingString:@")"];
    
    char *errmsg = NULL;
    if (SQLITE_OK != sqlite3_exec(_database, [expression UTF8String], NULL, NULL, &errmsg)) {
        sqlite3_close(_database);
        _isOpen = NO;
        
        NSLog(@"CREATE TABLE ERROR: %@", [NSString stringWithUTF8String:errmsg]);
        
        return NO;
    }
    
    return YES;
}

- (BOOL)createTableWith:(Class)class
{
    return [self createTableWith:NSStringFromClass(class) model:class];
}

- (BOOL)createTableWith:(NSString *)table model:(Class)class
{
    return [self createTableWith:table model:class constraints:nil];
}

- (BOOL)createTableWith:(NSString *)table model:(Class)class constraints:(NSArray *)constraints
{
    if (![class isSubclassOfClass:[UModel class]]) {
        return NO;
    }
    
    NSArray *properties = [class properties];
    NSMutableArray *fields = [NSMutableArray array];
    
    for (NSDictionary *property in properties) {
        NSString *type = property[@"type"];
        NSString *propertyName = property[@"name"];
        NSString *description = @"";
        
        if ([type isEqualToString:@"q"]) {
            description = @"INTEGER";
        } else if ([type hasPrefix:@"@"]) {
            description = @"TEXT";
        }
        
        for (UDataBaseTableConstraint *constraint in constraints) {
            if ([propertyName isEqualToString:constraint.propertyName]) {
                description = [description stringByAppendingString:@" "];
                description = [description stringByAppendingString:constraint.description];
            }
        }
        
        UDataBaseTableField *field = [UDataBaseTableField field];
        field.fieldName = propertyName;
        field.fieldDescription = description;
        
        [fields addObject:field];
    }
    
    return [self createTableWith:table fields:fields];
}

- (BOOL)insertWith:(UModel *)model
{
    return [self insertWith:model table:NSStringFromClass([model class])];
}

- (BOOL)insertWith:(UModel *)model table:(NSString *)table
{
    if (!model) {
        return NO;
    }
    
    sqlite3_stmt *statement = [self bindWith:model table:table];
    if (sqlite3_step(statement) != SQLITE_DONE) {
        sqlite3_finalize(statement);
        
        NSLog(@"INSERT INTO TABLE ERROR");
        
        return NO;
    }
    
    return YES;
}

- (void)insertWithArray:(NSArray *)models
{
    if (checkValidNSArray(models)) {
        Class class = [[models firstObject] class];
        if ([class isSubclassOfClass:[UModel class]]) {
            NSString *className = NSStringFromClass(class);
            [self insertWithArray:models table:className];
        }
    }
}

- (void)insertWithArray:(NSArray *)models table:(NSString *)table
{
    for (UModel *model in models) {
        sqlite3_stmt *statement = [self bindWith:model table:table];
        if (sqlite3_step(statement) != SQLITE_DONE) {
            sqlite3_finalize(statement);
            
            NSLog(@"INSERT INTO TABLE ERROR");
        }
    }
}

- (sqlite3_stmt *)bindWith:(UModel *)model table:(NSString *)table
{
    NSString *expression = [NSString stringWithFormat:@"INSERT INTO %@ (", table];
    NSArray *properties = [[model class]properties];
    NSString *components = @"(";
    
    for (NSDictionary *property in properties) {
        NSString *fieldName = property[@"name"];
        NSString *component = [NSString stringWithFormat:@"%@,", fieldName];
        
        expression = [expression stringByAppendingString:component];
        components = [components stringByAppendingString:@"?,"];
    }
    
    components = [components substringToIndex:components.length - 1];
    components = [components stringByAppendingString:@")"];
    
    expression = [expression substringToIndex:expression.length - 1];
    expression = [expression stringByAppendingString:@") VALUES "];
    expression = [expression stringByAppendingString:components];
    
    // Bind
    sqlite3_stmt *statement = NULL;
    if (SQLITE_OK == sqlite3_prepare_v2(_database, [expression UTF8String], -1, &statement, NULL)) {
        for (NSDictionary *property in properties) {
            NSInteger index = [properties indexOfObject:property] + 1;
            NSString *fieldName = property[@"name"];
            NSString *type = property[@"type"];
            id fieldValue = [model valueForKey:fieldName];
            
            if ([type isEqualToString:@"q"]) {
                sqlite3_bind_int(statement, (int)index, [fieldValue intValue]);
            } else if ([type hasPrefix:@"@"]) {
                sqlite3_bind_text(statement, (int)index, [fieldValue UTF8String], -1, NULL);
            }
        }
    }
    
    return statement;
}

- (NSArray *)selectWith:(Class)class conditions:(NSArray *)conditions
{
    NSString *table = NSStringFromClass(class);
    
    return [self selectWith:class conditions:conditions table:table];
}

- (NSArray *)selectWith:(Class)class conditions:(NSArray *)conditions table:(NSString *)table
{
    NSString *condition = @"";
    
    return [self selectWith:class condition:condition from:table];
}

- (NSArray *)selectWith:(Class)class condition:(NSString *)condition from:(NSString *)table
{
    NSArray *properties = [class properties];
    NSString *fields = @"";
    for (NSDictionary *dict in properties) {
        NSString *component = [NSString stringWithFormat:@"%@,", dict[@"name"]];
        fields = [fields stringByAppendingString:component];
    }
    
    fields = [fields substringToIndex:fields.length - 1];
    
    NSString *expression = [NSString stringWithFormat:@"SELECT %@ FROM %@", fields, table];
    if (checkValidNSString(condition)) {
        NSString *components = [NSString stringWithFormat:@"WHERE %@", condition];
        expression = [expression stringByAppendingString:components];
    }
    
    NSMutableArray *marray = [NSMutableArray array];
    
    // Select
    sqlite3_stmt *statement = NULL;
    if (SQLITE_OK == sqlite3_prepare_v2(_database, [expression UTF8String], -1, &statement, NULL)) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            @autoreleasepool
            {
                UModel *model = [class model];
                for (NSDictionary *property in properties) {
                    NSString *type = property[@"type"];
                    int index = (int)[properties indexOfObject:property];
                    
                    id value = nil;
                    if ([type isEqualToString:@"q"]) {
                        value = @(sqlite3_column_int(statement, index));
                    } else if ([type hasPrefix:@"@"]) {
                        const char *cvalue = (const char*)sqlite3_column_text(statement, index);
                        if (cvalue != NULL) {
                            value = [NSString stringWithUTF8String:cvalue];
                        }
                    }
                    
                    if (value) {
                        NSString *propertyName = property[@"name"];
                        [model setValue:value forKey:propertyName];
                    }
                }
                
                [marray addObject:model];
            }
        }
    }
    
    return [marray copy];
}

@end

//
//  USQLite.h
//  UFoundation
//
//  Created by Think on 16/2/19.
//  Copyright © 2016年 think. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UModel.h"

@class USQLiteStatement;

@interface USQLite : NSObject

// Class methods
+ (id)sqlite;
+ (id)sqliteWith:(NSString *)dbName;

// Init sqlite database file
- (id)initWith:(NSString *)dbName;

// Open database
- (BOOL)openWith:(NSString *)dbName;

// Excute SQL
- (BOOL)excuteWith:(NSString *)expression;

// SQL prepare & statement
- (USQLiteStatement *)prepareWith:(NSString *)expression;
- (BOOL)stepRowWith:(USQLiteStatement *)statement;
- (BOOL)stepDoneWith:(USQLiteStatement *)statement;

// Get field value
- (id)fieldValueWith:(USQLiteStatement *)statement index:(NSInteger)index;
- (int)fieldIntValueWith:(USQLiteStatement *)statement index:(NSInteger)index;
- (long long)fieldInt64ValueWith:(USQLiteStatement *)statement index:(NSInteger)index;
- (double)fieldDoubleValueWith:(USQLiteStatement *)statement index:(NSInteger)index;
- (const unsigned char*)fieldTextValueWith:(USQLiteStatement *)statement index:(NSInteger)index;
- (const unsigned char*)fieldText16ValueWith:(USQLiteStatement *)statement index:(NSInteger)index;

// Bind field
- (void)fieldBindWith:(USQLiteStatement *)statement index:(NSInteger)index value:(id)value;
- (void)fieldBindWith:(USQLiteStatement *)statement index:(NSInteger)index intValue:(int)value;
- (void)fieldBindWith:(USQLiteStatement *)statement index:(NSInteger)index int64Value:(int64_t)value;
- (void)fieldBindWith:(USQLiteStatement *)statement index:(NSInteger)index doubleValue:(double)value;
- (void)fieldBindWith:(USQLiteStatement *)statement index:(NSInteger)index textValue:(const char*)value;
- (void)fieldBindWith:(USQLiteStatement *)statement index:(NSInteger)index text16Value:(const char*)value;

// Finalize statement
- (void)finalizeWith:(USQLiteStatement *)statement;

// Close database
- (void)close;

@end

/*
 * UModelSQLite
 * UModel + USQLite
 */

@interface UModelSQLiteFieldDescription : NSObject

@property (nonatomic, strong) NSString *fieldName;
@property (nonatomic, assign) BOOL autoincrement; // Autoincrement or not
@property (nonatomic, assign) BOOL primaryKey;    // Primary key or not
@property (nonatomic, assign) BOOL index;         // Index or not
@property (nonatomic, assign) BOOL unique;        // Unique key or not

+ (id)description;

@end

@interface UModelSQLite : USQLite

/*
 * Create table
 */
// Create table with model, table name is model class name
- (BOOL)createTableWith:(Class)model;
// Create table with model, customized name
- (BOOL)createTableWith:(Class)model tableName:(NSString *)tbName;
// Create table with model, descriptions: array of UModelSQLiteFieldDescription
- (BOOL)createTableWith:(Class)model descriptions:(NSArray *)descriptions;
// Create table with model, customized name, descriptions: array of UModelSQLiteFieldDescription
- (BOOL)createTableWith:(Class)model tableName:(NSString *)tbName descriptions:(NSArray *)descriptions;

/*
 * Insert model
 */
- (BOOL)insertWith:(UModel *)model;
- (BOOL)insertWith:(UModel *)model tableName:(NSString *)tbName;

@end

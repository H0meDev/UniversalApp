//
//  UDataBase.h
//  UFoundation
//
//  Created by Think on 16/1/11.
//  Copyright © 2016年 think. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UModel.h"

@interface UDataBaseInfo : NSObject

@property (nonatomic, strong) NSString *fileName;  // Name of databse file, default bundle path.
@property (nonatomic, strong) NSString *filePath;  // Full path of database, works when fileName is invalidate

@end

@interface UDataBaseTableConstraint : NSObject

@property (nonatomic, strong) NSString *propertyName;  // Property name
@property (nonatomic, strong) NSString *constraint;    // Constraint for property

+ (id)constraint;

@end

@interface UDataBaseTableCondition : NSObject

@property (nonatomic, strong) NSString *propertyName;  // Property name
@property (nonatomic, strong) NSString *condition;     // Condition for property

+ (id)constraint;

@end

@interface UDataBase : NSObject

@property (nonatomic, readonly) BOOL isOpen;

// Init & open database with info
- (id)initWith:(UDataBaseInfo *)info;

// Open database
- (BOOL)openDataBase;

// Create table from UModel
- (BOOL)createTableWith:(Class)class; // Table name is class name of model
- (BOOL)createTableWith:(NSString *)table model:(Class)class; // From self properties
- (BOOL)createTableWith:(NSString *)table model:(Class)class constraints:(NSArray *)constraints; // constraints: array of UDataBaseTableConstraint

// Insert model(s)
- (BOOL)insertWith:(UModel *)model;
- (BOOL)insertWith:(UModel *)model table:(NSString *)table;
- (void)insertWithArray:(NSArray *)models;
- (void)insertWithArray:(NSArray *)models table:(NSString *)table;

// Select models
- (NSArray *)selectWith:(Class)class conditions:(NSArray *)conditions; // conditions: array of UDataBaseTableCondition
- (NSArray *)selectWith:(Class)class conditions:(NSArray *)conditions table:(NSString *)table;

@end

//
//  USQLite.h
//  UFoundation
//
//  Created by Think on 16/2/19.
//  Copyright © 2016年 think. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UModel.h"

@interface USQLiteFiledItem : UModel

@end

@interface USQLite : NSObject

// Init sqlite database file
- (id)initWith:(NSString *)fileName;

// Open & close database
- (BOOL)openDatabaseWith:(NSString *)dbName;
- (void)closeDatabase;

// Create table if not exists
- (BOOL)createTableWith:(NSString *)tbName;

// Open & close table
- (BOOL)openTableWith:(NSString *)tbName;
- (void)closeTable:(NSString *)tbName;

// Insert single item
- (BOOL)insertWith:(NSArray *)item table:(NSString *)tbName;
- (BOOL)insertWith:(NSArray *)item table:(NSString *)tbName condition:(NSString *)condition;

@end

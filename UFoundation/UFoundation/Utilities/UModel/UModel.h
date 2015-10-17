//
//  UModel.h
//  UFoundation
//
//  Created by Think on 15/5/23.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * UModel is working for JSON
 */
@interface UModel : NSObject

// Init
+ (id)model;

// Init with model, deep copy
+ (id)modelWithModel:(UModel *)model;

// Init with NSString
+ (id)modelWithJSONString:(NSString *)string;

// Init with NSDictionary
+ (id)modelWithDictionary:(NSDictionary *)dict;

// Init with NSArray
+ (id)modelWithArray:(NSArray *)array;

// Model to NSDictionary
- (NSDictionary *)dictionary;

// Model to NSDictionary with UModel key
- (NSDictionary *)dictionaryWithModelKey;

// Model compare
- (BOOL)isEuqualToModel:(UModel *)model;

@end

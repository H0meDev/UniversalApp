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

// Properties of model
+ (NSArray *)properties;

// Init
+ (id)model;

// Init with NSData
+ (id)modelWithJSONData:(NSData *)data;

// Init with NSString
+ (id)modelWithJSONString:(NSString *)string;

// Init with NSDictionary
+ (id)modelWithDictionary:(NSDictionary *)dict;

// Init with NSArray
+ (NSArray *)modelsWithArray:(NSArray *)array;

// Init with model, deep copy
+ (id)modelWithModel:(UModel *)model;

// Model array to JSON (NSDictionary) array
+ (NSArray *)arrayWithModels:(NSArray *)array;

// Model array to JSON (NSDictionary) array with UModel key
+ (NSArray *)arrayAndKeysWithModels:(NSArray *)array;

// Init with model
- (id)initWithModel:(UModel *)model;

// Model to NSDictionary
- (NSDictionary *)dictionary;

// Model to NSDictionary with UModel key
- (NSDictionary *)dictionaryWithModelKey;

// Model compare
- (BOOL)isEuqualToModel:(UModel *)model;

@end

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

// Exclude properties : NSString type
@property (nonatomic, strong) NSArray *excludeProperties;

// Properties of model
+ (NSArray *)propertyArray;

// Properties map
+ (NSDictionary *)propertyMap;

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

// Model array to JSON (NSDictionary) array contained UModel keys
+ (NSArray *)arrayContainedkeysWithModels:(NSArray *)array;

// Init with model
- (id)initWithModel:(UModel *)model;

// Properties array of model exclude with excludeProperties
- (NSArray *)propertyArray;

// Properties map of model exclude with excludeProperties
- (NSDictionary *)propertyMap;

// Model to NSDictionary
- (NSDictionary *)dictionary;

// Model to NSDictionary with UModel key
- (NSDictionary *)dictionaryWithModelKey;

// Model compare
- (BOOL)isEuqualToModel:(UModel *)model;

@end

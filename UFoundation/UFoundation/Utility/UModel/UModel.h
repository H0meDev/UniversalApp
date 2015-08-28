//
//  UModel.h
//  UFoundation
//
//  Created by Think on 15/5/23.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * UModel is working for NSDictionary(JSON) to model or model to NSDictionary
 */
@interface UModel : NSObject

// Init
+ (id)model;

// Init with dictionary
+ (id)modelWith:(NSDictionary *)dict;

// Model to NSDictionary
- (NSDictionary *)dictionary;

@end

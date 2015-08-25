//
//  NSDictionary+UAExtension.h
//  UniversalApp
//
//  Created by Cailiang on 15/1/8.
//  Copyright (c) 2015年 Cailiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (UAExtension)

// NSDictionary to JSON
- (NSString *)JSONString;

// For convenient
- (NSDictionary *)setValue:(id)value forKey:(NSString *)key;

@end

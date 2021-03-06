//
//  NSDictionary+UAExtension.m
//  UniversalApp
//
//  Created by Cailiang on 15/1/8.
//  Copyright (c) 2015年 Cailiang. All rights reserved.
//

#import "NSDictionary+UAExtension.h"
#import "NSObject+UAExtension.h"

@implementation NSDictionary (UAExtension)

- (NSString *)JSONString
{
    NSError *error = nil;
    NSDictionary *JSONObject = [NSDictionary dictionaryWithDictionary:self];
    if ([NSJSONSerialization isValidJSONObject:JSONObject]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:JSONObject
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
        if (error) {
            return nil;
        }
        
        NSString *json = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        json = [json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        return json;
    }
    
    return nil;
}

- (NSDictionary *)setValue:(id)value withKey:(NSString *)key
{
    NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:self];
    [mdict setValue:value forKey:key];
    
    return [mdict copy];
}

@end

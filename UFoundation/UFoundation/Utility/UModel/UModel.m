//
//  UModel.m
//  UFoundation
//
//  Created by Think on 15/5/23.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UModel.h"
#import <objc/runtime.h>
#import "NSObject+UAExtension.h"

@implementation UModel

+ (instancetype)model
{
    return [self instance];
}

+ (instancetype)modelWith:(NSDictionary *)dict
{
    @autoreleasepool
    {
        UModel *model = [self model];
        if (![dict isKindOfClass:[NSDictionary class]]) {
            return model;
        }
        
        NSArray *properties = [model properties];
        for (NSDictionary *item in properties) {
            @try
            {
                NSString *name = item[@"name"];
                NSString *type = item[@"type"];
                
                // For illegal name
                NSString *rname = [NSString stringWithString:name];
                if ([rname hasSuffix:@"_"] && rname.length > 0) {
                    rname = [rname substringToIndex:rname.length - 1];
                }
                
                Class class = NULL;
                if ([type hasPrefix:@"@\""]) {
                    // Get class name
                    NSRange range = NSMakeRange(2, type.length - 3);
                    NSString *className = [type substringWithRange:range];
                    
                    // Check model
                    class = NSClassFromString(className);
                    if (![class isSubclassOfClass:[UModel class]]) {
                        class = NULL;
                    }
                }
                
                id value = [dict objectForKey:rname];
                if (value) {
                    if (class) {
                        // To model again
                        value = [class modelWith:value];
                    }
                    
                    // Set value for model
                    [model setValue:value forKey:name];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception.description);
            }
        }
        
        return model;
    }
}

- (NSDictionary *)dictionary
{
    @autoreleasepool
    {
        // Get current properties
        NSArray *properties = [self properties];
        NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
        
        // Set value
        for (NSDictionary *item in properties) {
            @try
            {
                NSString *name = item[@"name"];
                NSString *type = item[@"type"];
                
                Class class = NULL;
                if ([type hasPrefix:@"@\""]) {
                    // Get class name
                    NSRange range = NSMakeRange(2, type.length - 3);
                    NSString *className = [type substringWithRange:range];
                    
                    // Check model
                    class = NSClassFromString(className);
                    if (![class isSubclassOfClass:[UModel class]]) {
                        class = NULL;
                    }
                }
                
                // Get value object
                id value = [self valueForKey:name];
                value = (value)?value:@"";
                
                // For illegal name
                if ([name hasSuffix:@"_"] && name.length > 0) {
                    name = [name substringToIndex:name.length - 1];
                }
                
                if (value) {
                    if (class) {
                        // To NSDictionary again
                        UModel *model = (UModel *)value;
                        value = [model dictionary];
                    }
                    
                    // Set value for NSDictionary
                    [mdict setObject:value forKey:name];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception.description);
            }
        }
        
        return mdict;
    }
}

- (NSArray *)properties
{
    @autoreleasepool
    {
        NSMutableArray *mArray = [NSMutableArray array];
        Class current = [self class];
        
        while (1) {
            @try
            {
                NSString *className = NSStringFromClass(current);
                if ([className isEqualToString:@"NSObject"]) { // Get all properties
                    break;
                }
                
                Class class = objc_getClass([className UTF8String]);
                unsigned int propert_count = 0;
                unsigned int ivar_count = 0;
                objc_property_t *properties = class_copyPropertyList(class, &propert_count);
                Ivar *ivars = class_copyIvarList(class, &ivar_count);
                
                // Keep safe
                int count = (propert_count >= ivar_count)?ivar_count:propert_count;
                for (int i = 0; i < count; i++) {
                    const char *type_name = ivar_getTypeEncoding(ivars[i]);
                    if (!type_name || strlen(type_name) < 1) {
                        i ++;
                        continue;
                    }
                    
                    // Get property name
                    objc_property_t property = properties[i];
                    const char *property_name = property_getName(property);
                    
                    // Record property type & name
                    NSString *name = [[NSString alloc]initWithCString:property_name encoding:NSUTF8StringEncoding];
                    NSString *type = [[NSString alloc]initWithCString:type_name encoding:NSUTF8StringEncoding];
                    [mArray addObject:@{@"name":name, @"type":type}];
                }
                
                // Clear ivar
                free(ivars);
                ivars = NULL;
                
                // Clear properties
                free(properties);
                properties = NULL;
            }
            @catch (NSException *exception)
            {
                NSLog(@"%@",exception);
            }
            @finally
            {
                // Next class level
                current = [current superclass];
            }
        }
        
        return mArray;
    }
}

- (void)dealloc
{
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

@end

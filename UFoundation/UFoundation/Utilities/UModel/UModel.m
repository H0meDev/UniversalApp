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
#import "NSString+UAExtension.h"

@interface UModel ()

+ (NSArray *)properties;
- (id)initWithModel:(UModel *)model;

@end

@implementation UModel

+ (id)model
{
    return [self instance];
}

+ (id)modelWithModel:(UModel *)model
{
    @autoreleasepool
    {
        return [[self alloc]initWithModel:model];
    }
}

+ (id)modelWith:(NSDictionary *)dict
{
    @autoreleasepool
    {
        UModel *model = [self model];
        if (![dict isKindOfClass:[NSDictionary class]]) {
            return model;
        }
        
        NSArray *properties = [[model class] properties];
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
                }
                
                id value = [dict objectForKey:rname];
                if (value) {
                    // To model again
                    if (![class isSubclassOfClass:[NSArray class]]) {
                        value = [self valueWithValue:value class:class];
                    } else {
                        // For NSArray
                        NSMutableArray *marray = [NSMutableArray array];
                        for (id item in value) {
                            NSString *className = nil;
                            if ([item isKindOfClass:[NSDictionary class]]) {
                                className = item[@"UModelClassNameKey"];
                                if ([className isKindOfClass:[NSString class]] && className.length > 0) {
                                    id model = [self valueWithValue:item class:NSClassFromString(className)];
                                    if (model) {
                                        [marray addObject:model];
                                    } else {
                                        [marray addObject:item];
                                    }
                                } else {
                                    className = nil;
                                }
                            }
                            
                            if (!className) {
                                NSString *suffix = [NSString stringWithFormat:@"%@Item", rname];
                                className = NSStringFromClass([self class]);
                                className = [className stringByAppendingString:suffix];
                                class = NSClassFromString(className);
                                
                                value = [class modelWith:item];
                                value = value?value:item;
                                [marray addObject:value];
                            }
                        }
                        
                        value = marray;
                    }
                    
                    // Final value
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

+ (id)valueWithValue:(id)value class:(Class)class
{
    if (!class) {
        return value;
    }
    
    if ([class isSubclassOfClass:[NSDictionary class]]) {
        value = [class modelWith:value];
    } else if ([class isSubclassOfClass:[UModel class]]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            value = [class modelWith:value];
        } else if ([value isKindOfClass:[NSString class]]) {
            NSDictionary *dict = [value JSONValue];
            if (dict) {
                value = [class modelWith:dict];
            }
        }
    }
    
    return value;
}

- (id)initWithModel:(UModel *)model
{
    self = [super init];
    if (self) {
        // Deep copy from model
        [self copyValuesWithModel:model];
    }
    
    return self;
}

- (void)copyValuesWithModel:(UModel *)model
{
    NSArray *properties = [[model class] properties];
    for (NSDictionary *item in properties) {
        NSString *name = item[@"name"];
        NSString *type = item[@"type"];
        
        if ([type hasPrefix:@"@\""]) {
            // NSObject
            [self valueWithObject:[model valueForKey:name] key:name];
        } else {
            [self setValue:[model valueForKey:name] forKey:name];
        }
    }
}

- (id)valueWithObject:(id)object key:(NSString *)keyName
{
    id value = nil;
    if ([object isKindOfClass:[NSArray class]]) { // NSArray
        NSMutableArray *marray = [NSMutableArray array];
        for (id item in object) {
            id retValue = [self valueWithObject:item key:keyName];
            if (retValue) {
                [marray addObject:retValue];
            }
        }
        // Set array value
        [self setValue:marray forKey:keyName];
    } else if ([object isKindOfClass:[UModel class]]) { // Model
        value = [[object class] modelWithModel:object];
        [self setValue:value forKey:keyName];
    } else if ([object isKindOfClass:[NSString class]]) { // NSString
        value = [NSString stringWithFormat:@"%@", object];
        [self setValue:value forKey:keyName];
    } else if ([object isKindOfClass:[NSDictionary class]]) { // NSDictionary
        value = [NSDictionary dictionaryWithDictionary:object];
        [self setValue:value forKey:keyName];
    } else if ([object isKindOfClass:[NSData class]]) { // NSData
        value = [NSData dataWithData:object];
        [self setValue:value forKey:keyName];
    } else if ([object isKindOfClass:[NSValue class]]) { // NSValue
        value = [NSValue valueWithNonretainedObject:object];
        [self setValue:value forKey:keyName];
    }
    
    return value;
}

- (NSDictionary *)dictionary
{
    return [self dictionaryWithModelKey:NO];
}

- (NSDictionary *)dictionaryWithModelKey
{
    return [self dictionaryWithModelKey:YES];
}

- (NSDictionary *)dictionaryWithModelKey:(BOOL)contains
{
    @autoreleasepool
    {
        // Get current properties
        NSArray *properties = [[self class] properties];
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
                }
                
                // Get value object
                id value = [self valueForKey:name];
                if (!value) {
                    __autoreleasing id object = [[class alloc]init];
                    value = object;
                }
                
                // For illegal name
                if ([name hasSuffix:@"_"] && name.length > 0) {
                    name = [name substringToIndex:name.length - 1];
                }
                
                if (value) {
                    if (class) {
                        // To NSDictionary again
                        value = [self dictionaryWithValue:value contains:contains];
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

- (id)dictionaryWithValue:(id)value contains:(BOOL)contains
{
    if ([value isKindOfClass:[UModel class]]) {
        UModel *model = (UModel *)value;
        if (model) {
            NSDictionary *dict = [model dictionaryWithModelKey:contains];
            if (contains) {
                NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:dict];
                [mdict setValue:NSStringFromClass([model class]) forKey:@"UModelClassNameKey"];
                dict = mdict;
            }
            value = dict;
        }
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSMutableArray *marray = [NSMutableArray array];
        for (id item in value) {
            [marray addObject:[self dictionaryWithValue:item contains:contains]];
        }
        
        value = marray;
    }
    
    return value;
}

+ (NSArray *)properties
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

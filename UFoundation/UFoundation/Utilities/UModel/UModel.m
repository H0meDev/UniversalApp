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
#import "NSDictionary+UAExtension.h"

NSString * const UModelClassNameKey = @"__UMODEL_CLASS_NAME_KEY__";

@interface UModel ()

@end

@implementation UModel

+ (NSArray *)propertyArray
{
    @autoreleasepool
    {
        NSMutableArray *marray = [NSMutableArray array];
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
                    const char *property_name = ivar_getName(ivars[i]);
                    
                    // Record property type & name
                    NSString *name = [[NSString alloc]initWithCString:property_name encoding:NSUTF8StringEncoding];
                    NSString *type = [[NSString alloc]initWithCString:type_name encoding:NSUTF8StringEncoding];
                    
                    if (!([name isEqualToString:@"_excludeProperties"])) {
                        [marray addObject:@{@"name":[name substringFromIndex:1], @"type":type}];
                    }
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
        
        return [marray copy];
    }
}

+ (NSDictionary *)propertyMap
{
    @autoreleasepool
    {
        NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
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
                    const char *property_name = ivar_getName(ivars[i]);
                    
                    // Record property type & name
                    NSString *name = [[NSString alloc]initWithCString:property_name encoding:NSUTF8StringEncoding];
                    NSString *type = [[NSString alloc]initWithCString:type_name encoding:NSUTF8StringEncoding];
                    
                    if (!([name isEqualToString:@"_excludeProperties"])) {
                        [mdict setObject:type forKey:[name substringFromIndex:1]];
                    }
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
        
        return [mdict copy];
    }
}

+ (id)model
{
    return [self instance];
}

+ (id)modelWithJSONData:(NSData *)data
{
    if (!(data && [data isKindOfClass:[NSData class]]) || data.length == 0) {
        return [[self class]model];
    }
    
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingAllowFragments
                                                           error:&error];
    if (error) {
        return [[self class]model];
    }
    
    return [[self class]modelWithDictionary:dict];
}

+ (id)modelWithJSONString:(NSString *)string
{
    return [[self class]modelWithDictionary:[string JSONValue]];
}

+ (id)modelWithDictionary:(NSDictionary *)dict
{
    @autoreleasepool
    {
        if (!(dict && [dict isKindOfClass:[NSDictionary class]])) {
            return [self model];
        }
        
        NSString *keyName = dict[UModelClassNameKey];
        UModel *model = nil;
        if (keyName) {
            model = [NSClassFromString(keyName) model];
        }
        
        if (!model) {
            model = [self model];
        }
        
        NSDictionary *propertyMap = [model propertyMap];
        for (NSString *name in propertyMap) {
            @try
            {
                NSString *type = propertyMap[name];
                NSString *rname = [NSString stringWithString:name];
                
                // For illegal name
                if ([rname hasSuffix:@"_"] && rname.length > 0) {
                    if (![dict.allKeys containsObject:rname]) {
                        rname = [rname substringToIndex:rname.length - 1];
                    }
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
                    if (!(class && [class isSubclassOfClass:[NSArray class]])) {
                        value = [[self class]valueWithValue:value class:class];
                    } else {
                        // For NSArray
                        NSString *fieldName = @"";
                        NSArray *compents = [rname componentsSeparatedByString:@"_"];
                        for (int i = 0; i < compents.count; i ++) {
                            NSString *compent = compents[i];
                            if (compent.length > 0) {
                                NSString *firstAlpha = [[compent substringToIndex:1]uppercaseString];
                                NSString *otherCompent = [compent substringFromIndex:1];
                                compent = [firstAlpha stringByAppendingString:otherCompent];
                                fieldName = [fieldName stringByAppendingString:compent];
                            }
                        }
                        
                        NSString *suffix = [NSString stringWithFormat:@"%@Item", fieldName];
                        NSString *className = NSStringFromClass([self class]);
                        className = [className stringByAppendingString:suffix];
                        class = NSClassFromString(className);
                        
                        value = [[self class]valuesWithArray:value class:class];
                    }
                    
                    if (class && [value isKindOfClass:[NSNull class]]) {
                        __autoreleasing id object = [[class alloc]init];
                        value = object;
                    }
                    
                    // Final value
                    [model setValue:value forKey:name];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception.reason);
            }
        }
        
        return model;
    }
}

+ (NSArray *)modelsWithArray:(NSArray *)array
{
    @autoreleasepool
    {
        return [[self class]valuesWithArray:array class:[self class]];
    }
}

+ (id)modelWithModel:(UModel *)model
{
    @autoreleasepool
    {
        if (model && [model isKindOfClass:[UModel class]]) {
            return [[[model class] alloc]initWithModel:model];
        }
        
        return [self model];
    }
}

+ (NSArray *)arrayWithModels:(NSArray *)array
{
    return [[self class]arrayWithModels:array withKey:NO];
}

+ (NSArray *)arrayContainedkeysWithModels:(NSArray *)array
{
    return [[self class]arrayWithModels:array withKey:YES];
}

+ (NSArray *)arrayWithModels:(NSArray *)array withKey:(BOOL)withKey
{
    @autoreleasepool
    {
        if (array && [array isKindOfClass:[NSArray class]]) {
            NSMutableArray *marray = [NSMutableArray array];
            for (UModel *model in array) {
                if ([model isKindOfClass:[UModel class]]) {
                    NSDictionary *dict = [model dictionaryWithModelKey:withKey];
                    if (dict) {
                        [marray addObject:dict];
                    }
                }
            }
            
            return [marray copy];
        }
        
        return [NSArray array];
    }
}

+ (id)valueWithValue:(id)value class:(Class)class
{
    id itemValue = nil;
    if (class && [class isSubclassOfClass:[UModel class]]) {
        if ([value isKindOfClass:[NSDictionary class]]) { // NSDictionary
            itemValue = [class modelWithDictionary:value];
        } else if ([value isKindOfClass:[NSString class]]) { // NSString
            itemValue = [class modelWithJSONString:value];
        } else if ([value isKindOfClass:[NSData class]]) { // NSData
            itemValue = [class modelWithJSONData:value];
        } else if ([value isKindOfClass:[NSArray class]]) { // NSArray
            itemValue = [class modelsWithArray:value];
        }
    } else {
        if ([value isKindOfClass:[NSDictionary class]]) { // NSDictionary
            NSString *keyName = value[UModelClassNameKey];
            if (keyName) {
                class = NSClassFromString(keyName);
                if (class && [class isSubclassOfClass:[UModel class]]) {
                    itemValue = [class modelWithDictionary:value];
                }
            }
        }
    }
    
    value = itemValue?itemValue:value;
    
    return value;
}

+ (id)valuesWithArray:(NSArray *)array class:(Class)class
{
    NSMutableArray *marray = [NSMutableArray array];
    for (id item in array) {
        [marray addObject:[[self class] valueWithValue:item class:class]];
    }
    
    return [marray copy];
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
    @try {
        NSDictionary *propertyMap = [model propertyMap];
        for (NSString *name in propertyMap) {
            NSString *type = propertyMap[name];
            
            if ([type hasPrefix:@"@\""]) {
                // NSObject
                [self valueWithObject:[model valueForKey:name] key:name];
            } else {
                [self setValue:[model valueForKey:name] forKey:name];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
}

- (id)valueWithObject:(id)object key:(NSString *)keyName
{
    id value = nil;
    @try {
        if ([object isKindOfClass:[NSArray class]]) { // NSArray
            NSMutableArray *marray = [NSMutableArray array];
            for (id item in object) {
                id retValue = [self valueWithObject:item key:keyName];
                if (retValue) {
                    [marray addObject:retValue];
                }
            }
            
            // Set array value
            [self setValue:[marray copy] forKey:keyName];
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
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    @finally {
        return value;
    }
}

- (NSDictionary *)propertyMap
{
    @autoreleasepool
    {
        NSDictionary *propertyMap = [[self class] propertyMap];
        if (_excludeProperties &&
            [_excludeProperties isKindOfClass:[NSArray class]] &&
            _excludeProperties.count > 0)
        {
            NSMutableDictionary *mdict = [propertyMap mutableCopy];
            for (NSString *excludeProperty in _excludeProperties) {
                if ([excludeProperty isKindOfClass:[NSString class]] && excludeProperty.length > 0) {
                    for (NSString *name in propertyMap) {
                        if ([excludeProperty isEqualToString:name]) {
                            [mdict removeObjectForKey:name];
                            
                            break;
                        }

                    }
                }
            }
            
            return [mdict copy];
        }
        
        return propertyMap;
    }
}

- (NSArray *)propertyArray
{
    @autoreleasepool
    {
        NSArray *propertyArray = [[self class] propertyArray];
        
        if (_excludeProperties && [_excludeProperties isKindOfClass:[NSArray class]] && _excludeProperties.count > 0) {
            NSMutableArray *marray = [propertyArray mutableCopy];
            
            for (NSString *excludeProperty in _excludeProperties) {
                if ([excludeProperty isKindOfClass:[NSString class]] && excludeProperty.length > 0) {
                    for (NSDictionary *property in propertyArray) {
                        if ([excludeProperty isEqualToString:property[@"name"]]) {
                            [marray removeObject:property];
                            
                            break;
                        }
                    }
                }
            }
            
            return [marray copy];
        }
        
        return propertyArray;
    }
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
        NSDictionary *propertyMap = [self propertyMap];
        NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
        
        // Set value
        for (NSString *name in propertyMap) {
            @try
            {
                NSString *type = propertyMap[name];
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
                NSLog(@"%@", exception.reason);
            }
        }
        
        if (contains) {
            NSString *className = NSStringFromClass([self class]);
            [mdict setObject:className forKey:UModelClassNameKey];
        }
        
        return [mdict copy];
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
                [mdict setValue:NSStringFromClass([model class]) forKey:UModelClassNameKey];
                dict = [mdict copy];
            }
            value = dict;
        }
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSMutableArray *marray = [NSMutableArray array];
        for (id item in value) {
            [marray addObject:[self dictionaryWithValue:item contains:contains]];
        }
        
        value = [marray copy];
    }
    
    return value;
}

- (BOOL)isEuqualToModel:(UModel *)model
{
    NSString *selfJSON = [[self dictionaryWithModelKey]JSONString];
    NSString *theJSON = [[self dictionaryWithModelKey]JSONString];
    
    if (!(selfJSON && theJSON)) {
        return NO;
    }
    
    return [selfJSON isEqualToString:theJSON];
}

- (NSString *)description
{
    NSString *description = [super description];
#if DEBUG
    NSDictionary *dictValue = [self dictionary];
    if (dictValue && [dictValue isKindOfClass:[NSDictionary class]]) {
        description = [NSString stringWithFormat:@"%@%@", description, dictValue];
    }
#endif
    return description;
}

- (void)dealloc
{
#if DEBUG
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
#endif
}

@end

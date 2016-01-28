//
//  NSArray+UAExtension.m
//  UFoundation
//
//  Created by Think on 15/7/28.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "NSArray+UAExtension.h"
#import "NSObject+UAExtension.h"

@implementation NSArray (UAExtension)

- (NSArray *)addWithObject:(id)object
{
    NSMutableArray *marray = [NSMutableArray arrayWithArray:self];
    [marray addObject:object];
    
    return [marray copy];
}

- (NSArray *)insertWithObject:(id)object atIndex:(NSUInteger)index
{
    NSMutableArray *marray = [NSMutableArray arrayWithArray:self];
    [marray insertObject:object atIndex:index];
    
    return [marray copy];
}

- (NSArray *)removeLastObject
{
    NSMutableArray *marray = [NSMutableArray arrayWithArray:self];
    [marray removeLastObject];
    
    return [marray copy];
}

- (NSArray *)removeObjectWithIndex:(NSUInteger)index
{
    NSMutableArray *marray = [NSMutableArray arrayWithArray:self];
    [marray removeObjectAtIndex:index];
    
    return [marray copy];
}

- (NSArray *)replaceObjectWithIndex:(NSUInteger)index withObject:(id)object
{
    NSMutableArray *marray = [NSMutableArray arrayWithArray:self];
    [marray replaceObjectAtIndex:index withObject:object];
    
    return [marray copy];
}

- (NSArray *)appendWithArray:(NSArray *)array
{
    NSMutableArray *marray = [NSMutableArray arrayWithArray:self];
    [marray arrayByAddingObjectsFromArray:array];
    
    return [marray copy];
}

- (BOOL)containsItem:(id)item
{
    if (!item) {
        return NO;
    }
    
    if ([self respondsToSelector:@selector(containsObject:)]) {
        return [self containsObject:item];
    }
    
    for (id object in self) {
        if (object == item) {
            return YES;
        }
    }
    
    return NO;
}

- (void)allItemsPerformWith:(SEL)selector
{
    [self makeObjectsPerformSelector:selector];
}

- (void)allItemsPerformWith:(SEL)selector with:(id)object
{
    [self makeObjectsPerformSelector:selector withObject:object];
}

@end

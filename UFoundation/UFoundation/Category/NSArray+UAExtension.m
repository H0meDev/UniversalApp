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

- (NSArray *)addObject:(id)object
{
    @autoreleasepool
    {
        NSMutableArray *marray = [[NSMutableArray alloc]initWithArray:self];
        [marray addObject:object];
        return [marray copy];
    }
}

- (NSArray *)insertObject:(id)object atIndex:(NSUInteger)index
{
    @autoreleasepool
    {
        NSMutableArray *marray = [[NSMutableArray alloc]initWithArray:self];
        [marray insertObject:object atIndex:index];
        return [marray copy];
    }
}

- (NSArray *)removeLastObject
{
    @autoreleasepool
    {
        NSMutableArray *marray = [[NSMutableArray alloc]initWithArray:self];
        [marray removeLastObject];
        return [marray copy];
    }
}

- (NSArray *)removeObjectAtIndex:(NSUInteger)index
{
    @autoreleasepool
    {
        NSMutableArray *marray = [[NSMutableArray alloc]initWithArray:self];
        [marray removeObjectAtIndex:index];
        return [marray copy];
    }
}

- (NSArray *)replaceObjectAtIndex:(NSUInteger)index withObject:(id)object
{
    @autoreleasepool
    {
        NSMutableArray *marray = [[NSMutableArray alloc]initWithArray:self];
        [marray replaceObjectAtIndex:index withObject:object];
        return [marray copy];
    }
}

@end

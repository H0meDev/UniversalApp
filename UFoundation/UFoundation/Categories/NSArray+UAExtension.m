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
    NSMutableArray *marray = [NSMutableArray arrayWithArray:self];
    [marray addObject:object];
    
    return marray;
}

- (NSArray *)insertObject:(id)object atIndex:(NSUInteger)index
{
    NSMutableArray *marray = [NSMutableArray arrayWithArray:self];
    [marray insertObject:object atIndex:index];
    
    return marray;
}

- (NSArray *)removeLastObject
{
    NSMutableArray *marray = [NSMutableArray arrayWithArray:self];
    [marray removeLastObject];
    
    return marray;
}

- (NSArray *)removeObjectAtIndex:(NSUInteger)index
{
    NSMutableArray *marray = [NSMutableArray arrayWithArray:self];
    [marray removeObjectAtIndex:index];
    
    return marray;
}

- (NSArray *)replaceObjectAtIndex:(NSUInteger)index withObject:(id)object
{
    NSMutableArray *marray = [NSMutableArray arrayWithArray:self];
    [marray replaceObjectAtIndex:index withObject:object];
    
    return marray;
}

- (NSArray *)appendArray:(NSArray *)array
{
    NSMutableArray *marray = [NSMutableArray arrayWithArray:self];
    [marray arrayByAddingObjectsFromArray:array];
    
    return marray;
}

@end

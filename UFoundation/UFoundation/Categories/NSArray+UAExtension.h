//
//  NSArray+UAExtension.h
//  UFoundation
//
//  Created by Think on 15/7/28.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (UAExtension)

// For convenient
- (NSArray *)addObject:(id)object;
- (NSArray *)insertObject:(id)object atIndex:(NSUInteger)index;
- (NSArray *)removeLastObject;
- (NSArray *)removeObjectAtIndex:(NSUInteger)index;
- (NSArray *)replaceObjectAtIndex:(NSUInteger)index withObject:(id)object;
- (NSArray *)appendArray:(NSArray *)array; // Append to last

@end

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
- (NSArray *)addWithObject:(id)object;
- (NSArray *)insertWithObject:(id)object atIndex:(NSUInteger)index;
- (NSArray *)removeLastObject;
- (NSArray *)removeObjectWithIndex:(NSUInteger)index;
- (NSArray *)replaceObjectWithIndex:(NSUInteger)index withObject:(id)object;
- (NSArray *)appendWithArray:(NSArray *)array; // Append to last

@end

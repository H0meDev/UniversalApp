//
//  UOperationQueue.h
//  UFoundation
//
//  Created by Think on 15/5/23.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UHTTPOperation.h"

@interface UOperationQueue : NSObject

+ (UOperationQueue *)queue;

- (void)setMaxConcurrentCount:(NSInteger)count; // Default is 10
- (void)setMaxOperationsCount:(NSUInteger)count; // Default is ULLONG_MAX

// Add operation for cache
// The operation will be stored, so you have to remove by
// calling removeOperation method. Or, the object will never
// be dealloced.
- (void)addOperation:(NSOperation *)operation;

// Remove the operation to release the memory
- (void)removeOperation:(NSOperation *)operation;

// Clear the memory
- (void)clearMemory;

// For control
- (NSUInteger)operationsCount;
- (BOOL)isQueueFull;

@end

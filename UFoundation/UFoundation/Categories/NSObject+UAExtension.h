//
//  NSObject+UAExtension.h
//  UFoundation
//
//  Created by Think on 15/7/28.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (UAExtension)

// Create an instance
+ (id)instance;

// Get weak self
- (id)weakself;

// Perform the selector
- (void)performWithName:(NSString *)selectorName;

// Perform the selector with object
- (void)performWithName:(NSString *)selectorName with:(id)object;

// Perform the selector on main thread
- (void)performOnMainThread:(SEL)selector;

// Perform the selector on main thread with object
- (void)performOnMainThread:(SEL)selector with:(id)object;

// Perform the selector on main thread async
- (void)performAsyncOnMainQueue:(NSString *)selectorName;

// Perform the selector on main queue with object async
- (void)performAsyncOnMainQueue:(NSString *)selectorName with:(id)object;

// Perform the selector on main queue with block, care retainCircle
- (void)performAsyncOnMainDispatch:(dispatch_block_t)block;

// Perform the selector on queue with block, care retainCircle
- (void)performAsyncOnQueue:(dispatch_queue_t)queue block:(dispatch_block_t)block;

@end

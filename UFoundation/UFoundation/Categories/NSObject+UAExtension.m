//
//  NSObject+UAExtension.m
//  UFoundation
//
//  Created by Think on 15/7/28.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "NSObject+UAExtension.h"

@implementation NSObject (UAExtension)

+ (id)instance
{
    @autoreleasepool
    {
        return [[self alloc]init];
    }
}

- (id)weakself
{
    @autoreleasepool
    {
        __weak id weakself = self;
        return weakself;
    }
}

- (void)performWithName:(NSString *)selectorName
{
    [self performWithName:selectorName with:nil];
}

- (void)performWithName:(NSString *)selectorName with:(id)object
{
    if (!selectorName) {
        return;
    }
    
    SEL selector = NSSelectorFromString(selectorName);
    IMP imp = [self methodForSelector:selector];
    
    if (imp) {
        void (*execute)(id, SEL, id) = (void *)imp;
        execute(self, selector, object);
    }
}

- (void)performOnMainThread:(SEL)selector
{
    [self performOnMainThread:selector with:nil];
}

- (void)performOnMainThread:(SEL)selector with:(id)object
{
    [self performSelectorOnMainThread:selector withObject:object waitUntilDone:NO];
}

- (void)performAsyncOnMainQueue:(NSString *)selectorName
{
    id weakself = self.weakself;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself performWithName:selectorName];
    });
}

- (void)performAsyncOnMainQueue:(NSString *)selectorName with:(id)object
{
    id weakself = self.weakself;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself performWithName:selectorName with:object];
    });
}

- (void)performAsyncOnMainDispatch:(dispatch_block_t)block
{
    dispatch_async(dispatch_get_main_queue(), block);
}

- (void)performAsyncOnQueue:(dispatch_queue_t)queue block:(dispatch_block_t)block
{
    dispatch_async(queue, block);
}

@end

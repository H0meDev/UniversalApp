//
//  UThreadPool.m
//  UFoundation
//
//  Created by Cailiang on 15/4/17.
//  Copyright (c) 2015年 Cailiang. All rights reserved.
//

#import "UThreadPool.h"
#import "NSObject+UAExtension.h"

static UThreadPool *sharedPool = nil;

@interface UThreadPool ()
{
    dispatch_queue_t _concurrentQueue;
    NSLock *_excuteLock;
}

@end

@implementation UThreadPool

#pragma mark - Singleton

+ (id)sharedPool
{
    @synchronized (self)
    {
        if (sharedPool == nil) {
            return [[self alloc]init];
        }
    }
    
    return sharedPool;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized (self) {
        if (sharedPool == nil) {
            return [super allocWithZone:zone];
        }
    }
    
    return nil;
}

- (instancetype)init
{
    @synchronized(self) {
        self = [super init];
        // Initialize
        sharedPool = self;
        _excuteLock = [[NSLock alloc]init];
        _concurrentQueue = dispatch_queue_create("UThreadPoolQueue", DISPATCH_QUEUE_CONCURRENT);
        
        // Default no concurrent
        [self setConcurrent:NO];
        
        return self;
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - Methods

+ (void)setConcurrent:(BOOL)concurrent
{
    [[self sharedPool]setConcurrent:concurrent];
}

// Add a selector without object
+ (void)addTarget:(id)target sel:(SEL)selector
{
    [self addTarget:target sel:selector object:nil];
}

// Add a selector with object
+ (void)addTarget:(id)target sel:(SEL)selector object:(id)object
{
    [[self sharedPool]addTarget:target sel:selector object:object];
}

+ (void)addTarget:(id)target sels:(NSArray *)selectors
{
    [[self sharedPool]addTarget:target sels:selectors];
}

- (void)setConcurrent:(BOOL)concurrent
{
    if (!concurrent) {
        _excuteLock = [[NSLock alloc]init];
    } else {
        _excuteLock = nil;
    }
}

- (void)addTarget:(id)target sel:(SEL)selector object:(id)object
{
    __weak id weaktarget = target;
    UThreadPool *weakself = self.weakself;
    
    dispatch_async(_concurrentQueue, ^{
        [weakself executeWith:weaktarget sel:selector object:object];
    });
}

- (void)addTarget:(id)target sels:(NSArray *)selectors
{
    for (NSString *selName in selectors) {
        SEL selector = NSSelectorFromString(selName);
        __weak id weaktarget = target;
        UThreadPool *weakself = self.weakself;
        
        dispatch_async(_concurrentQueue, ^{
            [weakself executeWith:weaktarget sel:selector object:nil];
        });
    }
}

- (void)executeWith:(id)target sel:(SEL)selector object:(id)object
{
    if (_excuteLock) {
        [_excuteLock lock];
    }
    
    if (target && [target respondsToSelector:selector]) {
        // Execute item
        IMP imp = [target methodForSelector:selector];
        void (*execute)(id, SEL, id) = (void *)imp;
        execute(target, selector, object);
    }
    
    if (_excuteLock) {
        [_excuteLock unlock];
    }
}

@end

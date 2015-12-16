//
//  UOperationQueue.m
//  UFoundation
//
//  Created by Think on 15/5/23.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UOperationQueue.h"
#import <UIKit/UIKit.h>
#import "UDefines.h"

static UOperationQueue *sharedCache = nil;

@interface UOperationQueue ()
{
    NSOperationQueue *_operationQueue;
    NSMutableArray *_operations;
}

// Shared instance
+ (UOperationQueue *)sharedCache;

@end

@implementation UOperationQueue

#pragma mark - Singleton

+ (UOperationQueue *)sharedCache
{
    @synchronized (self)
    {
        if (sharedCache == nil) {
            sharedCache = [[self alloc]init];
        }
    }
    return sharedCache;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized (self) {
        if (sharedCache == nil) {
            sharedCache = [super allocWithZone:zone];
            return sharedCache;
        }
    }
    return nil;
}

- (id)init
{
    @synchronized(self) {
        self = [super init];
        if (self) {
            // Initialize
            _operations = [NSMutableArray array];
            _operationQueue = [[NSOperationQueue alloc]init];
            _operationQueue.maxConcurrentOperationCount = 10;
            
            // Received memory warning
            [[NSNotificationCenter defaultCenter]addObserver:self
                                                    selector:@selector(appDidBReceiveMemoryWarning)
                                                        name:UIApplicationDidReceiveMemoryWarningNotification
                                                      object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self
                                                    selector:@selector(appDidEnterBackground)
                                                        name:UIApplicationDidEnterBackgroundNotification
                                                      object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self
                                                    selector:@selector(appDidBecomeActive)
                                                        name:UIApplicationDidBecomeActiveNotification
                                                      object:nil];
        }
        
        return self;
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - Methods

+ (void)setMaxConcurrentCount:(NSInteger)count
{
    [[self sharedCache]setMaxConcurrentCount:count];
}

// Add operation for cache
+ (void)addOperation:(NSOperation *)operation
{
    if (checkClass(operation, NSOperation)) {
        [[self sharedCache]addOperation:operation];
    }
}

+ (void)removeOperation:(NSOperation *)operation
{
    if (checkClass(operation, NSOperation)) {
        [[self sharedCache]removeOperation:operation];
    }
}

// Clear the memory
+ (void)clearMemory
{
    [[self sharedCache]clearMemory];
}

- (void)appDidBReceiveMemoryWarning
{
    [self clearMemory];
}

- (void)appDidEnterBackground
{
    _operationQueue.suspended = YES;
}

- (void)appDidBecomeActive
{
    _operationQueue.suspended = NO;
}

- (void)setMaxConcurrentCount:(NSInteger)count
{
    _operationQueue.maxConcurrentOperationCount = count;
}

- (void)addOperation:(NSOperation *)operation
{
    if (checkClass(operation, NSOperation)) {
        [_operations addObject:operation];
        [_operationQueue addOperation:operation];
    }
}

- (void)removeOperation:(NSOperation *)operation
{
    if (checkClass(operation, NSOperation)) {
        [_operations removeObject:operation];
    }
}

- (void)clearMemory
{
    if (_operations && _operations.count > 0) {
        [_operations removeAllObjects];
    }
    
    if (_operationQueue && _operationQueue.operationCount > 0) {
        [_operationQueue cancelAllOperations];
    }
}

@end

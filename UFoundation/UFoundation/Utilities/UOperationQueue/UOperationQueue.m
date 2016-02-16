//
//  UOperationQueue.m
//  UFoundation
//
//  Created by Think on 15/5/23.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UOperationQueue.h"
#import "UDefines.h"

@interface UOperationQueue ()
{
    NSMutableArray *_operations;
    NSOperationQueue *_operationQueue;
    NSUInteger _maxOperationsCount;
}

@end

@implementation UOperationQueue

#pragma mark - Singleton

+ (UOperationQueue *)queue
{
    @autoreleasepool
    {
        return [[self alloc]init];
    }
}

- (id)init
{
    @synchronized(self) {
        self = [super init];
        if (self) {
            // Initialize
            _maxOperationsCount = MAXFLOAT;
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

- (void)setMaxOperationsCount:(NSUInteger)count
{
    _maxOperationsCount = count;
}

- (NSUInteger)operationsCount
{
    return _operations.count;
}

- (BOOL)isQueueFull
{
    return NO;
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

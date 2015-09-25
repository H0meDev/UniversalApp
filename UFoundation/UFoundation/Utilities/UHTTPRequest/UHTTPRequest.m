//
//  UHTTPRequest.m
//  UFoundation
//
//  Created by Think on 15/5/23.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UHTTPRequest.h"
#import "NSDictionary+UAExtension.h"
#import "UOperationQueue.h"

@interface UHTTPRequest ()

@end

static UHTTPRequest *sharedManager = nil;

@implementation UHTTPRequest

#pragma mark - Singleton

+ (UHTTPRequest *)sharedManager
{
    @synchronized (self)
    {
        if (sharedManager == nil) {
            sharedManager = [[self alloc]init];
        }
    }
    return sharedManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized (self) {
        if (sharedManager == nil) {
            sharedManager = [super allocWithZone:zone];
            return sharedManager;
        }
    }
    return nil;
}

- (id)init
{
    @synchronized(self) {
        self = [super init];
        return self;
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - Request

+ (void)sendAsynWith:(NSString *)method
                 url:(NSString *)url
               param:(NSDictionary *)param
            callback:(UHTTPCallback)callback
{
    [[self sharedManager]requestWithMethod:method
                                       url:url
                                     param:param
                                   timeout:30
                                     retry:0
                              timeInterval:0
                                  callback:callback];
}

+ (void)sendAsynWith:(NSString *)method
                 url:(NSString *)url
               param:(NSDictionary *)param
             timeout:(NSInteger)timeout
            callback:(UHTTPCallback)callback
{
    [[self sharedManager]requestWithMethod:method
                                       url:url
                                     param:param
                                   timeout:timeout
                                     retry:0
                              timeInterval:0
                                  callback:callback];
}

+ (void)sendAsynWith:(NSString *)method
                 url:(NSString *)url
               param:(NSDictionary *)param
             timeout:(NSInteger)timeout
               retry:(NSUInteger)times
        timeInterval:(NSInteger)timeInterval
            callback:(UHTTPCallback)callback
{
    [[self sharedManager]requestWithMethod:method
                                       url:url
                                     param:param
                                   timeout:timeout
                                     retry:times
                              timeInterval:timeInterval
                                  callback:callback];
}

+ (void)sendAsynCachedWith:(NSString *)method
                       url:(NSString *)url
                     param:(NSDictionary *)param
                  callback:(UHTTPCallback)callback
{
    [[self sharedManager]requestWithMethod:method
                                       url:url
                                     param:param
                                   timeout:30
                                     retry:0
                              timeInterval:0
                                  callback:callback
                                    cached:YES];
}

+ (void)sendAsynCachedWith:(NSString *)method
                       url:(NSString *)url
                     param:(NSDictionary *)param
                   timeout:(NSInteger)timeout
                  callback:(UHTTPCallback)callback
{
    [[self sharedManager]requestWithMethod:method
                                       url:url
                                     param:param
                                   timeout:timeout
                                     retry:0
                              timeInterval:0
                                  callback:callback
                                    cached:YES];
}

+ (void)sendAsynCachedWith:(NSString *)method
                       url:(NSString *)url
                     param:(NSDictionary *)param
                   timeout:(NSInteger)timeout
                     retry:(NSUInteger)times
              timeInterval:(NSInteger)timeInterval
                  callback:(UHTTPCallback)callback
{
    [[self sharedManager]requestWithMethod:method
                                       url:url
                                     param:param
                                   timeout:timeout
                                     retry:times
                              timeInterval:timeInterval
                                  callback:callback
                                    cached:YES];
}

+ (void)sendAsynWith:(NSString *)method
                 url:(NSString *)url
               param:(NSDictionary *)param
            delegate:(id<UHTTPRequestDelegate>)delegate
                 tag:(int)tag
{
    [[self sharedManager]requestWithMethod:method
                                       url:url
                                     param:param
                                   timeout:30
                                     retry:0
                              timeInterval:0
                                  delegate:delegate
                                       tag:tag];
}

+ (void)sendAsynWith:(NSString *)method
                 url:(NSString *)url
               param:(NSDictionary *)param
            delegate:(id<UHTTPRequestDelegate>)delegate
             timeout:(NSInteger)timeout
                 tag:(int)tag
{
    [[self sharedManager]requestWithMethod:method
                                       url:url
                                     param:param
                                   timeout:timeout
                                     retry:0
                              timeInterval:0
                                  delegate:delegate
                                       tag:tag];
}

+ (void)sendAsynWith:(NSString *)method
                 url:(NSString *)url
               param:(NSDictionary *)param
            delegate:(id<UHTTPRequestDelegate>)delegate
             timeout:(NSInteger)timeout
               retry:(NSUInteger)times
        timeInterval:(NSInteger)timeInterval
                 tag:(int)tag
{
    [[self sharedManager]requestWithMethod:method
                                       url:url
                                     param:param
                                   timeout:timeout
                                     retry:times
                              timeInterval:timeInterval
                                  delegate:delegate
                                       tag:tag];
}

+ (void)sendAsynCachedWith:(NSString *)method
                       url:(NSString *)url
                     param:(NSDictionary *)param
                  delegate:(id<UHTTPRequestDelegate>)delegate
                       tag:(int)tag
{
    [[self sharedManager]requestWithMethod:method
                                       url:url
                                     param:param
                                   timeout:30
                                     retry:0
                              timeInterval:0
                                  delegate:delegate
                                       tag:tag
                                    cached:YES];
}

+ (void)sendAsynCachedWith:(NSString *)method
                       url:(NSString *)url
                     param:(NSDictionary *)param
                  delegate:(id<UHTTPRequestDelegate>)delegate
                   timeout:(NSInteger)timeout
                       tag:(int)tag
{
    [[self sharedManager]requestWithMethod:method
                                       url:url
                                     param:param
                                   timeout:timeout
                                     retry:0
                              timeInterval:0
                                  delegate:delegate
                                       tag:tag
                                    cached:YES];
}

+ (void)sendAsynCachedWith:(NSString *)method
                       url:(NSString *)url
                     param:(NSDictionary *)param
                  delegate:(id<UHTTPRequestDelegate>)delegate
                   timeout:(NSInteger)timeout
                     retry:(NSUInteger)times
              timeInterval:(NSInteger)timeInterval
                       tag:(int)tag
{
    [[self sharedManager]requestWithMethod:method
                                       url:url
                                     param:param
                                   timeout:timeout
                                     retry:times
                              timeInterval:timeInterval
                                  delegate:delegate
                                       tag:tag
                                    cached:YES];
}

+ (NSData *)sendSynWith:(NSString *)method
                    url:(NSString *)url
                  param:(NSDictionary *)param
               response:(NSURLResponse **)response
                  error:(NSError **)error
{
    method = [method uppercaseString];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    mutableRequest.HTTPMethod = method;
    
    // Set content-type to support more data type
    NSString *contentType = @"application/json";
    [mutableRequest setValue:contentType forHTTPHeaderField:@"Content-type"];
    
    NSString *body = nil;
    if ([param isKindOfClass:[NSDictionary class]]) {
        @try {
            NSData *json = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
            body = [[NSString alloc]initWithData:json encoding:NSUTF8StringEncoding];
            mutableRequest.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
        }
        @catch (NSException *exception) {
            NSLog(@"UHTTPRequest Exception:\n%@",exception);
            body = nil;
        }
    }
    
    return [NSURLConnection sendSynchronousRequest:mutableRequest returningResponse:response error:error];
}

- (void)requestWithMethod:(NSString *)method
                      url:(NSString *)url
                    param:(NSDictionary *)param
                  timeout:(NSInteger)timeout
                    retry:(NSUInteger)times
             timeInterval:(NSInteger)timeInterval
                 callback:(UHTTPCallback)callback
{
    [self requestWithMethod:method
                        url:url
                      param:param
                    timeout:timeout
                      retry:times
               timeInterval:timeInterval
                   callback:callback
                     cached:NO];
}

- (void)requestWithMethod:(NSString *)method
                      url:(NSString *)url
                    param:(NSDictionary *)param
                  timeout:(NSInteger)timeout
                    retry:(NSUInteger)times
             timeInterval:(NSInteger)timeInterval
                 callback:(UHTTPCallback)callback
                   cached:(BOOL)cached
{
    method = [method uppercaseString];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    mutableRequest.HTTPMethod = method;
    
    // Set content-type to support more data type
    NSString *contentType = @"application/json";
    [mutableRequest setValue:contentType forHTTPHeaderField:@"Content-type"];
    
    NSString *body = nil;
    if ([param isKindOfClass:[NSDictionary class]]) {
        @try {
            NSData *json = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
            body = [[NSString alloc]initWithData:json encoding:NSUTF8StringEncoding];
            mutableRequest.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
        }
        @catch (NSException *exception) {
            NSLog(@"UHTTPRequest Exception:\n%@",exception);
            body = nil;
        }
    }
    
    // Add to operation queue
    UHTTPOperation *operation = [[UHTTPOperation alloc]initWithRequest:mutableRequest
                                                                cached:cached
                                                              callback:callback];
    [operation setTimeOut:timeout];
    [operation setRetryTimes:times];
    [operation setRetryTimeInterval:timeInterval];
    
    // Add to UOperationQueue
    [UOperationQueue addOperation:operation];
}

- (void)requestWithMethod:(NSString *)method
                      url:(NSString *)url
                    param:(NSDictionary *)param
                  timeout:(NSInteger)timeout
                    retry:(NSUInteger)times
             timeInterval:(NSInteger)timeInterval
                 delegate:(id<UHTTPRequestDelegate>)delegate
                      tag:(int)tag
{
    [self requestWithMethod:method
                        url:url
                      param:param
                    timeout:timeout
                      retry:times
               timeInterval:timeInterval
                   delegate:delegate
                        tag:tag
                     cached:NO];
}

- (void)requestWithMethod:(NSString *)method
                      url:(NSString *)url
                    param:(NSDictionary *)param
                  timeout:(NSInteger)timeout
                    retry:(NSUInteger)times
             timeInterval:(NSInteger)timeInterval
                 delegate:(id<UHTTPRequestDelegate>)delegate
                      tag:(int)tag
                   cached:(BOOL)cached
{
    method = [method uppercaseString];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    mutableRequest.HTTPMethod = method;
    
    // Set content-type to support more data type
    NSString *contentType = @"application/json";
    [mutableRequest setValue:contentType forHTTPHeaderField:@"Content-type"];
    
    NSString *body = nil;
    if ([param isKindOfClass:[NSDictionary class]]) {
        @try {
            NSData *json = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
            body = [[NSString alloc]initWithData:json encoding:NSUTF8StringEncoding];
            mutableRequest.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
        }
        @catch (NSException *exception) {
            NSLog(@"UHTTPRequest Exception:\n%@",exception);
            body = nil;
        }
    }
    
    // Add to operation queue
    UHTTPOperation *operation = [[UHTTPOperation alloc]initWithRequest:mutableRequest
                                                              delegate:delegate
                                                                   tag:tag];
    [operation setTimeOut:timeout];
    [operation setRetryTimes:times];
    [operation setRetryTimeInterval:timeInterval];
    
    // Add to UOperationQueue
    [UOperationQueue addOperation:operation];
}

@end

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

+ (void)sendAsynWithURL:(NSString *)url
                 header:(NSDictionary *)header
                 method:(NSString *)method
                  param:(NSDictionary *)param
               callback:(UHTTPCallback)callback
{
    [[self sharedManager]requestWithURL:url
                                 header:header
                                 method:method
                                  param:param
                                timeout:30
                                  retry:0
                           timeInterval:0
                               callback:callback];
}

+ (void)sendAsynWithURL:(NSString *)url
                 header:(NSDictionary *)header
                 method:(NSString *)method
                  param:(NSDictionary *)param
                timeout:(NSInteger)timeout
               callback:(UHTTPCallback)callback
{
    [[self sharedManager]requestWithURL:url
                                 header:header
                                 method:method
                                  param:param
                                timeout:timeout
                                  retry:0
                           timeInterval:0
                               callback:callback];
}

+ (void)sendAsynWithURL:(NSString *)url
                 header:(NSDictionary *)header
                 method:(NSString *)method
                  param:(NSDictionary *)param
                timeout:(NSInteger)timeout
                  retry:(NSUInteger)times
           timeInterval:(NSInteger)timeInterval
               callback:(UHTTPCallback)callback
{
    [[self sharedManager]requestWithURL:url
                                 header:header
                                 method:method
                                  param:param
                                timeout:timeout
                                  retry:times
                           timeInterval:timeInterval
                               callback:callback];
}

+ (void)sendAsynWithURL:(NSString *)url
                 header:(NSDictionary *)header
                 method:(NSString *)method
                  param:(NSDictionary *)param
               callback:(UHTTPCallback)callback
                 cached:(BOOL)cached
{
    [[self sharedManager]requestWithURL:url
                                 header:header
                                 method:method
                                  param:param
                                timeout:30
                                  retry:0
                           timeInterval:0
                               callback:callback
                                 cached:cached];
}

+ (void)sendAsynWithURL:(NSString *)url
                 header:(NSDictionary *)header
                 method:(NSString *)method
                  param:(NSDictionary *)param
                timeout:(NSInteger)timeout
               callback:(UHTTPCallback)callback
                 cached:(BOOL)cached
{
    [[self sharedManager]requestWithURL:url
                                 header:header
                                 method:method
                                  param:param
                                timeout:timeout
                                  retry:0
                           timeInterval:0
                               callback:callback
                                 cached:cached];
}

+ (void)sendAsynWithURL:(NSString *)url
                 header:(NSDictionary *)header
                 method:(NSString *)method
                  param:(NSDictionary *)param
                timeout:(NSInteger)timeout
                  retry:(NSUInteger)times
           timeInterval:(NSInteger)timeInterval
               callback:(UHTTPCallback)callback
                 cached:(BOOL)cached
{
    [[self sharedManager]requestWithURL:url
                                 header:header
                                 method:method
                                  param:param
                                timeout:timeout
                                  retry:times
                           timeInterval:timeInterval
                               callback:callback
                                 cached:cached];
}

+ (void)sendAsynWithURL:(NSString *)url
                 header:(NSDictionary *)header
                 method:(NSString *)method
                  param:(NSDictionary *)param
               delegate:(id<UHTTPRequestDelegate>)delegate
                    tag:(int)tag
{
    [[self sharedManager]requestWithURL:url
                                 header:header
                                 method:method
                                  param:param
                                timeout:30
                                  retry:0
                           timeInterval:0
                               delegate:delegate
                                    tag:tag];
}

+ (void)sendAsynWithURL:(NSString *)url
                 header:(NSDictionary *)header
                 method:(NSString *)method
                  param:(NSDictionary *)param
               delegate:(id<UHTTPRequestDelegate>)delegate
                timeout:(NSInteger)timeout
                    tag:(int)tag
{
    [[self sharedManager]requestWithURL:url
                                 header:header
                                 method:method
                                  param:param
                                timeout:timeout
                                  retry:0
                           timeInterval:0
                               delegate:delegate
                                    tag:tag];
}

+ (void)sendAsynWithURL:(NSString *)url
                 header:(NSDictionary *)header
                 method:(NSString *)method
                  param:(NSDictionary *)param
               delegate:(id<UHTTPRequestDelegate>)delegate
                timeout:(NSInteger)timeout
                  retry:(NSUInteger)times
           timeInterval:(NSInteger)timeInterval
                    tag:(int)tag
{
    [[self sharedManager]requestWithURL:url
                                 header:header
                                 method:method
                                  param:param
                                timeout:timeout
                                  retry:times
                           timeInterval:timeInterval
                               delegate:delegate
                                    tag:tag];
}

+ (void)sendAsynWithURL:(NSString *)url
                 header:(NSDictionary *)header
                 method:(NSString *)method
                  param:(NSDictionary *)param
               delegate:(id<UHTTPRequestDelegate>)delegate
                    tag:(int)tag
                 cached:(BOOL)cached
{
    [[self sharedManager]requestWithURL:url
                                 header:header
                                 method:method
                                  param:param
                                timeout:30
                                  retry:0
                           timeInterval:0
                               delegate:delegate
                                    tag:tag
                                 cached:cached];
}

+ (void)sendAsynWithURL:(NSString *)url
                 header:(NSDictionary *)header
                 method:(NSString *)method
                  param:(NSDictionary *)param
               delegate:(id<UHTTPRequestDelegate>)delegate
                timeout:(NSInteger)timeout
                    tag:(int)tag
                 cached:(BOOL)cached
{
    [[self sharedManager]requestWithURL:url
                                 header:header
                                 method:method
                                  param:param
                                timeout:timeout
                                  retry:0
                           timeInterval:0
                               delegate:delegate
                                    tag:tag
                                 cached:cached];
}

+ (void)sendAsynWithURL:(NSString *)url
                 header:(NSDictionary *)header
                 method:(NSString *)method
                  param:(NSDictionary *)param
               delegate:(id<UHTTPRequestDelegate>)delegate
                timeout:(NSInteger)timeout
                  retry:(NSUInteger)times
           timeInterval:(NSInteger)timeInterval
                    tag:(int)tag
                 cached:(BOOL)cached
{
    [[self sharedManager]requestWithURL:url
                                 header:header
                                 method:method
                                  param:param
                                timeout:timeout
                                  retry:times
                           timeInterval:timeInterval
                               delegate:delegate
                                    tag:tag
                                 cached:cached];
}

- (void)requestWithURL:(NSString *)url
                header:(NSDictionary *)header
                method:(NSString *)method
                 param:(NSDictionary *)param
               timeout:(NSInteger)timeout
                 retry:(NSUInteger)times
          timeInterval:(NSInteger)timeInterval
              callback:(UHTTPCallback)callback
{
    [self requestWithURL:url
                  header:header
                  method:method
                   param:param
                 timeout:timeout
                   retry:times
            timeInterval:timeInterval
                callback:callback
                  cached:NO];
}

- (void)requestWithURL:(NSString *)url
                header:(NSDictionary *)header
                method:(NSString *)method
                 param:(NSDictionary *)param
               timeout:(NSInteger)timeout
                 retry:(NSUInteger)times
          timeInterval:(NSInteger)timeInterval
              delegate:(id<UHTTPRequestDelegate>)delegate
                   tag:(int)tag
{
    [self requestWithURL:url
                  header:header
                  method:method
                   param:param
                 timeout:timeout
                   retry:times
            timeInterval:timeInterval
                delegate:delegate
                     tag:tag
                  cached:NO];
}

- (void)requestWithURL:(NSString *)url
                header:(NSDictionary *)header
                method:(NSString *)method
                 param:(NSDictionary *)param
               timeout:(NSInteger)timeout
                 retry:(NSUInteger)times
          timeInterval:(NSInteger)timeInterval
              callback:(UHTTPCallback)callback
                cached:(BOOL)cached
{
    [self requestWithURL:url
                  header:header
                  method:method
                   param:param
                 timeout:timeout
                   retry:times
            timeInterval:timeInterval
                callback:callback
                delegate:nil
                     tag:0
                  cached:cached];
}

- (void)requestWithURL:(NSString *)url
                header:(NSDictionary *)header
                method:(NSString *)method
                 param:(NSDictionary *)param
               timeout:(NSInteger)timeout
                 retry:(NSUInteger)times
          timeInterval:(NSInteger)timeInterval
              delegate:(id<UHTTPRequestDelegate>)delegate
                   tag:(int)tag
                cached:(BOOL)cached
{
    [self requestWithURL:url
                  header:header
                  method:method
                   param:param
                 timeout:timeout
                   retry:times
            timeInterval:timeInterval
                callback:NULL
                delegate:delegate
                     tag:tag
                  cached:cached];
}

- (void)requestWithURL:(NSString *)url
                header:(NSDictionary *)header
                method:(NSString *)method
                 param:(NSDictionary *)param
               timeout:(NSInteger)timeout
                 retry:(NSUInteger)times
          timeInterval:(NSInteger)timeInterval
              callback:(UHTTPCallback)callback
              delegate:(id<UHTTPRequestDelegate>)delegate
                   tag:(int)tag
                cached:(BOOL)cached
{
    method = [method uppercaseString];
    
    // Body
    NSString *body = nil;
    if ([param isKindOfClass:[NSDictionary class]]) {
        if ([method isEqualToString:@"GET"]) {
            url = [url stringByAppendingString:@"?"];
            for (NSString *key in param) {
                url = [url stringByAppendingFormat:@"%@=%@&", key, param[key]];
            }
            
            // GET style url
            url = [url substringToIndex:url.length - 1];
        } else {
            @try {
                NSData *json = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
                body = [[NSString alloc]initWithData:json encoding:NSUTF8StringEncoding];
            }
            @catch (NSException *exception) {
                NSLog(@"UHTTPRequest Exception:\n%@",exception);
                body = nil;
            }
        }
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = method;
    request.HTTPBody = (body)?[body dataUsingEncoding:NSUTF8StringEncoding]:nil;
    
    // Set http header
    for (NSString *field in header) {
        NSString *value = header[field];
        [request setValue:value forHTTPHeaderField:field];
    }
    
    UHTTPOperation *operation = nil;
    if (callback) {
        operation = [[UHTTPOperation alloc]initWithRequest:request
                                                  callback:callback];
    }
    
    if (delegate) {
        operation = [[UHTTPOperation alloc]initWithRequest:request
                                                  delegate:delegate
                                                       tag:tag];
    }
    
    // Add to operation queue
    [operation setTimeOut:timeout];
    [operation setRetryTimes:times];
    [operation setRetryTimeInterval:timeInterval];
    
    // Add to UOperationQueue
    [UOperationQueue addOperation:operation];
}

+ (NSData *)sendSyncWithURL:(NSString *)url
                     header:(NSDictionary *)header
                     method:(NSString *)method
                      param:(NSDictionary *)param
                   response:(NSURLResponse **)response
                      error:(NSError **)error
{
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    mutableRequest.HTTPMethod = [method uppercaseString];
    
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

@end

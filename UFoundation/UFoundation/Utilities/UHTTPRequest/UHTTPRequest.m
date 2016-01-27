//
//  UHTTPRequest.m
//  UFoundation
//
//  Created by Think on 15/5/23.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UHTTPRequest.h"
#import "NSObject+UAExtension.h"
#import "NSDictionary+UAExtension.h"
#import "NSString+UAExtension.h"
#import "UOperationQueue.h"

@implementation UHTTPRequestParam

+ (id)param
{
    @autoreleasepool
    {
        return [[UHTTPRequestParam alloc]init];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialize
        _method = @"GET";
        _timeout = 30;
        _retry = 0;
        _retryInterval = 0;
    }
    
    return self;
}

@end

@interface UHTTPRequest ()

@end

@implementation UHTTPRequest

+ (id)instance
{
    @autoreleasepool
    {
        return [[UHTTPRequest alloc]init];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialize
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

#pragma mark - Request

+ (UHTTPOperation *)sendAsynWith:(UHTTPRequestParam *)param
                        callback:(UHTTPCallback)callback
{
    return [[UHTTPRequest instance]sendAsynWith:param callback:callback delegate:nil identifier:-1];
}

+ (UHTTPOperation *)sendAsynWith:(UHTTPRequestParam *)param
                        delegate:(__weak id<UHTTPRequestDelegate>)delegate
                      identifier:(int)identifier
{
    return [[UHTTPRequest instance]sendAsynWith:param callback:NULL delegate:delegate identifier:identifier];
}

- (UHTTPOperation *)sendAsynWith:(UHTTPRequestParam *)param
                        callback:(UHTTPCallback)callback
                        delegate:(id<UHTTPRequestDelegate>)delegate
                      identifier:(int)identifier
{
    NSString *url = param.url;
    NSString *method = [param.method uppercaseString];
    
    // Body
    NSString *body = nil;
    if ([param.body isKindOfClass:[NSDictionary class]]) {
        if ([method isEqualToString:@"GET"]) {
            NSString *paramValue = @"?";
            for (NSString *key in param.body) {
                NSString *value = [[NSString stringWithFormat:@"%@", param.body[key]]URLEncodedString];
                paramValue = [paramValue stringByAppendingFormat:@"%@=%@&", key, value];
            }
            
            // GET style url
            paramValue = [paramValue substringToIndex:paramValue.length - 1];
            url = [url stringByAppendingString:paramValue];
        } else {
            @try {
                if (param.json) {
                    NSData *json = [NSJSONSerialization dataWithJSONObject:param
                                                                   options:NSJSONWritingPrettyPrinted
                                                                     error:nil];
                    body = [[NSString alloc]initWithData:json encoding:NSUTF8StringEncoding];
                } else {
                    NSString *bodyValue = @"";
                    for (NSString *key in param.body) {
                        bodyValue = [bodyValue stringByAppendingFormat:@"%@=%@&", key, param.body[key]];
                    }
                    body = [bodyValue substringToIndex:bodyValue.length - 1];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"UHTTPRequest Exception:\n%@",exception);
                body = nil;
            }
        }
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = method;
    request.HTTPBody = (checkValidNSString(body))?[body dataUsingEncoding:NSUTF8StringEncoding]:nil;
    
    // Set http header
    for (NSString *field in param.header) {
        NSString *value = param.header[field];
        [request setValue:value forHTTPHeaderField:field];
    }
    
    UHTTPOperationParam *rparam = [UHTTPOperationParam param];
    rparam.request = request;
    rparam.cached = param.cached;
    rparam.cacheKey = param.cacheKey;
    rparam.timeout = param.timeout;
    rparam.retry = param.retry;
    rparam.retryInterval = param.retryInterval;
    
    UHTTPOperation *operation = nil;
    if (callback) {
        operation = [[UHTTPOperation alloc]initWith:rparam callback:callback];
    }
    
    if (delegate) {
        operation = [[UHTTPOperation alloc]initWith:rparam delegate:delegate identifier:identifier];
    }
    
    return operation.weakself;
}

+ (NSData *)sendSyncWith:(UHTTPRequestParam *)param
                response:(NSURLResponse **)response
                   error:(NSError **)error
{
    NSString *url = param.url;
    NSString *method = [param.method uppercaseString];
    
    // Body
    NSString *body = nil;
    if ([param.body isKindOfClass:[NSDictionary class]]) {
        if ([method isEqualToString:@"GET"]) {
            url = [url stringByAppendingString:@"?"];
            for (NSString *key in param.body) {
                url = [url stringByAppendingFormat:@"%@=%@&", key, param.body[key]];
            }
            
            // GET style url
            url = [url substringToIndex:url.length - 1];
        } else {
            @try {
                if (param.json) {
                    NSData *json = [NSJSONSerialization dataWithJSONObject:param
                                                                   options:NSJSONWritingPrettyPrinted
                                                                     error:nil];
                    body = [[NSString alloc]initWithData:json encoding:NSUTF8StringEncoding];
                } else {
                    NSString *bodyValue = @"";
                    for (NSString *key in param.body) {
                        bodyValue = [bodyValue stringByAppendingFormat:@"%@=%@&", key, param.body[key]];
                    }
                    body = [bodyValue substringToIndex:bodyValue.length - 1];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"UHTTPRequest Exception:\n%@",exception);
                body = nil;
            }
        }
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = method;
    request.HTTPBody = (checkValidNSString(body))?[body dataUsingEncoding:NSUTF8StringEncoding]:nil;
    
    // Set http header
    for (NSString *field in param.header) {
        NSString *value = param.header[field];
        [request setValue:value forHTTPHeaderField:field];
    }
    
    return [NSURLConnection sendSynchronousRequest:request returningResponse:response error:error];
}

@end

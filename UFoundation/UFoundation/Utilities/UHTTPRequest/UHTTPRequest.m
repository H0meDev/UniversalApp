//
//  UHTTPRequest.m
//  UFoundation
//
//  Created by Think on 15/5/23.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UHTTPRequest.h"

#import <mach/mach_time.h>

#import "NSObject+UAExtension.h"
#import "NSDictionary+UAExtension.h"
#import "NSString+UAExtension.h"

@interface UHTTPQueue ()
{
    UOperationQueue *_queue;
}

@end

@implementation UHTTPQueue

singletonImplementation(UHTTPQueue);

- (id)init
{
    self = [super init];
    if (self) {
        _queue = [UOperationQueue queue];
    }
    
    return self;
}

- (UOperationQueue *)operationQueue
{
    return _queue;
}

@end

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
        _redirect = YES;
        _enableLog = YES;
    }
    
    return self;
}

- (void)dealloc
{
    //
}

@end

@implementation UHTTPRequestResult

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
#if DEBUG
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
#endif
}

#pragma mark - Request

+ (UHTTPOperation *)sendAsynWith:(UHTTPRequestParam *)param
                        complete:(UHTTPCompleteCallback)complete
{
    return [[UHTTPRequest instance]sendAsynWith:param
                                       response:NULL
                                       progress:NULL
                                       complete:complete
                                       delegate:nil
                                     identifier:-1];
}

+ (UHTTPOperation *)sendAsynWith:(UHTTPRequestParam *)param
                        progress:(UHTTPProgressCallback)progress
                        complete:(UHTTPCompleteCallback)complete
{
    return [[UHTTPRequest instance]sendAsynWith:param
                                       response:NULL
                                       progress:progress
                                       complete:complete
                                       delegate:nil
                                     identifier:-1];
}

+ (UHTTPOperation *)sendAsynWith:(UHTTPRequestParam *)param
                        response:(UHTTPResponseCallback)response
                        progress:(UHTTPProgressCallback)progress
                        complete:(UHTTPCompleteCallback)complete
{
    return [[UHTTPRequest instance]sendAsynWith:param
                                       response:response
                                       progress:progress
                                       complete:complete
                                       delegate:nil
                                     identifier:-1];
}

+ (UHTTPOperation *)sendAsynWith:(UHTTPRequestParam *)param
                        delegate:(__weak id<UHTTPRequestDelegate>)delegate
                      identifier:(int)identifier
{
    return [[UHTTPRequest instance]sendAsynWith:param
                                       response:NULL
                                       progress:NULL
                                       complete:NULL
                                       delegate:delegate
                                     identifier:identifier];
}

- (UHTTPOperation *)sendAsynWith:(UHTTPRequestParam *)param
                        response:(UHTTPResponseCallback)response
                        progress:(UHTTPProgressCallback)progress
                        complete:(UHTTPCompleteCallback)complete
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
    rparam.redirect = param.redirect;
    rparam.enableLog = param.enableLog;
    
    UOperationQueue *queue = [UHTTPQueue sharedUHTTPQueue].operationQueue;
    [rparam performWithName:@"setOperationQueue:" with:queue];
    
    UHTTPOperation *operation = nil;
    if (complete) {
        operation = [[UHTTPOperation alloc]initWith:rparam response:response progress:progress callback:complete];
    }
    
    if (delegate) {
        operation = [[UHTTPOperation alloc]initWith:rparam delegate:delegate identifier:identifier];
    }
    
    return operation.weakself;
}

+ (UHTTPRequestResult *)sendSyncWith:(UHTTPRequestParam *)param
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
    [request setTimeoutInterval:param.timeout];
    
    // Set http header
    for (NSString *field in param.header) {
        NSString *value = param.header[field];
        [request setValue:value forHTTPHeaderField:field];
    }

#if DEBUG
    if (param.enableLog) {
        NSString *header = checkValidNSDictionary(request.allHTTPHeaderFields)?[request.allHTTPHeaderFields JSONString]:@"";
        NSString *body = [[NSString alloc]initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
        NSLog(@"\nUHTTP REQUEST START:\n*********************************\nURL: %@\nMETHOD: %@\nHEADER: %@\nBODY: %@\n*********************************", request.URL.absoluteString, request.HTTPMethod, header, body);
    }
#endif
    
    // Start time
    uint64_t startTime = mach_absolute_time();
    
    id responseObject = nil;
    NSHTTPURLResponse *httpResponse = nil;
    NSError *error = nil;
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResponse error:&error];
    __autoreleasing UHTTPRequestResult *result = [[UHTTPRequestResult alloc]init];
    
    // End time
    uint64_t endTime = mach_absolute_time();
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    CGFloat usedTime = (CGFloat)(endTime - startTime) * info.numer/NSEC_PER_SEC;
    
#if DEBUG
    NSString *statusText = error?@"ERROR":@"OK";
#endif
    
    @try
    {
        if (receivedData) {
            NSStringEncoding stringEncoding = NSUTF8StringEncoding;
            if (httpResponse.textEncodingName) {
                CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)httpResponse.textEncodingName);
                if (encoding != kCFStringEncodingInvalidId) {
                    stringEncoding = CFStringConvertEncodingToNSStringEncoding(encoding);
                }
            }
            
            // Parsed to text
            NSString *responseString = [[NSString alloc]initWithData:receivedData encoding:stringEncoding];
            if (!responseString) {
                stringEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                responseString = [[NSString alloc]initWithData:receivedData encoding:stringEncoding];
            }
            
            // Parsed to JSON
            if (responseString && responseString.length > 1) {
                NSError *error = nil;
                NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
                if (data && data.length > 0) {
                    responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                }
            }
            
            if (!responseString) {
                responseObject = receivedData;
#if DEBUG
                if (param.enableLog) {
                    NSLog(@"Current data can not be parsed to text");
                }
#endif
            } else {
                if (!responseObject) {
                    responseObject = responseString;
#if DEBUG
                    if (param.enableLog) {
                        NSLog(@"Current data is not JSON");
                    }
#endif
                }
            }
        }
    }
    @catch (NSException *exception)
    {
#if DEBUG
        statusText = @"Parse exception";
#endif
    }
    @finally
    {
#if DEBUG
        if (param.enableLog) {
            if (![statusText isEqualToString:@"OK"]) {
                NSLog(@"\nUHTTP REQUEST RESULT\n*********************************\nSTATUS: %@\nTIME: %fs\nURL: %@\nDESCRIPTION: \n%@\n*********************************", statusText, usedTime, request.URL.absoluteString, error.description);
            } else {
                NSLog(@"\nUHTTP REQUEST RESULT\n*********************************\nSTATUS: %@\nTIME: %fs\nURL: %@\nDATA: \n%@\n*********************************",statusText, usedTime, request.URL.absoluteString, responseObject);
            }
        }
#endif
        UHTTPStatus *status = [[UHTTPStatus alloc]init];
        status.code = httpResponse.statusCode;
        status.time = usedTime;
        status.countOfRetry = 0;
        status.url = request.URL.absoluteString;
        
        result.status = status;
        result.data = responseObject;
    }
    
    return result;
}

@end

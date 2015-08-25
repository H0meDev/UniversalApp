//
//  UHTTPOperation.m
//  UFoundation
//
//  Created by Cailiang on 14-9-16.
//  Copyright (c) 2014年 Cailiang. All rights reserved.
//

#import "UHTTPOperation.h"
#import "UOperationQueue.h"
#import "UTimerBooster.h"
#import "NSObject+UAExtension.h"


@implementation UHTTPStatus

@end

@interface UHTTPOperation () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    __block UHTTPCallback _callback;
    __block UHTTPReceivedResponseCallback _response;
    __block UHTTPReceivedDataCallback _received;
    __weak id<UHTTPRequestDelegate> _delegate;
    
    time_t start_time;
    NSInteger _timeout;
    NSInteger _countOfRetry;
    NSUInteger _timeInterval;
    __strong UHTTPOperation *_operationHolder;
    
    long long _receivedLength;
    NSMutableData *_receivedData;
    NSURLConnection *_connection;
    NSHTTPURLResponse *_httpResponse;
    id _responseObject;
}

@end

@implementation UHTTPOperation

#pragma mark - Life Circle

- (instancetype)initWithRequest:(NSURLRequest *)request callback:(UHTTPCallback)callback
{
    return [self initWithRequest:request recevied:NULL callback:callback];
}

- (instancetype)initWithRequest:(NSURLRequest *)request recevied:(UHTTPReceivedDataCallback)recevied callback:(UHTTPCallback)callback
{
    return [self initWithRequest:request response:NULL recevied:recevied callback:callback];
}

- (instancetype)initWithRequest:(NSURLRequest *)request response:(UHTTPReceivedResponseCallback)response recevied:(UHTTPReceivedDataCallback)recevied callback:(UHTTPCallback)callback
{
    self = [super init];
    if (self) {
        // Initalize
        _connection = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:NO];
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
#pragma clang diagnostic ignored "-Wgnu"
        _callback = [callback copy];
        if (response) {
            _response = [response copy];
        }
        
        if (recevied) {
            _received = [recevied copy];
        }
        
        // Default is 30
        [self setTimeOut:30];
        _receivedLength = 0;
        _countOfRetry = 0;
        _timeInterval = 0;
        _request = request;
        
#if DEBUG
        NSMutableURLRequest *mrequest = (NSMutableURLRequest *)request;
        NSString *body = [[NSString alloc]initWithData:mrequest.HTTPBody encoding:NSUTF8StringEncoding];
        NSLog(@"\nUHTTP REQUEST START:\n*********************************\nURL: %@\nMETHOD: %@\nBODY: %@\n*********************************",mrequest.URL.absoluteString,mrequest.HTTPMethod,body);
#endif
    }
    
    return self;
}

- (instancetype)initWithRequest:(NSURLRequest *)request delegate:(id<UHTTPRequestDelegate>)delegate tag:(int)tag
{
    self = [super init];
    if (self) {
        // Initalize
        _connection = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:NO];
        _delegate = delegate;
        _tag = tag;
        
        // Default is 30
        [self setTimeOut:30];
        _receivedLength = 0;
        _countOfRetry = 0;
        _timeInterval = 0;
        _request = request;
        
#if DEBUG
        NSMutableURLRequest *mrequest = (NSMutableURLRequest *)request;
        NSLog(@"\nUHTTP REQUEST START:\n*********************************\nURL: %@\nMETHOD: %@\nBODY: %@\n*********************************",mrequest.URL.absoluteString,mrequest.HTTPMethod,mrequest.HTTPBody);
#endif
    }
    return self;
}

- (void)main
{
    // Start request
    [self startConnection];
}

- (void)startConnection
{
    // Start time
    start_time = clock();
    
    // Timeout setting
    [UTimerBooster addTarget:self sel:@selector(requestTimeout) time:_timeout];
    
    [_connection scheduleInRunLoop:[NSRunLoop mainRunLoop]forMode:NSRunLoopCommonModes];
    [_connection start];
}

- (void)dealloc
{
    _connection = nil;
    _request = nil;
    _response = nil;
    _delegate = nil;
    _callback = NULL;
    _received = NULL;
    [_receivedData setData:nil];
    _receivedData = nil;
    
    NSLog(@"UHTTPRequestOperation dealloc");
}

#pragma mark - Methods

- (id<UHTTPRequestDelegate>)delegate
{
    return _delegate;
}

- (void)setTimeOut:(NSInteger)seconds
{
    if (seconds > 0) {
        _timeout = seconds;
    }
    
    [UTimerBooster start];
}

- (void)setRetryTimes:(NSUInteger)times
{
    _countOfRetry = times;
}

- (void)setRetryTimeInterval:(NSUInteger)timeInterval
{
    _timeInterval = timeInterval;
}

- (void)cancel
{
    // Cancel connection
    [_connection cancel];
    
    // Remove from cache
    [UOperationQueue removeOperation:self];
    
    [super cancel];
}

- (void)requestTimeout
{
    NSURLRequest *request = _connection.originalRequest;
    NSLog(@"\nUHTTP REQUEST RESULT\n*********************************\nSTATUS: TIMEOUT\nTIME: %@s\nURL: %@\n*********************************", [NSNumber numberWithInteger:_timeout], request.URL.absoluteString);
    
    // Cancel connection
    [_connection cancel];
    
    if (_countOfRetry > 1) {
        _countOfRetry --;
        
        if (!_operationHolder) {
            _operationHolder = self;
        }
        
        [UTimerBooster addTarget:self sel:@selector(startConnection) time:_timeInterval];
    } else {
        if (_connection) {
            UHTTPStatus *status = [[UHTTPStatus alloc]init];
            status.code = UHTTPCodeRequestTimeout;
            status.time = _timeout;
            status.url = request.URL.absoluteString;
            
            if (_callback) {
                _callback(status, nil);
            } else {
                if (_delegate && [_delegate respondsToSelector:@selector(requestFinishedCallback:status:data:)]) {
                    [_delegate requestFinishedCallback:_tag status:status data:nil];
                }
            }
        }
        
        _operationHolder = nil;
    }
}

#pragma mark - NSURLConnectionDelegate & NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"\nUHTTP RECEIVED RESPONSE:\n*********************************\n%@\n*********************************",response.description);
    
    _httpResponse = (NSHTTPURLResponse *)response;
    
    if (_response) {
        UHTTPStatus *status = [[UHTTPStatus alloc]init];
        status.code = _httpResponse.statusCode;
        _response(status);
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(requestDidReceviedResponseCallback:)]) {
            UHTTPStatus *status = [[UHTTPStatus alloc]init];
            status.code = _httpResponse.statusCode;
            [_delegate requestDidReceviedResponseCallback:status];
        }
    }
    
    // Cancel timeout
    [UTimerBooster removeTarget:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (_receivedData == nil) {
        _receivedData = [[NSMutableData alloc]init];
    }
    [_receivedData appendData:data];
    
    _receivedLength += data.length;
    
    if (_received) {
        _received(data, _receivedLength, _httpResponse.expectedContentLength);
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(requestDidReceviedDataCallback:data:receivedLength:expectedLength:)]) {
            [_delegate requestDidReceviedDataCallback:_tag data:data receivedLength:_receivedLength expectedLength:_httpResponse.expectedContentLength];
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSURLRequest *request = [connection originalRequest];
    clock_t end_time = clock();
    CGFloat usedTime = (CGFloat)(end_time - start_time)/CLOCKS_PER_SEC;
    
#if DEBUG
    NSString *status = @"OK";
#endif
    
    @try
    {
        if (_receivedData) {
            NSStringEncoding stringEncoding = NSUTF8StringEncoding;
            if (_httpResponse.textEncodingName) {
                if ([_httpResponse.textEncodingName isEqualToString:@"gb2312"]) {
                    stringEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                } else {
                    CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)_httpResponse.textEncodingName);
                    if (encoding != kCFStringEncodingInvalidId) {
                        stringEncoding = CFStringConvertEncodingToNSStringEncoding(encoding);
                    }
                }
            }
            
            // Parse data
            NSString *responseString = [[NSString alloc]initWithData:_receivedData encoding:stringEncoding];
            
            _responseObject = nil;
            NSError *error = nil;
            
            if (responseString && responseString.length > 1) {
                // To JSON
                NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
                if (data && data.length > 0) {
                    _responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                }
            }
            
            if (!_responseObject) {
                if (responseString) {
                    _responseObject = responseString;
                    NSLog(@"Current data is not JSON");
                } else {
                    _responseObject = _receivedData;
                    NSLog(@"Current data can not be parsed");
                }
            }
            
            responseString = nil;
        }
    }
    @catch (NSException *exception)
    {
#if DEBUG
        status = @"Parse exception";
#endif
    }
    @finally
    {
#if DEBUG
        NSLog(@"\nUHTTP REQUEST RESULT\n*********************************\nSTATUS: %@\nTIME: %fs\nURL: %@\nDATA: \n%@\n*********************************",status, usedTime, request.URL.absoluteString, _responseObject);
#endif
        UHTTPStatus *status = [[UHTTPStatus alloc]init];
        status.code = _httpResponse.statusCode;
        status.time = usedTime;
        status.url = request.URL.absoluteString;
        
        if (_callback) {
            _callback(status, _responseObject);
        } else {
            if (_delegate && [_delegate respondsToSelector:@selector(requestFinishedCallback:status:data:)]) {
                [_delegate requestFinishedCallback:_tag status:status data:_responseObject];
            }
        }
        
        [UOperationQueue removeOperation:self];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSURLRequest *request = [connection originalRequest];
    clock_t end_time = clock();
    CGFloat usedTime = (CGFloat)(end_time - start_time)/CLOCKS_PER_SEC;
    NSLog(@"\nUHTTP REQUEST RESULT\n*********************************\nSTATUS: ERROR\nTIME: %fs\nURL: %@\nDESCRIPTION: \n%@\n*********************************",usedTime, request.URL.absoluteString, error.description);
    
    // Cancel timeout
    [UTimerBooster removeTarget:self];
    
    if (_countOfRetry > 1) {
        _countOfRetry --;
        
        if (!_operationHolder) {
            _operationHolder = self;
        }
        
        [UTimerBooster addTarget:self sel:@selector(startConnection) time:_timeInterval];
    } else {
        UHTTPStatus *status = [[UHTTPStatus alloc]init];
        status.code = _httpResponse.statusCode;
        status.time = usedTime;
        status.url = request.URL.absoluteString;
        
        if (_callback) {
            _callback(status, nil);
        } else {
            if (_delegate && [_delegate respondsToSelector:@selector(requestFinishedCallback:status:data:)]) {
                [_delegate requestFinishedCallback:_tag status:status data:nil];
            }
        }
        
        _operationHolder = nil;
    }
    
    [UOperationQueue removeOperation:self];
}

#pragma mark - For HTTPS request

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
    return NO;
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        [[challenge sender]useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]forAuthenticationChallenge:challenge];
        [[challenge sender]continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}

@end
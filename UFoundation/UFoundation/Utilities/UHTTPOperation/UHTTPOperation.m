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
#import "NSString+UAExtension.h"
#import "NSDictionary+UAExtension.h"

@implementation UHTTPStatus

- (id)init
{
    self = [super init];
    if (self) {
        self.code = UHTTPCodeOffline;
        self.time = 0;
        self.countOfRetry = 0;
        self.url = nil;
    }
    
    return self;
}

@end

@interface UHTTPDataCache ()
{
    NSString *_filePath;
    NSLock *_accessLock;
}

@property (atomic, strong) NSMutableDictionary *cachedData;

@end

@interface UHTTPOperationParam ()

@property (nonatomic, strong) UOperationQueue *queue;

@end

@implementation UHTTPOperationParam

+ (id)param
{
    @autoreleasepool
    {
        return [[UHTTPOperationParam alloc]init];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialize
        _timeout = 30;
        _retry = 0;
        _retryInterval = 0;
        _cacheKey = @"";
    }
    
    return self;
}

- (void)setOperationQueue:(UOperationQueue *)queue
{
    _queue = queue;
}

- (void)dealloc
{
    _queue = nil;
}

@end

@implementation UHTTPDataCache

singletonImplementationWith(UHTTPDataCache, cache);

- (id)init
{
    self = [super init];
    if (self) {
        _accessLock = [[NSLock alloc]init];
        _filePath = cachePathWith(@"http_cache");
        
        if (!checkFileExists(_filePath)) {
            // Check directory
            if (!checkCacheDirectoryExists()) {
                createCacheDirectory();
            }
            
            createFile(_filePath);
        }
        
        NSString *serialization = [[NSString alloc]initWithContentsOfFile:_filePath encoding:NSUTF8StringEncoding error:NULL];
        _cachedData = [NSMutableDictionary dictionaryWithDictionary:[serialization JSONValue]];
        if (!_cachedData) {
            _cachedData = [NSMutableDictionary dictionary];
        }
    }
    
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if (!value || !checkValidNSString(key)) {
        return;
    }
    
    [_accessLock lock];
    [_cachedData setObject:value forKey:key];
    NSString *serialization = [[_cachedData copy] JSONString];
    [serialization writeToFile:_filePath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    [_accessLock unlock];
}

- (id)objectForKey:(NSString *)key
{
    if (!checkValidNSString(key)) {
        return nil;
    }
    
    return [_cachedData objectForKey:key];
}

- (void)clearAllCache
{
    [_accessLock lock];
    [_cachedData removeAllObjects];
    NSString *serialization = @"";
    [serialization writeToFile:_filePath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    [_accessLock unlock];
}

@end

@interface UHTTPOperation () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    __block UHTTPCompleteCallback _callback;
    __block UHTTPResponseCallback _response;
    __block UHTTPProgressCallback _received;
    __weak id<UHTTPRequestDelegate> _delegate;
    
    BOOL _cacheRequired;
    NSString *_cacheKey;
    
    clock_t _startTime;
    NSInteger _timeout;
    NSInteger _countOfRetry;
    NSUInteger _timeInterval;
    __strong UOperationQueue *_operationQueue;
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

- (id)initWith:(UHTTPOperationParam *)param
      callback:(UHTTPCompleteCallback)callback
{
    return [self initWith:param progress:NULL callback:callback];
}

- (id)initWith:(UHTTPOperationParam *)param
      progress:(UHTTPProgressCallback)progress
      callback:(UHTTPCompleteCallback)callback
{
    return [self initWith:param response:NULL progress:progress callback:callback];
}

- (id)initWith:(UHTTPOperationParam *)param
      response:(UHTTPResponseCallback)response
      progress:(UHTTPProgressCallback)progress
      callback:(UHTTPCompleteCallback)callback
{
    self = [super init];
    if (self) {
        // Initialize
        if (checkClass(param, UHTTPOperationParam)) {
            _connection = [[NSURLConnection alloc]initWithRequest:param.request delegate:self startImmediately:NO];
            
            _callback = callback;
            if (response) {
                _response = response;
            }
            
            if (progress) {
                _received = progress;
            }
            
            // Default is 30
            [self setTimeOut:param.timeout];
            _receivedLength = 0;
            _request = param.request;
            _countOfRetry = param.retry;
            _timeInterval = param.retryInterval;
            _cacheRequired = param.cached;
            _operationQueue = param.queue;
            
            if (_cacheRequired) {
                // Get cached data
                NSString *url = param.request.URL.absoluteString;
                NSString *method = param.request.HTTPMethod;
                _cacheKey = [[NSString stringWithFormat:@"%@%@%@", url, method, param.cacheKey]MD5String];
                
                id data = [[UHTTPDataCache cache]objectForKey:_cacheKey];
                if (data) {
                    // Status for cache
                    UHTTPStatus *status = [[UHTTPStatus alloc]init];
                    status.code = UHTTPCodeLocalCached;
                    
                    if (_callback) {
                        _callback(status, data);
                    }
                }
            }
            
            // Add to UOperationQueue
            [_operationQueue addOperation:self];
            
#if DEBUG
            NSMutableURLRequest *mrequest = (NSMutableURLRequest *)param.request;
            NSString *header = checkValidNSDictionary(mrequest.allHTTPHeaderFields)?[mrequest.allHTTPHeaderFields JSONString]:@"";
            NSString *body = [[NSString alloc]initWithData:mrequest.HTTPBody encoding:NSUTF8StringEncoding];
            NSLog(@"\nUHTTP REQUEST START:\n*********************************\nURL: %@\nMETHOD: %@\nHEADER: %@\nBODY: %@\n*********************************",mrequest.URL.absoluteString, mrequest.HTTPMethod, header, body);
#endif
        }
    }
    
    return self;
}

- (id)initWith:(UHTTPOperationParam *)param
      delegate:(id<UHTTPRequestDelegate>)delegate
    identifier:(int)identifier
{
    self = [super init];
    if (self) {
        // Initialize
        if (checkClass(param, UHTTPOperationParam)) {
            _connection = [[NSURLConnection alloc]initWithRequest:param.request delegate:self startImmediately:NO];
            _delegate = delegate;
            _identifier = identifier;
            
            // Default is 30
            [self setTimeOut:param.timeout];
            _receivedLength = 0;
            _request = param.request;
            _countOfRetry = param.retry;
            _timeInterval = param.retryInterval;
            _cacheRequired = param.cached;
            _operationQueue = param.queue;
            
            // Add to UOperationQueue
            [_operationQueue addOperation:self];
            
#if DEBUG
            NSMutableURLRequest *mrequest = (NSMutableURLRequest *)param.request;
            NSString *header = checkValidNSDictionary(mrequest.allHTTPHeaderFields)?[mrequest.allHTTPHeaderFields JSONString]:@"";
            NSString *body = [[NSString alloc]initWithData:mrequest.HTTPBody encoding:NSUTF8StringEncoding];
            NSLog(@"\nUHTTP REQUEST START:\n*********************************\nURL: %@\nMETHOD: %@\nHEADER: %@\nBODY: %@\n*********************************", mrequest.URL.absoluteString, mrequest.HTTPMethod, header, body);
#endif
        }
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
    _startTime = clock();
    
    // Timeout setting
    [UTimerBooster addTarget:self sel:@selector(requestTimeout) time:_timeout];
    
    [_connection scheduleInRunLoop:[NSRunLoop mainRunLoop]forMode:NSRunLoopCommonModes];
    [_connection start];
}

- (void)dealloc
{
    _response = nil;
    _delegate = nil;
    _callback = NULL;
    _received = NULL;
    
    _request = nil;
    _connection = nil;
    _httpResponse = nil;
    _receivedData = nil;
    _operationQueue = nil;
    
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
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

- (void)cancel
{
    // Cancel connection
    [_connection cancel];
    
    // Remove timeout & operation
    [UTimerBooster removeTarget:self];
    [_operationQueue removeOperation:self];
    
    [super cancel];
  
#if DEBUG
    NSURLRequest *request = _connection.originalRequest;
    NSLog(@"\nUHTTP REQUEST RESULT\n*********************************\nSTATUS: CANCELD\nURL: %@\n*********************************", request.URL.absoluteString);
#endif
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
            status.countOfRetry = _countOfRetry;
            status.url = request.URL.absoluteString;
            
            if (_callback) {
                _callback(status, nil);
            } else {
                if (_delegate && [_delegate respondsToSelector:@selector(requestCompleteCallback:status:data:)]) {
                    [_delegate requestCompleteCallback:_identifier status:status data:nil];
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
        if (_delegate && [_delegate respondsToSelector:@selector(requestResponseCallback:status:)]) {
            UHTTPStatus *status = [[UHTTPStatus alloc]init];
            status.code = _httpResponse.statusCode;
            [_delegate requestResponseCallback:_identifier status:status];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    @autoreleasepool
    {
        if (_receivedData == nil) {
            _receivedData = [NSMutableData data];
            
            // Cancel timeout
            [UTimerBooster removeTarget:self];
        }
        [_receivedData appendData:data];
        
        _receivedLength += data.length;
        
        if (_received) {
            _received(data, _receivedLength, _httpResponse.expectedContentLength);
        } else {
            if (_delegate && [_delegate respondsToSelector:@selector(requestProgressCallback:data:receivedLength:expectedLength:)]) {
                [_delegate requestProgressCallback:_identifier data:data receivedLength:_receivedLength expectedLength:_httpResponse.expectedContentLength];
            }
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSURLRequest *request = [connection originalRequest];
    clock_t endTime = clock();
    CGFloat usedTime = (CGFloat)(endTime - _startTime)/CLOCKS_PER_SEC;
    
#if DEBUG
    NSString *statusText = @"OK";
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
            
            _responseObject = nil;
            NSError *error = nil;
            
            // Parse data
            NSString *responseString = [[NSString alloc]initWithData:_receivedData encoding:stringEncoding];
            if (!responseString && stringEncoding == NSUTF8StringEncoding) {
                stringEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                responseString = [[NSString alloc]initWithData:_receivedData encoding:stringEncoding];
            }
            
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
        statusText = @"Parse exception";
#endif
    }
    @finally
    {
#if DEBUG
        NSLog(@"\nUHTTP REQUEST RESULT\n*********************************\nSTATUS: %@\nTIME: %fs\nURL: %@\nDATA: \n%@\n*********************************",statusText, usedTime, request.URL.absoluteString, _responseObject);
#endif
        UHTTPStatus *status = [[UHTTPStatus alloc]init];
        status.code = _httpResponse.statusCode;
        status.time = usedTime;
        status.countOfRetry = _countOfRetry;
        status.url = request.URL.absoluteString;
        
        if (_callback) {
            _callback(status, _responseObject);
        } else {
            if (_delegate && [_delegate respondsToSelector:@selector(requestCompleteCallback:status:data:)]) {
                [_delegate requestCompleteCallback:_identifier status:status data:_responseObject];
            }
        }
        
        // Cache data
        if (_cacheRequired) {
            [[UHTTPDataCache cache]setValue:_responseObject forKey:_cacheKey];
        }
        
        [_operationQueue removeOperation:self];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Cancel timeout
    [UTimerBooster removeTarget:self];
    
    NSURLRequest *request = [connection originalRequest];
    clock_t endTime = clock();
    CGFloat usedTime = (CGFloat)(endTime - _startTime)/CLOCKS_PER_SEC;
    
    NSLog(@"\nUHTTP REQUEST RESULT\n*********************************\nSTATUS: ERROR\nTIME: %fs\nURL: %@\nDESCRIPTION: \n%@\n*********************************", usedTime, request.URL.absoluteString, error.description);
    
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
        status.countOfRetry = _countOfRetry;
        status.url = request.URL.absoluteString;
        
        if (_callback) {
            _callback(status, nil);
        } else {
            if (_delegate && [_delegate respondsToSelector:@selector(requestCompleteCallback:status:data:)]) {
                [_delegate requestCompleteCallback:_identifier status:status data:nil];
            }
        }
        
        _operationHolder = nil;
    }
    
    [_operationQueue removeOperation:self];
}

#pragma mark - For HTTPS request

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
    return NO;
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    NSString *method = protectionSpace.authenticationMethod;
    return [method isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSString *method = challenge.protectionSpace.authenticationMethod;
    if ([method isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        SecTrustRef trust = challenge.protectionSpace.serverTrust;
        NSURLCredential *credential = [NSURLCredential credentialForTrust:trust];
        
        [[challenge sender]useCredential:credential forAuthenticationChallenge:challenge];
        [[challenge sender]continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}

@end
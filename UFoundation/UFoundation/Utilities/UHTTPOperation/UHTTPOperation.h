//
//  UHTTPOperation.h
//  UFoundation
//
//  Created by Cailiang on 14-9-16.
//  Copyright (c) 2014年 Cailiang. All rights reserved.
//

#import "UDefines.h"

// References http://httpstatus.es/
typedef NS_ENUM(NSInteger, UHTTPCode)
{
    UHTTPCodeOffline                          = 0,
    UHTTPCodeLocalCached                      = 88888888,
    
    UHTTPCodeOK                               = 200,
    UHTTPCodeCreated                          = 201,
    UHTTPCodeAccepted                         = 202,
    UHTTPCodeNonAuthoritativeInfo             = 203,
    UHTTPCodeNoContent                        = 204,
    UHTTPCodeResetContent                     = 205,
    UHTTPCodePartialContent                   = 206, // Surport resume downloading
    
    UHTTPCodeMultipleChoices                  = 300,
    UHTTPCodeMovedPermanently                 = 301,
    UHTTPCodeFound                            = 302,
    UHTTPCodeSeeOther                         = 303,
    UHTTPCodeNotModified                      = 304,
    UHTTPCodeUseProxy                         = 305,
    UHTTPCodeTemporaryRedirect                = 307,
    
    UHTTPCodeBadRequest                       = 400,
    UHTTPCodeUnauthorized                     = 401,
    UHTTPCodeForbidden                        = 403,
    UHTTPCodeNotFound                         = 404,
    UHTTPCodeMethodNotAllowed                 = 405,
    UHTTPCodeMethodNotAcceptable              = 406,
    UHTTPCodeProxyAuthenticationRequired      = 407,
    UHTTPCodeRequestTimeout                   = 408,
    UHTTPCodeConflict                         = 409,
    UHTTPCodeGone                             = 410,
    UHTTPCodeLengthRequired                   = 411,
    
    UHTTPCodeInternalServerError              = 500,
    UHTTPCodeNotImplemented                   = 501,
    UHTTPCodeBadGateway                       = 502,
    UHTTPCodeServiceUnavailable               = 503,
    UHTTPCodeGatewayTimeout                   = 504,
    UHTTPCodeHttpVersionNotSupported          = 505,
};

@interface UHTTPStatus : NSObject

@property (nonatomic, assign) UHTTPCode code;         // Response code
@property (nonatomic, assign) CGFloat time;           // Time of request used
@property (nonatomic, strong) NSString *url;          // Original request url
@property (nonatomic, strong) NSString *redirectURL;  // Redirect url
@property (nonatomic, assign) NSInteger countOfRetry; // Count of retry left

@end

@interface UHTTPOperationParam : NSObject

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, assign) BOOL cached;
@property (nonatomic, assign) NSString *cacheKey;
@property (nonatomic, assign) CGFloat timeout;
@property (nonatomic, assign) NSInteger retry;
@property (nonatomic, assign) CGFloat retryInterval;
@property (nonatomic, assign) BOOL redirect;  // Allow redirect, default is YES, invalidate for synchronous

+ (id)param;

@end

@interface UHTTPDataCache : NSObject

singletonInterfaceWith(UHTTPDataCache, cache);

// Write & read
- (void)setValue:(id)value forKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;

// Clear all cached data
- (void)clearAllCache;

@end

@protocol UHTTPRequestDelegate <NSObject>

@required
- (void)requestCompleteCallback:(int)identifier status:(UHTTPStatus *)status data:(id)data;

@optional
- (void)requestResponseCallback:(int)identifier status:(UHTTPStatus *)status;
- (void)requestProgressCallback:(int)identifier
                           data:(id)data
                 receivedLength:(long long)rlength
                 expectedLength:(long long)elength;

@end

typedef void (^UHTTPResponseCallback)(UHTTPStatus *status);
typedef void (^UHTTPProgressCallback)(id data, long long receivedLength, long long expectedLength);
typedef void (^UHTTPCompleteCallback)(UHTTPStatus *status, id data);

@interface UHTTPOperation : NSOperation

@property (nonatomic, readonly) int identifier;
@property (nonatomic, readonly) id<UHTTPRequestDelegate> delegate;
@property (nonatomic, readonly) NSURLRequest *request;

/*
 * Block style
 */
- (id)initWith:(UHTTPOperationParam *)param
      callback:(UHTTPCompleteCallback)callback;

- (id)initWith:(UHTTPOperationParam *)param
      progress:(UHTTPProgressCallback)progress
      callback:(UHTTPCompleteCallback)callback;

- (id)initWith:(UHTTPOperationParam *)param
      response:(UHTTPResponseCallback)response
      progress:(UHTTPProgressCallback)progress
      callback:(UHTTPCompleteCallback)callback;

// Delegate
- (id)initWith:(UHTTPOperationParam *)param delegate:(id<UHTTPRequestDelegate>)delegate identifier:(int)identifier;

// Cancel request operation
- (void)cancel;

@end

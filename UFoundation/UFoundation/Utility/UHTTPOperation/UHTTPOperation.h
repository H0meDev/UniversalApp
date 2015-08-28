//
//  UHTTPOperation.h
//  UFoundation
//
//  Created by Cailiang on 14-9-16.
//  Copyright (c) 2014年 Cailiang. All rights reserved.
//

#import <UIKit/UIKit.h>

// References http://httpstatus.es/
typedef NS_ENUM(NSInteger, UHTTPCode)
{
    UHTTPCodeOffline                          = 0,
    
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

@property (nonatomic, assign) UHTTPCode code; // Response code
@property (nonatomic, assign) CGFloat time;   // Time of request used
@property (nonatomic, strong) NSString *url;  // Original request url

@end

@protocol UHTTPRequestDelegate <NSObject>

@required
- (void)requestFinishedCallback:(int)tag status:(UHTTPStatus *)status data:(id)data;

// For download
@optional
- (void)requestDidReceviedResponseCallback:(UHTTPStatus *)status;
- (void)requestDidReceviedDataCallback:(int)tag
                                  data:(id)data
                        receivedLength:(long long)rlength
                        expectedLength:(long long)elength;

@end

typedef void (^UHTTPReceivedResponseCallback)(UHTTPStatus *status);
typedef void (^UHTTPReceivedDataCallback)(id data, long long receivedLength, long long expectedLength);
typedef void (^UHTTPCallback)(UHTTPStatus *status, id data);

@interface UHTTPOperation : NSOperation

// Tag
@property (nonatomic, readonly) int tag;

// Target for downloader
@property (nonatomic, readonly) id<UHTTPRequestDelegate> delegate;

// Request of current
@property (nonatomic, readonly) NSURLRequest *request;

// Block style
- (id)initWithRequest:(NSURLRequest *)request callback:(UHTTPCallback)callback;

// Block style with recevied data
- (id)initWithRequest:(NSURLRequest *)request recevied:(UHTTPReceivedDataCallback)recevied callback:(UHTTPCallback)callback;

// Block style with recevied response & data
- (id)initWithRequest:(NSURLRequest *)request response:(UHTTPReceivedResponseCallback)response recevied:(UHTTPReceivedDataCallback)recevied callback:(UHTTPCallback)callback;

// Delegate
- (id)initWithRequest:(NSURLRequest *)request delegate:(id<UHTTPRequestDelegate>)delegate tag:(int)tag;

// Set timeout, seconds should not less than 1s
// Seconds default is 30s
- (void)setTimeOut:(NSInteger)seconds;

// Set times of retry
// times default is 0
// If your request is no need to retry, you`d better not use it.
// For that, the operation may stay long in memory.
- (void)setRetryTimes:(NSUInteger)times;

// Time interval of retry, default is 5s
- (void)setRetryTimeInterval:(NSUInteger)timeInterval;

// Cancel request operation
- (void)cancel;

@end

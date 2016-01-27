//
//  NetworkSDK.m
//  UniversalApp
//
//  Created by Think on 15/5/28.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "NetworkSDK.h"
#import "UserInfo.h"

@interface NetworkSDKInfo : BaseModel

@property (nonatomic, strong) NSString *serverAddress;

@end

@implementation NetworkSDKInfo

@end

@interface NetworkSDK ()
{
    NetworkSDKInfo *_info;
}

@end

@implementation NetworkSDK

singletonImplementationWith(NetworkSDK, sharedInstance);

- (id)init
{
    self = [super init];
    if (self) {
        _info = [NetworkSDKInfo model];
        _info.serverAddress = @"http://www.xiaodao360.com/";
    }
    
    return self;
}

- (UHTTPOperation *)requestWithURL:(NSString *)url
                method:(NSString *)method
               request:(NetworkRequest *)request
              callback:(NetworkCallback)callback
{
    NSString *serverAddress = [_info.serverAddress stringByAppendingString:url];
    UHTTPRequestParam *param = [UHTTPRequestParam param];
    param.url = serverAddress;
    param.method = [method uppercaseString];
    param.body = [request dictionary];
    param.json = NO;
    
    if (NSNotFound == [url rangeOfString:@"api/member/login"].location) {
        UserInfo *userInfo = [UserInfo info];
        if (userInfo.login) {
            NSString *tokenType = userInfo.login.token_type;
            NSString *tokenValue = userInfo.login.access_token;
            NSString *authorization = [NSString stringWithFormat:@"%@ %@", tokenType, tokenValue];
            
            NSMutableDictionary *header = [NSMutableDictionary dictionary];
            [header setObject:authorization forKey:@"Authorization"];
            [header setObject:@"*/*" forKey:@"Accept"];
            [header setObject:@"XiaoDaoWang/2.0.0 (iPhone; iOS 9.2; Scale/2.00)" forKey:@"User-Agent"];
            param.header = [header copy];
        } else {
            // Needs login
        }
    }
    
    NSString *className = NSStringFromClass([request class]);
    className = [className substringToIndex:className.length - 7];
    __block Class classResponse = NSClassFromString([className stringByAppendingString:@"Response"]);
    Class classResponseData = NSClassFromString([className stringByAppendingString:@"ResponseData"]);
    
    return [UHTTPRequest sendAsynWith:param callback:^(UHTTPStatus *status, id data) {
        if (UHTTPCodeOK == status.code) {
            classResponse = (classResponse)?classResponse:[NetworkResponse class];
            NetworkResponse *response = [classResponse modelWithDictionary:data];
            
            if (classResponseData) {
                if (checkClass(response.data, NSDictionary)) {
                    response.data = [classResponseData modelWithDictionary:response.data];
                } else if (checkClass(response.data, NSArray)) {
                    response.data = [classResponseData modelsWithArray:response.data];
                }
                
                // etc.
            }
            
            if (callback) {
                callback(status, response);
            }
        } else {
            if (callback) {
                callback(status, nil);
            }
        }
    }];
}

// 校导网登录
+ (UHTTPOperation *)loginWith:(LoginRequest *)request callback:(NetworkCallback)callback
{
    NSString *interface = @"api/member/login/__version/2.0.0";
    return [[self sharedInstance]requestWithURL:interface method:@"POST" request:request callback:callback];
}

// 获取用户信息
+ (UHTTPOperation *)userInfoWithCallback:(NetworkCallback)callback
{
    UserInfo *userInfo = [UserInfo info];
    UserInfoRequest *request = [UserInfoRequest model];
    request._fields = @"rong_token";
    request.mid = userInfo.login.mid;
    
    NSString *interface = @"api/user/info/__version/2.0.0";
    return [[self sharedInstance]requestWithURL:interface method:@"POST" request:request callback:callback];
}

@end

@interface NetworkSDKExtension () <UHTTPRequestDelegate>
{
    __strong id _hoder;
    int _identifier;
    __weak id _delegate;
    Class _classResponse;
    Class _classResponseData;
}

@end

@implementation NetworkSDKExtension

+ (id)instance
{
    @autoreleasepool
    {
        return [[NetworkSDKExtension alloc]init];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        _hoder = self;
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

- (UHTTPOperation *)requestWithURL:(NSString *)url
                            method:(NSString *)method
                           request:(NetworkRequest *)request
                          delegate:(__weak id<NetworkSDKDelegate>)delegate
                        identifier:(int)identifier
{
    NSString *serverAddress = @"http://www.xiaodao360.com/";
    serverAddress = [serverAddress stringByAppendingString:url];
    
    UHTTPRequestParam *param = [UHTTPRequestParam param];
    param.url = serverAddress;
    param.method = [method uppercaseString];
    param.body = [request dictionary];
    param.json = NO;
    
    if (NSNotFound == [url rangeOfString:@"api/member/login"].location) {
        UserInfo *userInfo = [UserInfo info];
        if (userInfo.login) {
            NSString *tokenType = userInfo.login.token_type;
            NSString *tokenValue = userInfo.login.access_token;
            NSString *authorization = [NSString stringWithFormat:@"%@ %@", tokenType, tokenValue];
            
            NSMutableDictionary *header = [NSMutableDictionary dictionary];
            [header setObject:authorization forKey:@"Authorization"];
            [header setObject:@"*/*" forKey:@"Accept"];
            [header setObject:@"XiaoDaoWang/2.0.0 (iPhone; iOS 9.2; Scale/2.00)" forKey:@"User-Agent"];
            param.header = [header copy];
        } else {
            // Needs login
        }
    }
    
    _delegate = delegate;
    _identifier = identifier;
    
    NSString *className = NSStringFromClass([request class]);
    className = [className substringToIndex:className.length - 7];
    _classResponse = NSClassFromString([className stringByAppendingString:@"Response"]);
    _classResponseData = NSClassFromString([className stringByAppendingString:@"ResponseData"]);
    
    return [UHTTPRequest sendAsynWith:param delegate:self identifier:-1];
}

- (void)requestFinishedCallback:(int)identifier status:(UHTTPStatus *)status data:(id)data
{
    if (UHTTPCodeOK == status.code) {
        _classResponse = (_classResponse)?_classResponse:[NetworkResponse class];
        NetworkResponse *response = [_classResponse modelWithDictionary:data];
        
        if (_classResponseData) {
            if (checkClass(response.data, NSDictionary)) {
                response.data = [_classResponseData modelWithDictionary:response.data];
            } else if (checkClass(response.data, NSArray)) {
                response.data = [_classResponseData modelsWithArray:response.data];
            }
            
            // etc.
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(networkSDKCallback:status:response:)]) {
            [_delegate networkSDKCallback:_identifier status:status response:response];
        }
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(networkSDKCallback:status:response:)]) {
            [_delegate networkSDKCallback:_identifier status:status response:nil];
        }
    }
    
    _hoder = nil;
}

+ (UHTTPOperation *)loginWith:(LoginRequest *)request delegate:(__weak id<NetworkSDKDelegate>)delegate identifier:(int)identifier
{
    NSString *interface = @"api/member/login/__version/2.0.0";
    return [[self instance]requestWithURL:interface
                                         method:@"POST"
                                        request:request
                                       delegate:delegate
                                     identifier:identifier];
}

// Get account info
+ (UHTTPOperation *)userInfoWithDelegate:(__weak id<NetworkSDKDelegate>)delegate identifier:(int)identifier
{
    UserInfo *userInfo = [UserInfo info];
    UserInfoRequest *request = [UserInfoRequest model];
    request._fields = @"rong_token";
    request.mid = userInfo.login.mid;
    
    NSString *interface = @"api/user/info/__version/2.0.0";
    return [[self instance]requestWithURL:interface
                                   method:@"POST"
                                  request:request
                                 delegate:delegate
                               identifier:identifier];
}

@end

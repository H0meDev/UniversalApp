//
//  NetworkSDK.h
//  UniversalApp
//
//  Created by Think on 15/5/28.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkModel.h"
#import "Constants.h"

typedef NS_ENUM(NSInteger, NetworkCode)
{
    NetworkSDKCodeOK = 1,
};

typedef void (^NetworkCallback)(UHTTPStatus *status, NetworkResponse *response);

@interface NetworkSDK : NSObject

// 校导网登录
+ (void)loginWith:(LoginRequest *)request callback:(NetworkCallback)callback;

// 获取用户信息
+ (void)userInfoWithCallback:(NetworkCallback)callback;

@end

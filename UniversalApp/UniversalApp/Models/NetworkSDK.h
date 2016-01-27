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

/*
 * Block style (Note references)
 */
// Login
+ (UHTTPOperation *)loginWith:(LoginRequest *)request callback:(NetworkCallback)callback;

// Get account info
+ (UHTTPOperation *)userInfoWithCallback:(NetworkCallback)callback;

@end

@protocol NetworkSDKDelegate <NSObject>

@required
- (void)networkSDKCallback:(int)identifier status:(UHTTPStatus *)status response:(NetworkResponse *)response;

@end

@interface NetworkSDKExtension : NSObject

/*
 * Delegate style (Recommend)
 */
// Login
+ (UHTTPOperation *)loginWith:(LoginRequest *)request
                     delegate:(__weak id<NetworkSDKDelegate>)delegate
                   identifier:(int)identifier;

// Get account info
+ (UHTTPOperation *)userInfoWithDelegate:(__weak id<NetworkSDKDelegate>)delegate
                              identifier:(int)identifier;

@end

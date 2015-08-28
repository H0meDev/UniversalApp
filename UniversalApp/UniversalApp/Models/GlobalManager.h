//
//  GlobalManager.h
//  UniversalApp
//
//  Created by Think on 15/8/4.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UserInfo.h"
#import "LocalNotification.h"
#import "KeyValueObserver.h"
#import "SkinManager.h"

@interface GlobalManager : NSObject

singletonInterface(GlobalManager);

// Singleton
+ (GlobalManager *)manager;

// Token from user login
@property (nonatomic, strong) NSString *token;

// User information
@property (nonatomic, strong, readonly) UserInfo *userInfo;

// Local notification
@property (nonatomic, strong, readonly) LocalNotification *localNotification;

// Key value observer
@property (nonatomic, strong, readonly) KeyValueObserver *keyValueObserver;

// For skin resource
@property (nonatomic, strong, readonly) SkinManager *skinManager;

@end

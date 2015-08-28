//
//  GlobalManager.m
//  UniversalApp
//
//  Created by Think on 15/8/4.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "GlobalManager.h"

@implementation GlobalManager

@synthesize userInfo = _userInfo;
@synthesize localNotification = _localNotification;
@synthesize keyValueObserver = _keyValueObserver;
@synthesize skinManager = _skinManager;

singletonImplementation(GlobalManager);

+ (GlobalManager *)manager
{
    return [GlobalManager sharedGlobalManager];
}

- (UserInfo *)userInfo
{
    if (_userInfo) {
        return _userInfo;
    }
    
    _userInfo = [UserInfo model];
    
    return _userInfo;
}

- (LocalNotification *)localNotification
{
    if (_localNotification) {
        return _localNotification;
    }
    
    _localNotification = [[LocalNotification alloc]init];
    
    return _localNotification;
}

- (KeyValueObserver *)keyValueObserver
{
    if (_keyValueObserver) {
        return _keyValueObserver;
    }
    
    _keyValueObserver = [[KeyValueObserver alloc]init];
    
    return _keyValueObserver;
}

- (SkinManager *)skinManager
{
    if (_skinManager) {
        return _skinManager;
    }
    
    SkinManager *skinManager = [[SkinManager alloc]init];
    _skinManager = skinManager;
    
    return _skinManager;
}

@end

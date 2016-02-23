//
//  UserInfo.h
//  UniversalApp
//
//  Created by Think on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "BaseModel.h"
#import "NetworkModel.h"

/*
 * User information model
 */

@interface UserInfo : BaseModel

singletonInterfaceWith(UserInfo, info);

@property (nonatomic, strong) UserInfoResponseData *info;
@property (nonatomic, strong) LoginResponseData *login;

@end

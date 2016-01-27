//
//  NetworkModel.h
//  UniversalApp
//
//  Created by Think on 15/5/23.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "BaseModel.h"

@interface NetworkRequest : BaseModel

@end

@interface NetworkResponse : BaseModel

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) id data;

@end

@interface NetworkResponseData : BaseModel

@end

@interface LoginRequest : NetworkRequest

@property (nonatomic, strong) NSString *client_key;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, assign) NSInteger platform;

@end

@interface LoginResponseData : NetworkResponseData

@property (nonatomic, assign) NSInteger id_;
@property (nonatomic, assign) NSInteger jti;
@property (nonatomic, strong) NSString *iss;
@property (nonatomic, strong) NSString *aud;
@property (nonatomic, strong) NSString *mid;
@property (nonatomic, assign) NSInteger exp;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, strong) NSString *token_type;
@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSString *scope;
@property (nonatomic, assign) NSInteger platform;

@end

@interface UserInfoRequest : NetworkRequest

@property (nonatomic, strong) NSString *_fields;
@property (nonatomic, strong) NSString *mid;

@end

@interface UserInfoResponseData : NetworkResponseData

@end
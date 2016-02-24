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

@interface RongToken : UModel

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *token;

@end

@interface UserInfoResponseData : NetworkResponseData

@property (nonatomic, strong) LoginResponseData *data;
@property (nonatomic, assign) NSInteger birthday;
@property (nonatomic, assign) NSInteger city;
@property (nonatomic, strong) NSString *city_name;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *evaluation;
@property (nonatomic, strong) NSString *experience;
@property (nonatomic, assign) NSInteger grade;
@property (nonatomic, strong) NSString *grade_name;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, assign) NSInteger identity;
@property (nonatomic, strong) NSString *job;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *major;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *practice;
@property (nonatomic, assign) NSInteger province;
@property (nonatomic, strong) NSString *province_name;
@property (nonatomic, strong) NSString *qq;
@property (nonatomic, strong) NSString *resume_url;
@property (nonatomic, assign) NSInteger school;
@property (nonatomic, strong) NSString *school_name;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, strong) NSString *sign;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *weixin;
@property (nonatomic, strong) RongToken *rong_token;

@end

@interface UserInfoTable : UModel

@property (nonatomic, strong) NSArray *excludeProperties_;
@property (nonatomic, assign) NSInteger index_value;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) CGFloat rate;
@property (nonatomic, strong) NSDictionary *dict;

@end
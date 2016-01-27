//
//  NetworkModel.m
//  UniversalApp
//
//  Created by Think on 15/5/23.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "NetworkModel.h"

@implementation NetworkRequest

@end

@implementation NetworkResponse

@end

@implementation NetworkResponseData

@end

@implementation LoginRequest

- (id)init
{
    self = [super init];
    if (self) {
        _platform = 2;
        _client_key = @"241eee72f987526954281241bbeb7c39";
    }
    
    return self;
}

- (void)setPassword:(NSString *)password
{
    _password = [password MD5String];
}

@end

@implementation LoginResponseData

@end

@implementation UserInfoRequest

@end

@implementation UserInfoResponseData

@end

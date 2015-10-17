//
//  NetworkModel.h
//  UniversalApp
//
//  Created by Think on 15/5/23.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "BaseModel.h"

@interface NetworkModel : BaseModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *content_fields;

@end

@interface NetworkModelContentFieldsItem : BaseModel

@property (nonatomic, strong) NSString *time;

@end
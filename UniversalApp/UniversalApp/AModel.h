//
//  AModel.h
//  UniversalApp
//
//  Created by Think on 15/8/20.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "BaseModel.h"
#import "BModel.h"

@interface AModel : BaseModel

@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) BModel *info;

@end

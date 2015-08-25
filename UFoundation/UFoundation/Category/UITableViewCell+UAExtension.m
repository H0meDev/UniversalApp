//
//  UITableViewCell+UAExtension.m
//  UFoundation
//
//  Created by Think on 15/8/11.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UITableViewCell+UAExtension.h"

@implementation UITableViewCell (UAExtension)

+ (instancetype)cell
{
    return [self cellWithStyle:UITableViewCellStyleDefault];
}

+ (instancetype)cellWithStyle:(UITableViewCellStyle)style
{
    return [self cellWithStyle:style identifier:NSStringFromClass(self.class)];
}

+ (instancetype)cellWithStyle:(UITableViewCellStyle)style identifier:(NSString *)identifier
{
    @autoreleasepool
    {
        return [[self alloc]initWithStyle:style reuseIdentifier:identifier];
    }
}

@end

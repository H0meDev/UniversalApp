//
//  UITableViewCell+UAExtension.m
//  UFoundation
//
//  Created by Think on 15/8/11.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UITableViewCell+UAExtension.h"

@implementation UITableViewCell (UAExtension)

+ (id)cell
{
    return [self cellWithStyle:UITableViewCellStyleDefault];
}

+ (id)cellWithStyle:(UITableViewCellStyle)style
{
    return [self cellWithStyle:style identifier:NSStringFromClass(self.class)];
}

+ (id)cellWithStyle:(UITableViewCellStyle)style identifier:(NSString *)identifier
{
    @autoreleasepool
    {
        return [[self alloc]initWithStyle:style reuseIdentifier:identifier];
    }
}

@end

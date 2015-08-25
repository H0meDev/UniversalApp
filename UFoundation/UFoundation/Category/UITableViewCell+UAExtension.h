//
//  UITableViewCell+UAExtension.h
//  UFoundation
//
//  Created by Think on 15/8/11.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (UAExtension)

// Default style
+ (instancetype)cell;
+ (instancetype)cellWithStyle:(UITableViewCellStyle)style;
+ (instancetype)cellWithStyle:(UITableViewCellStyle)style identifier:(NSString *)identifier;

@end

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
+ (id)cell;
+ (id)cellWithStyle:(UITableViewCellStyle)style;
+ (id)cellWithStyle:(UITableViewCellStyle)style identifier:(NSString *)identifier;

@end

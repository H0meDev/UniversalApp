//
//  BaseTableViewCell.h
//  UniversalApp
//
//  Created by Think on 15/8/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UTableViewCell

// Override setContentHeight: to resize
@property (nonatomic, assign) CGFloat contentHeight;

@end

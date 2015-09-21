//
//  BaseTableViewCell.h
//  UFoundation
//
//  Created by Think on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UTableViewCell : UITableViewCell

@property (nonatomic, assign) id cellData;

- (id)initWithReuseIdentifier:(NSString *)identifier;
+ (id)cellWithReuseIdentifier:(NSString *)identifier;

@end

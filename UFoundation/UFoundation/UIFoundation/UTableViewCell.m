//
//  BaseTableViewCell.m
//  UFoundation
//
//  Created by Think on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UTableViewCell.h"

@implementation UTableViewCell

+ (id)cellWithReuseIdentifier:(NSString *)identifier
{
    @autoreleasepool
    {
        return [[self.class alloc]initWithReuseIdentifier:identifier];
    }
}

- (id)initWithReuseIdentifier:identifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (self) {
        //
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    // Extra initialization
    self.clipsToBounds = YES;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

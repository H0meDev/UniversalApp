//
//  UScrollView.m
//  UFoundation
//
//  Created by Think on 15/8/11.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UScrollView.h"

@implementation UScrollView

- (void)dealloc
{
    [self removeHeaderView];
    [self removeFooterView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

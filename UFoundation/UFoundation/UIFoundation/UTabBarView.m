//
//  UTabBarView.m
//  UFoundation
//
//  Created by Think on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UTabBarView.h"
#import "UDefines.h"

@interface UTabBarView ()

@property (nonatomic, retain) UIImageView *topLineView;

@end

@implementation UTabBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialize
        self.backgroundColor = rgbColor(249., 249., 249.);
        
        [self topLineView];
    }
    
    return self;
}

- (UIImageView *)topLineView
{
    if (_topLineView) {
        return _topLineView;
    }
    
    UIImageView *topLineView = [[UIImageView alloc]init];
    topLineView.frame = rectMake(0, 0, screenWidth(), tabBLineH());
    topLineView.alpha = 0.3;
    topLineView.backgroundColor = sysDarkGrayColor();
    [self addSubview:topLineView];
    _topLineView = topLineView;
    
    return _topLineView;
}

@end

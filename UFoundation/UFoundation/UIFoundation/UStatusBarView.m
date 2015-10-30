//
//  UStatusBarView.m
//  UFoundation
//
//  Created by Think on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UStatusBarView.h"
#import "UDefines.h"
#import "UImageView.h"
#import "UIColor+UAExtension.h"
#import "UIView+UAExtension.h"
#import "NSObject+UAExtension.h"

@interface UStatusBarView ()
{
    UIColor *_backgroundColor;
    BOOL _needsStretch;
}

@property (nonatomic, retain) UIImageView *contentView;
@property (nonatomic, weak) UImageView *backgroundView;

@end

@implementation UStatusBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialize
        self.userInteractionEnabled = YES;
        
        if (systemVersionFloat() < 7.0) {
            self.backgroundColor = sysBlackColor();
        } else {
            self.backgroundColor = rgbColor(249., 249., 249.);
        }
        
        _needsStretch = NO;
        
        [self contentView];
    }
    
    return self;
}

- (void)dealloc
{
    //
}

#pragma mark - Properites

- (UIImageView *)contentView
{
    if (_contentView) {
        return _contentView;
    }
    
    UIImageView *contentView = [[UIImageView alloc]init];
    contentView.frame = rectMake(0, 0, screenWidth(), statusHeight());
    contentView.userInteractionEnabled = YES;
    contentView.backgroundColor = sysClearColor();
    [self addSubview:contentView];
    _contentView = contentView;
    
    return _contentView;
}

- (CGFloat)alpha
{
    return _contentView.alpha;
}

- (void)setAlpha:(CGFloat)alpha
{
    _contentView.alpha = alpha;
}

- (BOOL)hidden
{
    return _contentView.hidden;
}

- (void)setHidden:(BOOL)hidden
{
    _contentView.hidden = hidden;
}

- (UIColor *)backgroundColor
{
    return _backgroundColor;
}

- (void)setBackgroundColor:(UIColor *)color
{
    _backgroundColor = color;
    
    if (self.backgroundView) {
        self.backgroundView.backgroundColor = color;
    }
}

- (void)setBackgroundView:(UImageView *)backgroundView
{
    _backgroundView = backgroundView;
    _backgroundView.backgroundColor = _backgroundColor;
}

- (void)stretch
{
    [self setStretch:NO animated:NO];
}

- (void)collapse
{
    [self setStretch:YES animated:NO];
}

- (void)stretchWithAnimation
{
    [self setStretch:NO animated:YES];
}

- (void)collapseWithAnimation
{
    [self setStretch:YES animated:YES];
}

- (void)setStretch:(BOOL)stretch animated:(BOOL)animated
{
    if (_needsStretch == stretch) {
        return;
    }
    _needsStretch = stretch;
    
    CGFloat originY = stretch?- statusHeight():0;
    if (self.originY != originY) {
        if (!animated) {
            self.originY = originY;
        } else {
            [UIView beginAnimations:@"UStatusBarViewStretchAnimation" context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:animationDuration()];
            
            self.originY = originY;
            
            [UIView commitAnimations];
        }
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //
}

@end

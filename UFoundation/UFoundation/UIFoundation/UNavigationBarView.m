//
//  UNavigationBarView.m
//  UFoundation
//
//  Created by Think on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UNavigationBarView.h"
#import "UDefines.h"
#import "UIView+UAExtension.h"
#import "NSObject+UAExtension.h"

@interface UNavigationContentView : UIImageView

@property (nonatomic, retain) ULabel *titleLabel;
@property (nonatomic, retain) UIImageView *bottomLineView;

@end

@implementation UNavigationContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initliaze
        [self titleLabel];
        [self bottomLineView];
    }
    
    return self;
}

- (ULabel *)titleLabel
{
    if (_titleLabel) {
        return _titleLabel;
    }
    
    CGFloat originX = screenWidth() * 0.2;
    CGFloat width = screenWidth() - originX * 2;
    ULabel *titleLabel = [[ULabel alloc]init];
    titleLabel.frame = rectMake(originX, 0, width, naviHeight());
    titleLabel.font = naviTitleFont();
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = sysBlackColor();
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    return _titleLabel;
}

- (UIImageView *)bottomLineView
{
    if (_bottomLineView) {
        return _bottomLineView;
    }
    
    UIImageView *bottomLineView = [[UIImageView alloc]init];
    bottomLineView.frame = rectMake(0, naviHeight() - naviBLineH(), screenWidth(), naviBLineH());
    bottomLineView.backgroundColor = sysLightGrayColor();
    [self addSubview:bottomLineView];
    _bottomLineView = bottomLineView;
    
    return _bottomLineView;
}

@end

@interface UNavigationBarView ()
{
    BOOL _needsStretch;
    BOOL _bottomLineHidden;
}

@property (nonatomic, retain) UNavigationContentView *contentView;

@end

@implementation UNavigationBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = sysClearColor();
        
        _needsStretch = NO;
        
        [self contentView];
    }
    
    return self;
}

- (void)dealloc
{
    //
}

#pragma mark - Properties

- (UNavigationContentView *)contentView
{
    if (_contentView) {
        return _contentView;
    }
    
    UNavigationContentView *contentView = [[UNavigationContentView alloc]init];
    contentView.frame = rectMake(0, 0, screenWidth(), naviHeight());
    contentView.userInteractionEnabled = YES;
    contentView.backgroundColor = sysWhiteColor();
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
    return _contentView.backgroundColor;
}

- (void)setBackgroundColor:(UIColor *)color
{
    _contentView.backgroundColor = color;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    _contentView.titleLabel.text = title;
}

- (void)setTitleColor:(UIColor *)color
{
    _titleColor = color;
    
    _contentView.titleLabel.textColor = color;
}

- (void)setBottomLineColor:(UIColor *)color
{
    _bottomLineColor = color;
    
    _contentView.bottomLineView.backgroundColor = color;
}

- (void)setBackgroundImage:(UIImage *)image
{
    _backgroundImage = image;
    
    _contentView.image = image;
}

- (void)setTitleFont:(UIFont *)font
{
    _titleFont = font;
    
    _contentView.titleLabel.font = font;
}

- (void)setBottomLineHidden:(BOOL)hidden
{
    _bottomLineHidden = hidden;
    
    _contentView.bottomLineView.hidden = hidden;
}

- (void)setLeftButton:(UIButton *)leftButton
{
    if (_leftButton) {
        [_leftButton removeFromSuperview];
    }
    _leftButton = leftButton;
    
    [_contentView addSubview:leftButton];
}

- (void)setRightButton:(UIButton *)rightButton
{
    if (_rightButton) {
        [_rightButton removeFromSuperview];
    }
    _rightButton = rightButton;
    
    [_contentView addSubview:rightButton];
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
    
    CGFloat originY = stretch?- naviHeight():statusHeight();
    if (self.originY != originY) {
        if (!animated) {
            self.originY = originY;
        } else {
            [UIView beginAnimations:@"UNavigationBarViewStretchAnimation" context:nil];
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

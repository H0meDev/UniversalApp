//
//  UNavigationBarView.m
//  UFoundation
//
//  Created by Think on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UNavigationBarView.h"
#import "UDefines.h"
#import "UView.h"
#import "UImageView.h"
#import "UIView+UAExtension.h"
#import "NSObject+UAExtension.h"

@interface UNavigationContentView : UIImageView

@property (nonatomic, retain) ULabel *titleLabel;
@property (nonatomic, retain) UImageView *bottomLineView;

@end

@implementation UNavigationContentView

- (id)initWithFrame:(CGRect)frame
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
    
    CGFloat width = screenWidth() - screenWidth() * 0.4;
    ULabel *titleLabel = [[ULabel alloc]init];
    titleLabel.frame = rectMake(0, 0, width, naviHeight());
    titleLabel.center = pointMake(screenWidth() / 2., naviHeight() / 2.);
    titleLabel.font = systemFont(17);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = sysBlackColor();
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    return _titleLabel;
}

- (UImageView *)bottomLineView
{
    if (_bottomLineView) {
        return _bottomLineView;
    }
    
    UImageView *bottomLineView = [[UImageView alloc]init];
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
    UIColor *_backgroundColor;
}

@property (nonatomic, retain) UNavigationContentView *contentView;

@end

@implementation UNavigationBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initalize
        self.userInteractionEnabled = YES;
        super.backgroundColor = sysClearColor();
        self.backgroundColor = sysClearColor();
        
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
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    _contentView.titleLabel.text = title;
    [_contentView.titleLabel resizeToFitWidth];
    _contentView.titleLabel.centerX = screenWidth() / 2.;
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

- (void)setOriginX:(CGFloat)originX
{
    CGFloat centerX = (screenWidth() - _contentView.titleLabel.sizeWidth) / 2.0;
    CGFloat progress = (screenWidth() - fabs(originX)) / screenWidth();
    CGFloat titleAlpha = powf(progress, 2.0);
    CGFloat buttonAlpha = powf(titleAlpha, 2.0);
    
    if (originX >= 0) {
        _contentView.titleLabel.alpha = titleAlpha;
        _contentView.titleLabel.originX = centerX + originX * 0.5;
    } else {
        CGFloat roriginX = originX + screenWidth();
        _contentView.titleLabel.alpha = buttonAlpha;
        if (buttonAlpha >= 0.01) {
            _contentView.titleLabel.originX = 24 + roriginX * 0.35;
        } else {
            _contentView.titleLabel.originX = centerX + originX * 0.5;
        }
    }
    
    if (_leftButton) {
        _leftButton.enabled = (originX > 0)?NO:YES;
        ULabel *titleLabel = [_leftButton valueForKey:@"titleLabel"];
        titleLabel.alpha = buttonAlpha;
        titleLabel.originX = 24 + originX * 0.35;
        
        UImageView *imageView = [_leftButton valueForKey:@"imageView"];
        imageView.alpha = (originX >= 0)?buttonAlpha:1;
    }
    
    if (_rightButton) {
        UILabel *titleLabel = [_rightButton valueForKey:@"titleLabel"];
        titleLabel.alpha = buttonAlpha;
    }
}

- (void)setBottomLineHidden:(BOOL)hidden
{
    _bottomLineHidden = hidden;
    
    _contentView.bottomLineView.hidden = hidden;
}

- (void)setLeftButton:(UNavigationBarButton *)leftButton
{
    if (_leftButton) {
        [_leftButton removeFromSuperview];
    }
    _leftButton = leftButton;
    
    [_contentView addSubview:leftButton];
}

- (void)setRightButton:(UNavigationBarButton *)rightButton
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

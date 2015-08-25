//
//  UBarButton.m
//  UFoundation
//
//  Created by Think on 15/8/23.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UBarButton.h"
#import "UDefines.h"
#import "ULabel.h"
#import "UImageView.h"
#import "UIView+UAExtension.h"

@interface UBarButton ()
{
    UBarButtonType _type;
    UIColor *_titleColor;
}

@property (nonatomic, strong) ULabel *titleLabel;
@property (nonatomic, strong) UImageView *imageView;
@property (nonatomic, strong) UImageView *backgroundView;

@end

@implementation UBarButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Initalize
        super.backgroundColor = sysClearColor();
        _type = UBarButtonTypeImageLeftTitleRight;
        _titleColor = sysBlackColor();
    }
    
    return self;
}

- (instancetype)initWith:(UBarButtonType)type
{
    self = [super init];
    if (self) {
        // Initalize
        super.backgroundColor = sysClearColor();
        _type = type;
        _titleColor = sysBlackColor();
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.backgroundView.frame = rectMake(0, 0, frame.size.width, frame.size.height);
}

- (UIColor *)backgroundColor
{
    return self.backgroundView.backgroundColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.backgroundView.backgroundColor = backgroundColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_titleLabel && _imageView) {
        //
    } else if (_titleLabel) {
        _titleLabel.frame = rectMake(0, 0, self.sizeWidth, self.sizeHeight);
    } else if (_imageView) {
        _imageView.frame = rectMake(0, 0, self.sizeWidth, self.sizeHeight);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Properties

- (ULabel *)titleLabel
{
    if (_titleLabel) {
        return _titleLabel;
    }
    
    ULabel *titleLabel = [[ULabel alloc]init];
    titleLabel.backgroundColor = sysClearColor();
    titleLabel.textColor = sysBlackColor();
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.backgroundView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    return _titleLabel;
}

- (UImageView *)imageView
{
    if (_imageView) {
        return _imageView;
    }
    
    return _imageView;
}

- (UImageView *)backgroundView
{
    if (_backgroundView) {
        return _backgroundView;
    }
    
    UImageView *backgroundView = [[UImageView alloc]init];
    backgroundView.backgroundColor = sysClearColor();
    [self addSubview:backgroundView];
    _backgroundView = backgroundView;
    
    return _backgroundView;
}

#pragma mark - 

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.titleLabel.textColor = [_titleColor colorWithAlphaComponent:0.7];
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.titleLabel.textColor = [_titleColor colorWithAlphaComponent:0.7];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.titleLabel.textColor = _titleColor;
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    self.titleLabel.textColor = _titleColor;
}

#pragma mark - Methods

+ (UBarButton *)button
{
    __autoreleasing UBarButton *button = [[UBarButton alloc]init];
    
    return button;
}

+ (UBarButton *)buttonWith:(UBarButtonType)type
{
    __autoreleasing UBarButton *button = [[UBarButton alloc]initWith:type];
    
    return button;
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)setTitleColor:(UIColor *)color
{
    _titleColor = color;
    
    self.titleLabel.textColor = color;
}

// Add target
- (void)addTarget:(id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)addTouchDownTarget:(id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchDown];
}

- (void)removeTarget:(id)target action:(SEL)action
{
    [self removeTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)removeTouchDownTarget:(id)target action:(SEL)action
{
    [self removeTarget:target action:action forControlEvents:UIControlEventTouchDown];
}

@end

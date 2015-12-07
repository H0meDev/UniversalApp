//
//  UIButton+UAExtension.m
//  UFoundation
//
//  Created by Think on 15/7/2.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UIButton+UAExtension.h"
#import "UIView+UAExtension.h"
#import "UIColor+UAExtension.h"

@implementation UIButton (UAExtension)

+ (id)button
{
    @autoreleasepool
    {
        UIButton *button = [self buttonWithType:UIButtonTypeCustom];
        [button setHTitleColor:[UIColor grayColor]];
        
        return button;
    }
}

- (void)addTarget:(id)target action:(SEL)action
{
    if (![target respondsToSelector:action]) {
        return;
    }
    
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)addTouchDownTarget:(id)target action:(SEL)action
{
    if (![target respondsToSelector:action]) {
        return;
    }
    
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

- (void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setSTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateSelected];
}

- (void)setHTitle:(NSString *)title;
{
    [self setTitle:title forState:UIControlStateHighlighted];
}

- (void)setDTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateDisabled];
}

- (void)setTitleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:[color setAlphaValue:0.3] forState:UIControlStateHighlighted];
}

- (void)setSTitleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateSelected];
}

- (void)setHTitleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateHighlighted];
}

- (void)setDTitleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateDisabled];
}

- (void)setTitleFont:(UIFont *)font
{
    self.titleLabel.font = font;
}

- (void)setTitleNumberofLines:(NSUInteger)number
{
    self.titleLabel.numberOfLines = number;
}

- (void)setImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
}

- (void)setSImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateSelected];
}

- (void)setHImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateHighlighted];
}

- (void)setDImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateDisabled];
}

- (void)setBackgroundImage:(UIImage *)image
{
    [self setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)setSBackgroundImage:(UIImage *)image
{
    [self setBackgroundImage:image forState:UIControlStateSelected];
}

- (void)setHBackgroundImage:(UIImage *)image
{
    [self setBackgroundImage:image forState:UIControlStateHighlighted];
}

- (void)setDBackgroundImage:(UIImage *)image
{
    [self setBackgroundImage:image forState:UIControlStateDisabled];
}

@end

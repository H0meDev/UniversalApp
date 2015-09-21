//
//  UBarButton.h
//  UFoundation
//
//  Created by Think on 15/8/23.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UBarButton : UIControl

+ (id)button;

// Custom inner frame for imageView & titleLabel
@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, assign) CGRect titleFrame;

// Custom text alignment, default is NSTextAlignmentCenter
@property (nonatomic, assign) NSTextAlignment textAlignment;

// Title for UIControlState
- (void)setTitle:(NSString *)title;
- (void)setHTitle:(NSString *)title;
- (void)setSTitle:(NSString *)title;
- (void)setDTitle:(NSString *)title;

// Color for UIControlState
- (void)setTitleColor:(UIColor *)color;
- (void)setHTitleColor:(UIColor *)color;
- (void)setSTitleColor:(UIColor *)color;
- (void)setDTitleColor:(UIColor *)color;

// Font for UIControlState
- (void)setTitleFont:(UIFont *)font;
- (void)setHTitleFont:(UIFont *)font;
- (void)setSTitleFont:(UIFont *)font;
- (void)setDTitleFont:(UIFont *)font;

// Image for UIControlState
- (void)setImage:(UIImage *)image;
- (void)setHImage:(UIImage *)image;
- (void)setSImage:(UIImage *)image;
- (void)setDImage:(UIImage *)image;

// Background image for UIControlState
- (void)setBackgroundImage:(UIImage *)image;
- (void)setHBackgroundImage:(UIImage *)image;
- (void)setSBackgroundImage:(UIImage *)image;
- (void)setDBackgroundImage:(UIImage *)image;

// Alpha for UIControlState
- (void)setAlpha:(CGFloat)alpha;
- (void)setHAlpha:(CGFloat)alpha;
- (void)setSAlpha:(CGFloat)alpha;
- (void)setDAlpha:(CGFloat)alpha;

// Background alpha
- (void)setBackgroundAlpha:(CGFloat)alpha;
- (void)setHBackgroundAlpha:(CGFloat)alpha;
- (void)setSBackgroundAlpha:(CGFloat)alpha;
- (void)setDBackgroundAlpha:(CGFloat)alpha;

// Add action
- (void)addTarget:(id)target action:(SEL)action;
- (void)addTouchDownTarget:(id)target action:(SEL)action;

// Remove action
- (void)removeTarget:(id)target action:(SEL)action;
- (void)removeTouchDownTarget:(id)target action:(SEL)action;

@end

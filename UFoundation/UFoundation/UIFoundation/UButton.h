//
//  UButton.h
//  UFoundation
//
//  Created by Think on 15/8/23.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UDefines.h"
#import "ULabel.h"
#import "UImageView.h"
#import "UIView+UAExtension.h"
#import "UILabel+UAExtension.h"

@class UButton;
@protocol UButtonDelegate <NSObject>

@optional
- (void)buttonBeginTracking:(UButton *)button;
- (void)buttonContinueTracking:(UButton *)button;
- (void)buttonEndTracking:(UButton *)button;
- (void)buttonCancelTracking:(UButton *)button;

@end

@interface UButton : UIControl

+ (id)button;

// Custom inner frame for imageView & titleLabel
@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, assign) CGRect titleFrame;
@property (nonatomic, assign) BOOL synchronous;             // Default NO
@property (nonatomic, assign) BOOL needsAutoResize;         // Default NO
@property (nonatomic, assign) BOOL showMaskWhenHighlighted; // Default YES

// Custom text alignment, default is NSTextAlignmentCenter
@property (nonatomic, assign) NSTextAlignment textAlignment;
// Background mask color when highlighted, set showMaskWhenHighlighted NO to close
@property (nonatomic, copy) UIColor *backgroundMaskHColor;
// Button event callback
@property (nonatomic, weak) id<UButtonDelegate> delegate;

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

// Border
- (void)setBorderWidth:(CGFloat)width;
- (void)setCornerRadius:(CGFloat)radius;

// Border color
- (void)setBorderColor:(UIColor *)color;
- (void)setHBorderColor:(UIColor *)color;
- (void)setSBorderColor:(UIColor *)color;
- (void)setDBorderColor:(UIColor *)color;

// Add action
- (void)setTarget:(id)target action:(SEL)action;
- (void)setTouchDownTarget:(id)target action:(SEL)action;
- (void)setTarget:(id)target action:(SEL)action forEvent:(UIControlEvents)event;

// Remove action
- (void)removeTargetAction;
- (void)removeTouchDownTargetAction;
- (void)removeTargetActionWithEvent:(UIControlEvents)event;

@end

//
//  UIButton+UAExtension.h
//  UFoundation
//
//  Created by Think on 15/7/2.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (UAExtension)

/*
 * Custom button
 */
+ (instancetype)customButton;

/*
 * Add Target and action
 * countOfAction will increase
 */
- (void)addTarget:(id)target action:(SEL)action;
- (void)addTouchDownTarget:(id)target action:(SEL)action;

/*
 * Remove Target and action
 * countOfAction will decrease
 */
- (void)removeTarget:(id)target action:(SEL)action;
- (void)removeTouchDownTarget:(id)target action:(SEL)action;

/*
 * Set title
 */
- (void)setTitle:(NSString *)title;
- (void)setSTitle:(NSString *)title;
- (void)setHTitle:(NSString *)title;
- (void)setDTitle:(NSString *)title;

/*
 * Set title color
 */
- (void)setTitleColor:(UIColor *)color;
- (void)setSTitleColor:(UIColor *)color;
- (void)setHTitleColor:(UIColor *)color;
- (void)setDTitleColor:(UIColor *)color;

/*
 * Set title font
 */
- (void)setTitleFont:(UIFont *)font;

/*
 * Set number of line
 */
- (void)setTitleNumberofLines:(NSUInteger)number;

/*
 * Set Image
 */
- (void)setImage:(UIImage *)image;
- (void)setSImage:(UIImage *)image;
- (void)setHImage:(UIImage *)image;
- (void)setDImage:(UIImage *)image;

/*
 * Set Bacground Image
 */
- (void)setBackgroundImage:(UIImage *)image;
- (void)setSBackgroundImage:(UIImage *)image;
- (void)setHBackgroundImage:(UIImage *)image;
- (void)setDBackgroundImage:(UIImage *)image;

@end

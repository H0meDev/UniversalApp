//
//  UIColor+UAExtension.h
//  UFoundation
//
//  Created by Think on 15/5/17.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (UAExtension)

// Hex color string to color
+ (UIColor *)colorWithHexString:(NSString *)color;

// Color gradual with progress from 0 -> 1.0
+ (UIColor *)colorGradualFrom:(UIColor *)startColor
                          to:(UIColor *)endColor
                    progress:(CGFloat)progress;

// Get current rgba value
- (CGFloat)redValue;
- (CGFloat)greenValue;
- (CGFloat)blueValue;
- (CGFloat)alphaValue;

// UIColor alpha reset
- (UIColor *)colorWithAlpha:(CGFloat)alpha;

// UIColor compare
- (BOOL)isEqualToColor:(UIColor *)color;

@end

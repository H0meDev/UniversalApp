//
//  UIImage+UAExtension.h
//  UFoundation
//
//  Created by Think on 15/8/11.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UAExtension)

// Create 8 x 8 image of color
+ (UIImage *)imageWithColor:(UIColor *)color;

// Blurry image, level is from 0.0 to 1.0
+ (UIImage *)blurryImage:(UIImage *)image withLevel:(CGFloat)level;

@end

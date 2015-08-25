//
//  UIImage+UAExtension.m
//  UFoundation
//
//  Created by Think on 15/8/11.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UIImage+UAExtension.h"

@implementation UIImage (UAExtension)

// Create 8 x 8 image of color
+ (UIImage *)imageWithColor:(UIColor *)color
{
    @autoreleasepool
    {
        CGRect rect = CGRectMake(0, 0, 8, 8);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
}

@end

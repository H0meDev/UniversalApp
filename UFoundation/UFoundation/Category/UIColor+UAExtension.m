//
//  UIColor+UAExtension.m
//  UFoundation
//
//  Created by Think on 15/5/17.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UIColor+UAExtension.h"
#import "NSString+UAExtension.h"

@implementation UIColor (UAExtension)

+ (UIColor *)colorWithHexString:(NSString *)color
{
    return [color colorValue];
}

+ (UIColor *)colorGradualFrom:(UIColor *)startColor
                          to:(UIColor *)endColor
                    progress:(CGFloat)progress
{
    CGFloat sr = startColor.redValue * 255;
    CGFloat sg = startColor.greenValue * 255;
    CGFloat sb = startColor.blueValue * 255;
    CGFloat sa = startColor.alphaValue;
    
    CGFloat er = endColor.redValue * 255;
    CGFloat eg = endColor.greenValue * 255;
    CGFloat eb = endColor.blueValue * 255;
    CGFloat ea = endColor.alphaValue;
    
    CGFloat tr = sr + (er - sr) * progress;
    CGFloat tg = sg + (eg - sg) * progress;
    CGFloat tb = sb + (eb - sb) * progress;
    CGFloat ta = sa + (ea - sa) * progress;
    
    return [UIColor colorWithRed:tr / 255. green:tg / 255. blue:tb / 255. alpha:ta];
}

- (CGFloat)redValue
{
    return CGColorGetComponents(self.CGColor)[0];
}

- (CGFloat)greenValue
{
    return CGColorGetComponents(self.CGColor)[1];
}

- (CGFloat)blueValue
{
    return CGColorGetComponents(self.CGColor)[2];
}

- (CGFloat)alphaValue
{
    return CGColorGetComponents(self.CGColor)[3];
}

- (BOOL)isEqualColor:(UIColor *)color
{
    if (color) {
        return CGColorEqualToColor(self.CGColor, color.CGColor);
    }
    
    return NO;
}

@end

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
    size_t count = CGColorGetNumberOfComponents(self.CGColor);
    if (count != 4) {
        return CGColorGetComponents(self.CGColor)[0];
    }
    
    CGFloat value = CGColorGetComponents(self.CGColor)[0];
    value = (value > 1.0)?1.0:value;
    value = (value < 0.0)?0.0:value;
    
    return value;
}

- (CGFloat)greenValue
{
    size_t count = CGColorGetNumberOfComponents(self.CGColor);
    if (count != 4) {
        return CGColorGetComponents(self.CGColor)[0];
    }
    
    CGFloat value = CGColorGetComponents(self.CGColor)[1];
    value = (value > 1.0)?1.0:value;
    value = (value < 0.0)?0.0:value;
    
    return value;
}

- (CGFloat)blueValue
{
    size_t count = CGColorGetNumberOfComponents(self.CGColor);
    if (count != 4) {
        return CGColorGetComponents(self.CGColor)[0];
    }
    
    CGFloat value = CGColorGetComponents(self.CGColor)[2];
    value = (value > 1.0)?1.0:value;
    value = (value < 0.0)?0.0:value;
    
    return value;
}

- (CGFloat)alphaValue
{
    return CGColorGetAlpha(self.CGColor);
}

- (UIColor *)setAlphaValue:(CGFloat)alpha
{
    return [self colorWithAlphaComponent:alpha];
}

- (BOOL)isEqualToColor:(UIColor *)color
{
    if (color) {
        return CGColorEqualToColor(self.CGColor, color.CGColor);
    }
    
    return NO;
}

@end

//
//  UNavigationBarButton.m
//  UFoundation
//
//  Created by Think on 15/8/23.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UNavigationBarButton.h"
#import "UIColor+UAExtension.h"

@interface UNavigationBarButton ()
{
    BOOL _needsConstraint;
}

@end

@implementation UNavigationBarButton

- (id)init
{
    self = [super init];
    if (self) {
        // Initialize
        self.needsAutoResize = YES;
        self.showMaskWhenHighlighted = NO;
        self.backgroundMaskHColor = nil;
    }
    
    return self;
}

- (void)setImageFrame:(CGRect)imageFrame
{
    [super setImageFrame:rectMake(0, 0, 24, naviHeight())];
    
    _needsConstraint = YES;
}

- (void)setTitleFrame:(CGRect)frame
{
    if (_needsConstraint) {
        [super setTitleFrame:rectMake(24, 0, frame.size.width, naviHeight())];
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

#pragma mark - Method

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
}

- (void)setHTitle:(NSString *)title
{
    [super setHTitle:title];
}

- (void)setSTitle:(NSString *)title
{
    [super setSTitle:title];
}

- (void)setDTitle:(NSString *)title
{
    [super setDTitle:title];
}

- (void)setBackImageWithColor:(UIColor *)color
{
    [self setImage:[self imageWith:color]];
}

- (void)setHBackImageWithColor:(UIColor *)color
{
    [self setHImage:[self imageWith:color]];
}

- (void)setSBackImageWithColor:(UIColor *)color
{
    [self setSImage:[self imageWith:color]];
}

- (void)setDBackImageWithColor:(UIColor *)color
{
    [self setDImage:[self imageWith:color]];
}

- (UIImage *)imageWith:(UIColor *)color
{
    @autoreleasepool
    {
        // Color values
        CGFloat redValue = color.redValue;
        CGFloat greenValue = color.greenValue;
        CGFloat blueValue = color.blueValue;
        CGFloat alphaValue = color.alphaValue;
        
        CGRect rect = rectMake(0, 0, 48, 88);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // Draw arrow
        CGContextSetRGBStrokeColor(context, redValue, greenValue, blueValue, alphaValue);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, 16, 46);
        CGContextAddLineToPoint(context, 36, 24);
        CGContextMoveToPoint(context, 16, 42);
        CGContextAddLineToPoint(context, 36, 64);
        CGContextSetLineWidth(context, 6);
        CGContextSetLineJoin(context, kCGLineJoinBevel);
        CGContextStrokePath(context);
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
}

@end

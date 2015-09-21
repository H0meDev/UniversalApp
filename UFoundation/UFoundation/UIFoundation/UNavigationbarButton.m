//
//  UNavigationBarButton.m
//  UFoundation
//
//  Created by Think on 15/8/23.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UNavigationBarButton.h"
#import "UDefines.h"
#import "UIColor+UAExtension.h"

@interface UNavigationBarButton ()

@property (nonatomic, retain) UIView *filterView;

@end

@implementation UNavigationBarButton

- (id)init
{
    self = [super init];
    if (self) {
        // Initialize
        [self filterView];
        [self setImageFrame:rectMake(0, 0, 24, naviHeight())];
    }
    
    return self;
}

- (void)setTitleFrame:(CGRect)frame
{
    [super setTitleFrame:rectMake(24, 0, frame.size.width, naviHeight())];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Properties

- (UIView *)filterView
{
    if (_filterView) {
        return _filterView;
    }
    
    return _filterView;
}

#pragma mark - Method

- (void)setBackImage:(UIColor *)color
{
    [self setImage:[self imageWith:color]];
    [self setImageFrame:rectMake(0, 0, 24, naviHeight())];
}

- (void)setHBackImage:(UIColor *)color
{
    [self setHImage:[self imageWith:color]];
    [self setImageFrame:rectMake(0, 0, 24, naviHeight())];
}

- (void)setSBackImage:(UIColor *)color
{
    [self setSImage:[self imageWith:color]];
    [self setImageFrame:rectMake(0, 0, 24, naviHeight())];
}

- (void)setDBackImage:(UIColor *)color
{
    [self setDImage:[self imageWith:color]];
    [self setImageFrame:rectMake(0, 0, 24, naviHeight())];
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
        CGContextMoveToPoint(context, 8, 46);
        CGContextAddLineToPoint(context, 28, 24);
        CGContextMoveToPoint(context, 8, 42);
        CGContextAddLineToPoint(context, 28, 64);
        CGContextSetLineWidth(context, 6);
        CGContextSetLineJoin(context, kCGLineJoinBevel);
        CGContextStrokePath(context);
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
}

@end

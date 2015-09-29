//
//  UIndicatorView.m
//  UFoundation
//
//  Created by Think on 15/9/23.
//  Copyright © 2015年 think. All rights reserved.
//

#import "UIndicatorView.h"
#import "UTimerBooster.h"

@interface UIndicatorView ()
{
    UIndicatorStyle _style;
    int _stageValue;
}

@end

@implementation UIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initailize
        super.backgroundColor = sysClearColor();
        
        _stageValue = 0;
        _indicatorWidth = 2.0;
        _style = UIndicatorStylePetal;
        _indicatorColor = sysBlackColor();
    }
    
    return self;
}

- (id)initWithStyle:(UIndicatorStyle)style
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _style = style;
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    CGFloat width = frame.size.width;
    width = (width > frame.size.height)?frame.size.height:width;
    
    [super setFrame:rectMake(frame.origin.x, frame.origin.y, width, width)];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    //
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, _indicatorWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    for (int i = 0 ; i < 12; i ++) {
        CGPoint point = [self pointWith:i + _stageValue start:YES];
        CGContextMoveToPoint(context, point.x, point.y);
        point = [self pointWith:i + _stageValue start:NO];
        CGContextAddLineToPoint(context, point.x, point.y);
        
        UIColor *lineColor = [_indicatorColor colorWithAlphaComponent:i / 12.];
        CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
        CGContextStrokePath(context);
    }
}

- (CGPoint)pointWith:(NSInteger)progress start:(BOOL)start
{
    CGFloat radius = 0;
    CGFloat xvalue = 0;
    CGFloat yvalue = 0;
    CGFloat angle = progress * M_PI / 6.;
    
    if (start) {
        radius = self.sizeWidth / 2. - _indicatorWidth;
    } else {
        radius = self.sizeWidth / 4.;
    }
    
    xvalue = self.sizeWidth / 2. + radius * cos(angle);
    yvalue = self.sizeWidth / 2. + radius * sin(angle);
    
    return pointMake(xvalue, yvalue);
}

- (void)startAnimation
{
    _stageValue = 0;
    
    [UTimerBooster removeTarget:self];
    [UTimerBooster addTarget:self sel:@selector(rotation) time:0.1 repeat:-1];
}

- (void)stopAnimation
{
    _stageValue = 0;
    
    [UTimerBooster removeTarget:self];
}

- (void)rotation
{
    [self performOnMainThread:@selector(setNeedsDisplay)];
    
    _stageValue ++;
    _stageValue = _stageValue % 12;
}

@end

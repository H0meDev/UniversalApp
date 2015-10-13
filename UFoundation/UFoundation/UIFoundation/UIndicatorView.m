//
//  UIndicatorView.m
//  UFoundation
//
//  Created by Think on 15/9/23.
//  Copyright © 2015年 think. All rights reserved.
//

#import "UIndicatorView.h"

@interface UIndicatorView ()
{
    UIndicatorStyle _style;
    NSInteger _stageValue;
    NSInteger _countOfLeaf;
    NSTimer *_refreshTimer;
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
        _countOfLeaf = 14;
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

- (void)setTransform:(CGAffineTransform)transform
{
    [super setTransform:transform];
    
    // Keep drawing
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, _indicatorWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    for (int i = 0 ; i < _countOfLeaf; i ++) {
        CGPoint point = [self pointWith:i + _stageValue start:YES];
        CGContextMoveToPoint(context, point.x, point.y);
        point = [self pointWith:i + _stageValue start:NO];
        CGContextAddLineToPoint(context, point.x, point.y);
        
        CGFloat alpha = i / (_countOfLeaf + 2.);
        UIColor *lineColor = [_indicatorColor colorWithAlphaComponent:alpha];
        CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
        CGContextStrokePath(context);
    }
}

- (CGPoint)pointWith:(NSInteger)progress start:(BOOL)start
{
    CGFloat radius = 0;
    CGFloat xvalue = 0;
    CGFloat yvalue = 0;
    CGFloat angle = progress * M_PI * 2 / _countOfLeaf;
    
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
    if (_refreshTimer) {
        return;
    }
    
    _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                     target:self
                                                   selector:@selector(rotationAnimation)
                                                   userInfo:nil
                                                    repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_refreshTimer forMode:NSRunLoopCommonModes];
}

- (void)stopAnimation
{
    if (_refreshTimer) {
        [_refreshTimer invalidate];
    }
    _refreshTimer = nil;
}

- (void)rotationAnimation
{
    dispatch_async(main_queue(), ^{
        _stageValue ++;
        _stageValue = _stageValue % _countOfLeaf;
        
        [self setNeedsDisplay];
    });
}

@end

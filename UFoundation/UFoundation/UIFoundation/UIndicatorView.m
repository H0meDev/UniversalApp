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
    BOOL _isAnimating;
}

@property (nonatomic, retain) CALayer *animationLayer;

@end

@implementation UIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initailize
        super.backgroundColor = sysClearColor();
        
        // Default
        _indicatorWidth = 1.0;
        _style = UIndicatorStyleCircle;
        _indicatorColor = sysLightGrayColor();
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    CGFloat width = frame.size.width;
    width = (width > frame.size.height)?frame.size.height:width;
    
    [super setFrame:rectMake(frame.origin.x, frame.origin.y, width, width)];
    
    self.animationLayer.frame = rectMake(0, 0, width, width);
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    //
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    if (_isAnimating) {
        [self.animationLayer removeAllAnimations];
        
        // Restart animation
        [self startAnimation];
    }
}

#pragma mark - Properties

- (CALayer *)animationLayer
{
    if (_animationLayer) {
        return _animationLayer;
    }
    
    CALayer *animationLayer = [[CALayer alloc]init];
    animationLayer.backgroundColor = sysClearColor().CGColor;
    [self.layer addSublayer:animationLayer];
    _animationLayer = animationLayer;
    
    return _animationLayer;
}

#pragma mark - Methods

- (void)fillIndicatorWith:(UIndicatorStyle)style
{
    // Remove last
    [self.animationLayer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = nil;
    shapeLayer.strokeColor = _indicatorColor.CGColor;
    shapeLayer.lineWidth = _indicatorWidth;
    shapeLayer.lineCap = kCALineCapRound;
    [self.animationLayer addSublayer:shapeLayer];
    
    switch (style) {
        case UIndicatorStyleCircle:
        {
            CGFloat radius = self.sizeWidth / 2. - _indicatorWidth / 2. - 2.;
            CGPoint center = pointMake(self.sizeWidth / 2., self.sizeWidth / 2.);
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                                radius:radius
                                                            startAngle:0
                                                              endAngle:M_PI * 1.8
                                                             clockwise:YES];
            shapeLayer.path = path.CGPath;
        }
            break;
            
        case UIndicatorStyleProgressCircle:
        {
            //
        }
            
        default:
            break;
    }
}

- (void)startAnimation
{
    [self fillIndicatorWith:_style];
    
    _isAnimating = YES;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    animation.duration = 1.0;
    animation.autoreverses = NO;
    animation.repeatCount = MAXFLOAT;
    
    self.animationLayer.anchorPoint = CGPointMake(0.5, 0.5);
    [self.animationLayer addAnimation:animation forKey:@"AnimationRotation"];
}

- (void)stopAnimation
{
    _isAnimating = NO;
    
    [self.animationLayer removeAllAnimations];
}

@end

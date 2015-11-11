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
    CAShapeLayer *_shapeLayer;
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
        _progress = 1.0;
        _indicatorWidth = 1.0;
        _style = UIndicatorStyleCircle;
        _indicatorColor = sysLightGrayColor();
        _indicatorGapAngle = 0.2 * M_PI;
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

- (void)fillIndicatorWith:(UIndicatorStyle)style progress:(CGFloat)progress animated:(BOOL)animated
{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        [self.animationLayer addSublayer:_shapeLayer];
    }
    
    // Remove all animations
    [_shapeLayer removeAllAnimations];

    _shapeLayer.fillColor = nil;
    _shapeLayer.strokeColor = _indicatorColor.CGColor;
    _shapeLayer.lineWidth = _indicatorWidth;
    _shapeLayer.lineCap = kCALineCapRound;
    
    switch (style) {
        case UIndicatorStyleCircle:
        {
            CGFloat radius = self.sizeWidth / 2. - _indicatorWidth / 2. - 2.;
            CGPoint center = pointMake(self.sizeWidth / 2., self.sizeWidth / 2.);
            CGFloat startAngle = - M_PI_2 + _indicatorGapAngle / 2.;
            CGFloat endAngle = M_PI * 2. - _indicatorGapAngle + startAngle;
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                                radius:radius
                                                            startAngle:startAngle
                                                              endAngle:endAngle
                                                             clockwise:YES];
            _shapeLayer.path = path.CGPath;
        }
            break;
            
        case UIndicatorStyleProgressCircle:
        {
            CGFloat radius = self.sizeWidth / 2. - _indicatorWidth / 2. - 2.;
            CGPoint center = pointMake(self.sizeWidth / 2., self.sizeWidth / 2.);
            CGFloat startAngle = - M_PI_2 + _indicatorGapAngle / 2.;
            CGFloat endAngle = (M_PI * 2. - _indicatorGapAngle) * progress + startAngle;
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                                radius:radius
                                                            startAngle:startAngle
                                                              endAngle:endAngle
                                                             clockwise:YES];
            _shapeLayer.path = path.CGPath;
        }
            break;
            
        default:
            break;
    }
}

- (void)setProgress:(CGFloat)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    if (UIndicatorStyleProgressCircle == _style && _progress != progress) {
        progress = (progress < 0)?0:progress;
        progress = (progress > 1)?1:progress;
        
        _progress = progress;
        
        dispatch_async(main_queue(), ^{
            [self fillIndicatorWith:_style progress:progress animated:animated];
        });
    }
}

- (void)startAnimation
{
    dispatch_async(main_queue(), ^{
        // Fill progress
        [self fillIndicatorWith:_style progress:_progress animated:NO];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.fromValue = [NSNumber numberWithFloat:0];
        animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
        animation.duration = 0.75;
        animation.autoreverses = NO;
        animation.repeatCount = MAXFLOAT;
        
        self.animationLayer.anchorPoint = CGPointMake(0.5, 0.5);
        [self.animationLayer addAnimation:animation forKey:@"AnimationRotation"];
        
        _isAnimating = YES;
    });
}

- (void)stopAnimation
{
    dispatch_async(main_queue(), ^{
        [self.animationLayer removeAllAnimations];
        
        _isAnimating = NO;
    });
}

@end

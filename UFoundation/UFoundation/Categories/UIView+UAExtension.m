//
//  UIView+UAExtension.m
//  UFoundation
//
//  Created by Think on 15/7/2.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UIView+UAExtension.h"
#import "UDefines.h"
#import "NSObject+UAExtension.h"
#import <objc/runtime.h>
#import "UTimerBooster.h"

@interface UIView (UAExtensionInner)

@property (nonatomic, retain) UIImageView *indicatorView;

@end

@implementation UIView (UAExtensionInner)

@dynamic indicatorView;

- (UIImageView *)indicatorView
{
    @autoreleasepool
    {
        UIImageView *_indicator = (UIImageView *)objc_getAssociatedObject(self, "UIView_indicatorView");
        if (!_indicator) {
            _indicator = [[UIImageView alloc]init];
            _indicator.clipsToBounds = YES;
            _indicator.userInteractionEnabled = YES;
            objc_setAssociatedObject(self, "UIView_indicatorView", _indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        return _indicator;
    }
}

@end

@implementation UIView (UAExtension)

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)point
{
    CGRect frame = self.frame;
    frame.origin = point;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)originX
{
    return self.frame.origin.x;
}

- (void)setOriginX:(CGFloat)originX
{
    CGRect frame = self.frame;
    frame.origin.x = originX;
    self.frame = frame;
}

- (CGFloat)originY
{
    return self.frame.origin.y;
}

- (void)setOriginY:(CGFloat)originY
{
    CGRect frame = self.frame;
    frame.origin.y = originY;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)sizeWidth
{
    return self.frame.size.width;
}

- (CGFloat)sizeHeight
{
    return self.frame.size.height;
}

- (void)setSizeWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setSizeHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)paddingLeft
{
    return self.originX;
}

- (CGFloat)paddingTop
{
    return self.originY;
}

- (CGFloat)paddingRight
{
    return self.originX + self.sizeWidth;
}

- (CGFloat)paddingBottom
{
    return self.originY + self.sizeHeight;
}

- (UIViewController *)viewController
{
    UIResponder *responder = [self nextResponder];
    while (!responder) {
        if (checkClass(responder, UIViewController)) {
            return (UIViewController *)responder.weakself;
        }
        
        responder = [responder nextResponder];
    }
    
    return nil;
}

- (UINavigationController *)navigationController
{
    return self.viewController.navigationController.weakself;
}

- (UITabBarController *)tabBarController
{
    return self.viewController.tabBarController.weakself;
}

#pragma mark - Callback from super controller

- (void)viewDidLoad
{
    //
}

- (void)viewWillAppear
{
    //
}

- (void)viewDidAppear
{
    //
}

- (void)viewWillDisappear
{
    //
}

- (void)viewDidDisappear
{
    //
}

#pragma mark - HUD extension

- (void)showWaitingWith:(NSString *)message
{
    @autoreleasepool
    {
        dispatch_async(main_queue(), ^{
            [self dismissIndicatorView];
            [self showIndicatorView];
            
            UIImageView *indicatorView = self.indicatorView;
            
            // Add indicator & title
            UIActivityIndicatorView *indicator = self.indicator;
            indicator.frame = rectMake(0, 5, 48, 48);
            indicator.center = pointMake(indicatorView.sizeWidth / 2.0, 29);
            [indicatorView addSubview:indicator];
            [indicator startAnimating];
            
            UILabel *titleLabel = self.indicatorLabel;
            titleLabel.frame = rectMake(0, 58, indicatorView.sizeWidth, 42);
            titleLabel.text = message;
            [indicatorView addSubview:titleLabel];
            
            [self showIndicatorAnimation];
        });
    }
}

- (void)showSuccessWith:(NSString *)message
{
    @autoreleasepool
    {
        dispatch_async(main_queue(), ^{
            [self dismissIndicatorView];
            [self showIndicatorView];
            
            UIImageView *indicatorView = self.indicatorView;
            
            // Add image & title
            UIImageView *statusView = self.indicatorImage;
            statusView.frame = rectMake(0, 15, 28, 28);
            statusView.center = pointMake(indicatorView.sizeWidth / 2.0, 29);
            statusView.image = loadBundleImage(@"Resource", @"hud_success_white");
            [indicatorView addSubview:statusView];
            
            UILabel *titleLabel = self.indicatorLabel;
            titleLabel.frame = rectMake(0, 58, indicatorView.sizeWidth, 42);
            titleLabel.text = message;
            [indicatorView addSubview:titleLabel];
            
            [self showIndicatorAnimation];
            
            [UTimerBooster addTarget:self sel:@selector(dismiss) time:1.0];
        });
    }
}

- (void)showErrorWith:(NSString *)message
{
    @autoreleasepool
    {
        dispatch_async(main_queue(), ^{
            [self dismissIndicatorView];
            [self showIndicatorView];
            
            UIImageView *indicatorView = self.indicatorView;
            
            // Add image & title
            UIImageView *statusView = self.indicatorImage;
            statusView.frame = rectMake(0, 15, 28, 28);
            statusView.center = pointMake(indicatorView.sizeWidth / 2.0, 29);
            statusView.image = loadBundleImage(@"Resource", @"hud_error_white");
            [indicatorView addSubview:statusView];
            
            UILabel *titleLabel = self.indicatorLabel;
            titleLabel.frame = rectMake(0, 58, indicatorView.sizeWidth, 42);
            titleLabel.text = message;
            [indicatorView addSubview:titleLabel];
            
            [self showIndicatorAnimation];
            
            [UTimerBooster addTarget:self sel:@selector(dismiss) time:1.0];
        });
    }
}

- (UIActivityIndicatorView *)indicator
{
    UIActivityIndicatorView *indicator = [UIActivityIndicatorView alloc];
    indicator = [indicator initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin |
                                  UIViewAutoresizingFlexibleTopMargin |
                                  UIViewAutoresizingFlexibleRightMargin |
                                  UIViewAutoresizingFlexibleLeftMargin);
    
    return indicator;
}

- (void)dismiss
{
    @autoreleasepool
    {
        dispatch_async(main_queue(), ^{
            [self hideIndicatorAnimation];
        });
    }
}

- (void)showIndicatorView
{
    // Start timer
    [UTimerBooster start];
    
    UIImageView *indicatorView = self.indicatorView;
    indicatorView.frame = rectMake(0, 0, 160, 100);
    indicatorView.center = pointMake(self.sizeWidth/2.0, self.sizeHeight/2.0);
    indicatorView.layer.cornerRadius = 6;
    indicatorView.backgroundColor = rgbaColor(0, 0, 0, 0.8);
    [self addSubview:indicatorView];
    [self bringSubviewToFront:indicatorView];
}

- (UIImageView *)indicatorImage
{
    @autoreleasepool
    {
        UIImageView *statusView = [[UIImageView alloc]init];
        statusView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin |
                                       UIViewAutoresizingFlexibleTopMargin |
                                       UIViewAutoresizingFlexibleRightMargin |
                                       UIViewAutoresizingFlexibleLeftMargin |
                                       UIViewAutoresizingFlexibleWidth |
                                       UIViewAutoresizingFlexibleHeight);
        return statusView;
    }
}

- (UILabel *)indicatorLabel
{
    @autoreleasepool
    {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin |
                                       UIViewAutoresizingFlexibleTopMargin |
                                       UIViewAutoresizingFlexibleRightMargin |
                                       UIViewAutoresizingFlexibleLeftMargin |
                                       UIViewAutoresizingFlexibleWidth |
                                       UIViewAutoresizingFlexibleHeight);
        titleLabel.font = systemFont(16);
        titleLabel.textColor = sysWhiteColor();
        titleLabel.backgroundColor = sysClearColor();
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        return titleLabel;
    }
}

- (void)showIndicatorAnimation
{
    UIImageView *indicatorView = self.indicatorView;
    indicatorView.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        indicatorView.alpha = 1.0;
    }];
}

- (void)hideIndicatorAnimation
{
    UIImageView *indicatorView = self.indicatorView;
    indicatorView.alpha = 1.0;
    
    [UIView animateWithDuration:0.3 animations:^{
        indicatorView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self dismissIndicatorView];
        }
    }];
}

- (void)dismissIndicatorView
{
    UIImageView *indicatorView = self.indicatorView;
    for (UIView *view in indicatorView.subviews) {
        if (checkClass(view, UIActivityIndicatorView)) {
            UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)view;
            [indicator stopAnimating];
        }
        
        if (checkClass(view, UIImageView)) {
            UIImageView *statusView = (UIImageView *)view;
            statusView.image = nil;
        }
        
        [view removeFromSuperview];
    }
}

@end

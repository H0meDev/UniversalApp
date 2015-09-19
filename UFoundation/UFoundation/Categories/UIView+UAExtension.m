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

@implementation UIViewLayoutParam

+ (UIViewLayoutParam *)param
{
    @autoreleasepool
    {
        return [[UIViewLayoutParam alloc]init];
    }
}

@end

@implementation UIView (UAExtension)

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

- (void)removeAllSubviews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
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

@end

@implementation UIView (UALayoutExtension)

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

- (void)setScaleOriginX:(CGFloat)value
{
    self.originX = value * screenWidthScale();
}

- (void)setScaleOriginY:(CGFloat)value
{
    self.originY = value * screenWidthScale();
}

- (void)setScaleSizeWidth:(CGFloat)value
{
    self.sizeWidth = value * screenWidthScale();
}

- (void)setScaleSizeHeight:(CGFloat)value
{
    self.sizeHeight = value * screenWidthScale();
}

- (void)setScaleSize:(CGSize)size
{
    self.size = sizeMake(size.width * screenWidthScale(), size.height * screenWidthScale());
}

- (void)setScaleFrame:(CGRect)frame
{
    self.frame = rectMake(frame.origin.x * screenWidthScale(),
                          frame.origin.y * screenWidthScale(),
                          frame.size.width * screenWidthScale(),
                          frame.size.height * screenWidthScale());
}

- (UIViewLayoutParam *)layoutParam
{
    return (UIViewLayoutParam *)objc_getAssociatedObject(self, "UIViewLayoutParam");
}

- (void)setLayoutParam:(UIViewLayoutParam *)param
{
    if (!checkClass(param, UIViewLayoutParam)) {
        return;
    }
    
    // Store
    objc_setAssociatedObject(self, "UIViewLayoutParam", param, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // Clear subviews
    [self removeAllSubviews];
    
    switch (param.layoutType & 0xF0) {
        case 0x10:
        {
            [self setLinearHLayout];
        }
            break;
            
        case 0x20:
        {
            [self setLinearVLayout];
        }
            break;
            
        case 0x30:
        {
            [self setGridLayout];
        }
            break;
            
        case 0x40:
        {
            [self setCenterLayout];
        }
            break;
            
        default:
            break;
    }
}

- (void)setLinearHLayout
{
    if (!self.layoutParam) {
        return;
    }
    
    CGFloat originX = self.layoutParam.edgeInsets.left;
    CGFloat originY = self.layoutParam.edgeInsets.top;
    CGFloat width = - 1;
    CGFloat height = -1;
    
    if (checkValidNSArray(self.layoutParam.layoutViews)) {
        CGFloat insetsH = self.layoutParam.edgeInsets.left + self.layoutParam.edgeInsets.right;
        CGFloat insetsV = self.layoutParam.edgeInsets.top + self.layoutParam.edgeInsets.bottom;
        CGFloat padding = self.layoutParam.spacingHorizontal * (self.layoutParam.layoutViews.count - 1);
        
        if (self.layoutParam.layoutType == UIViewLayoutTypeHLinearResizeAll) {
            width = (self.sizeWidth - insetsH - padding) / self.layoutParam.layoutViews.count;
            height = self.sizeHeight - insetsV;
        } else if (self.layoutParam.layoutType == UIViewLayoutTypeHLinearResizeWidth) {
            width = (self.sizeWidth - insetsH - padding) / self.layoutParam.layoutViews.count;
        } else if (self.layoutParam.layoutType == UIViewLayoutTypeHLinearResizeHeight) {
            height = self.sizeHeight - insetsV;
        }
    }
    
    for (UIView *view in self.layoutParam.layoutViews) {
        [self addSubview:view];
        
        // Resize
        width = (width == -1)?view.sizeWidth:width;
        height = (height == -1)?view.sizeHeight:height;
        view.frame = rectMake(originX, originY, width, height);
        
        // Horizontal
        originX += view.sizeWidth + self.layoutParam.spacingHorizontal;
    }
}

- (void)setLinearVLayout
{
    if (!self.layoutParam) {
        return;
    }
    
    CGFloat originX = self.layoutParam.edgeInsets.left;
    CGFloat originY = self.layoutParam.edgeInsets.top;
    CGFloat width = - 1;
    CGFloat height = -1;
    
    if (checkValidNSArray(self.layoutParam.layoutViews)) {
        CGFloat insetsH = self.layoutParam.edgeInsets.left + self.layoutParam.edgeInsets.right;
        CGFloat insetsV = self.layoutParam.edgeInsets.top + self.layoutParam.edgeInsets.bottom;
        CGFloat padding = self.layoutParam.spacingVertical * (self.layoutParam.layoutViews.count - 1);
        
        if (self.layoutParam.layoutType == UIViewLayoutTypeVLinearResizeAll) {
            width = self.sizeWidth - insetsH;
            height = (self.sizeHeight - insetsV - padding) / self.layoutParam.layoutViews.count;
        } else if (self.layoutParam.layoutType == UIViewLayoutTypeVLinearResizeWidth) {
            width = self.sizeWidth - insetsH;
        } else if (self.layoutParam.layoutType == UIViewLayoutTypeVLinearResizeHeight) {
            height = (self.sizeHeight - insetsV - padding) / self.layoutParam.layoutViews.count;
        }
    }
    
    for (UIView *view in self.layoutParam.layoutViews) {
        [self addSubview:view];
        
        // Resize
        width = (width == -1)?view.sizeWidth:width;
        height = (height == -1)?view.sizeHeight:height;
        view.frame = rectMake(originX, originY, width, height);
        
        // Vertical
        originY += view.sizeHeight + self.layoutParam.spacingVertical;
    }
}

- (void)setGridLayout
{
    if (!self.layoutParam) {
        return;
    }
}

- (void)setCenterLayout
{
    if (!self.layoutParam) {
        return;
    }
}

@end

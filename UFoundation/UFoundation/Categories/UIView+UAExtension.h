//
//  UIView+UAExtension.h
//  UFoundation
//
//  Created by Think on 15/7/2.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIViewLayoutType)
{
    UIViewLayoutTypeHLinearResizeNone = 0x10,
    UIViewLayoutTypeHLinearResizeWidth,
    UIViewLayoutTypeHLinearResizeHeight,
    UIViewLayoutTypeHLinearResizeAll,
    
    UIViewLayoutTypeVLinearResizeNone = 0x20,
    UIViewLayoutTypeVLinearResizeWidth,
    UIViewLayoutTypeVLinearResizeHeight,
    UIViewLayoutTypeVLinearResizeAll,
    
    UIViewLayoutTypeGridResizeNone = 0x30,
    UIViewLayoutTypeGridResizeWidth,
    UIViewLayoutTypeGridResizeHeight,
    UIViewLayoutTypeGridResizeAll,
    
    UIViewLayoutTypeCenterResizeNone = 0x40,
    UIViewLayoutTypeCenterResizeWidth,
    UIViewLayoutTypeCenterResizeHeight,
    UIViewLayoutTypeCenterResizeAll,
};

@interface UIViewLayoutParam : NSObject

@property (nonatomic, copy)   NSArray *layoutViews;
@property (nonatomic, assign) UIViewLayoutType layoutType;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) CGFloat spacingVertical;
@property (nonatomic, assign) CGFloat spacingHorizontal;

+ (UIViewLayoutParam *)param;

@end

@interface UIView (UAExtension)

// The controller of response
- (UIViewController *)viewController;

// The controller of response
- (UINavigationController *)navigationController;

// The controller of response
- (UITabBarController *)tabBarController;

// Remove subviews
- (void)removeAllSubviews;

// Callback
- (void)viewDidLoad;
- (void)viewWillAppear;
- (void)viewDidAppear;
- (void)viewWillDisappear;
- (void)viewDidDisappear;

@end

@interface UIView (UALayoutExtension)

// Origin of view frame
- (CGPoint)origin;

// Set origin, can not be used in setFrame method
- (void)setOrigin:(CGPoint)point;

// Size of view frame
- (CGSize)size;

// Set size, can not be used in setFrame method
- (void)setSize:(CGSize)size;

// Origin X of origin
- (CGFloat)originX;

// Set originX, can not be used in setFrame method
- (void)setOriginX:(CGFloat)originX;

// Origin Y of origin
- (CGFloat)originY;

// Set originY, can not be used in setFrame method
- (void)setOriginY:(CGFloat)originY;

// Center X of origin
- (CGFloat)centerX;

// Set centerX, can not be used in setFrame method
- (void)setCenterX:(CGFloat)centerX;

// Center Y of origin
- (CGFloat)centerY;

// Set centerY, can not be used in setFrame method
- (void)setCenterY:(CGFloat)centerY;

// Size width of origin
- (CGFloat)sizeWidth;

// Set sizeWidth, can not be used in setFrame method
- (void)setSizeWidth:(CGFloat)width;

// Size height of origin
- (CGFloat)sizeHeight;

// Set sizeHeight, can not be used in setFrame method
- (void)setSizeHeight:(CGFloat)height;

// Left padding
- (CGFloat)paddingLeft;

// Top padding
- (CGFloat)paddingTop;

// Right padding
- (CGFloat)paddingRight;

// Bottom padding
- (CGFloat)paddingBottom;

// Autolayout scale of originX
- (void)setScaleOriginX:(CGFloat)value;

// Autolayout scale of originY
- (void)setScaleOriginY:(CGFloat)value;

// Autolayout scale of sizeWidth
- (void)setScaleSizeWidth:(CGFloat)value;

// Autolayout scale of sizeHeight
- (void)setScaleSizeHeight:(CGFloat)value;

// Autolayout scale of size
- (void)setScaleSize:(CGSize)size;

// Autolayout scale of frame
- (void)setScaleFrame:(CGRect)frame;

// Params for subview layout
- (UIViewLayoutParam *)layoutParam;
- (void)setLayoutParam:(UIViewLayoutParam *)param;

@end

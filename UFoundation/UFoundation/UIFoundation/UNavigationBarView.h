//
//  UNavigationBarView.h
//  UFoundation
//
//  Created by Think on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ULabel.h"
#import "UButton.h"

@interface UNavigationBarButton : UButton

// Back image
- (void)setImageWithColor:(UIColor *)color;
- (void)setHImageWithColor:(UIColor *)color;
- (void)setSImageWithColor:(UIColor *)color;
- (void)setDImageWithColor:(UIColor *)color;

@end

@interface UNavigationBarView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) UIFont *titleFont;
@property (nonatomic, copy) UIColor *titleColor;
@property (nonatomic, copy) UIColor *bottomLineColor;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, assign) BOOL bottomLineHidden;
@property (nonatomic, assign) BOOL enable;

// Stand style
@property (nonatomic, strong) UNavigationBarButton *leftButton;
@property (nonatomic, strong) UNavigationBarButton *rightButton;

// Custom style
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIView *rightView;

@end

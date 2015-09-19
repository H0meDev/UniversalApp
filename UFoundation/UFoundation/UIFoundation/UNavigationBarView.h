//
//  UNavigationBarView.h
//  UFoundation
//
//  Created by Think on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ULabel.h"
#import "UNavigationBarButton.h"

@interface UNavigationBarView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) UIFont *titleFont;
@property (nonatomic, copy) UIColor *titleColor;
@property (nonatomic, copy) UIColor *bottomLineColor;
@property (nonatomic, retain) UIImage *backgroundImage;
@property (nonatomic, assign) BOOL bottomLineHidden;

// Stand style
@property (nonatomic, retain) UNavigationBarButton *leftButton;
@property (nonatomic, retain) UNavigationBarButton *rightButton;

// Custom style
@property (nonatomic, retain) UIView *leftView;
@property (nonatomic, retain) UIView *centerView;
@property (nonatomic, retain) UIView *rightView;

@end

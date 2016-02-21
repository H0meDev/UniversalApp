//
//  BaseNavigationController.h
//  UFoundation
//
//  Created by Think on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UViewController.h"

@class UStatusBarView;
@class UNavigationBarView;

@interface UNavigationController : UINavigationController

/*
 * Status bar
 */
@property (nonatomic, weak, readonly) UStatusBarView *statusBarView;
@property (nonatomic, assign) BOOL statusBarContentBackgroundTransparent; // Default is NO

/*
 * Navigation bar
 */
@property (nonatomic, weak, readonly) UNavigationBarView *navigationBarView;
@property (nonatomic, assign) BOOL navigationBarContentBackgroundTransparent; // Default is NO

/*
 * Controller of current visiable UViewController
 */
@property (nonatomic, weak, readonly) UViewController *viewController;

// Init with root view controller
+ (id)controllerWithRoot:(UIViewController *)rootViewController;

@end

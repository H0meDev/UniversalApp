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
 * Status bar view
 * The status bar view can be costumized as you like
 */
@property (nonatomic, weak, readonly) UStatusBarView *statusBarView;

/*
 * Navigation bar view
 * The navigation bar view can be costumized as you like
 */
@property (nonatomic, weak, readonly) UNavigationBarView *navigationBarView;

/*
 * Controller of current rootViewController
 */
@property (nonatomic, weak, readonly) UViewController *viewController;

@end

//
//  BaseViewController.h
//  UFoundation
//
//  Created by Think on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+UAExtension.h"
#import "UStatusBarView.h"
#import "UNavigationBarView.h"
#import "UTabBarView.h"


@interface UViewController : UIViewController

/*
 * Status bar view
 * The status bar view can be costumized as you like
 */
@property (nonatomic, strong, readonly) UStatusBarView *statusBarView;

/*
 * Navigation bar view
 * The navigation bar view can be costumized as you like
 */
@property (nonatomic, strong, readonly) UNavigationBarView *navigationBarView;

/*
 * Content view
 * Super view is self.view
 */
@property (nonatomic, strong, readonly) UIView *contentView;

/*
 * Container view
 * It is the view to add subview
 */
@property (nonatomic, strong, readonly) UIView *containerView;

/*
 * The gesture surpports draging pop of controller
 * Default is YES
 */
@property (nonatomic, assign) BOOL enableGuesture;

/*
 * The count of controller required to be pop at one time
 */
@property (nonatomic, assign) NSUInteger countOfControllerToPop;

/*
 * If enableGuesture is YES, these methods will work
 */
- (void)controllerWillMove;
- (void)controllerIsMovingWith:(CGFloat)progress;
- (void)controllerWillMoveBack;
- (void)controllerDidMoveBack;
- (void)controllerWillMovePop;
- (void)controllerWillPop;

/*
 * Convenient to use
 */
- (void)pushViewController:(UIViewController *)viewController;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (UIViewController *)popViewController;
- (UIViewController *)popViewControllerAnimated:(BOOL)animated;

/*
 * The view will be added to containerView
 */
- (void)addSubview:(UIView *)view;

/*
 * The view will received methods such as viewWillApear in UIView+UAExtension.h
 * The view will be removed automatically
 */
- (void)addAttacheView:(UIView *)view;

/*
 * You can also remove the attached view by this method
 */
- (void)removeAttachedView:(UIView *)view;

/*
 * Remove all attached view
 */
- (void)removeAllAttachedViews;

/*
 * HUD view
 */
- (void)showWaitingWith:(NSString *)message;
- (void)showSuccessWith:(NSString *)message;
- (void)showErrorWith:(NSString *)message;
- (void)dismiss;

@end

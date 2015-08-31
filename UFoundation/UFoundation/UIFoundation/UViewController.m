//
//  BaseViewController.m
//  UFoundation
//
//  Created by Think on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UDefines.h"
#import "UViewController.h"
#import "UNavigationController.h"
#import "NSObject+UAExtension.h"
#import "UIView+UAExtension.h"
#import "UStatusBarView.h"
#import "UNavigationBarView.h"

@interface UViewController ()
{
    NSMutableArray *_attachedViews;
}

@end

@implementation UViewController

@synthesize contentView = _contentView;
@synthesize statusBarView = _statusBarView;
@synthesize navigationBarView = _navigationBarView;
@synthesize containerView = _containerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initliaze
        self.countOfControllerToPop = 1;
        self.view.backgroundColor = sysWhiteColor();
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Inialize views
    [self contentView];
    [self statusBarView];
    [self navigationBarView];
    [self containerView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Relayout
    [self customizeRelayout];
    
    // Callback
    for (UIView *view in _attachedViews) {
        if ([view respondsToSelector:@selector(viewWillAppear)]) {
            [view performOnMainThread:@selector(viewWillAppear)];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    for (UIView *view in _attachedViews) {
        if ([view respondsToSelector:@selector(viewDidAppear)]) {
            [view performOnMainThread:@selector(viewDidAppear)];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    for (UIView *view in _attachedViews) {
        if ([view respondsToSelector:@selector(viewWillDisappear)]) {
            [view performOnMainThread:@selector(viewWillDisappear)];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    for (UIView *view in _attachedViews) {
        if ([view respondsToSelector:@selector(viewDidDisappear)]) {
            [view performOnMainThread:@selector(viewDidDisappear)];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)dealloc
{
    [self removeAllAttachedViews];
    
    if (_statusBarView) {
        [_statusBarView removeFromSuperview];
    }
    
    if (_navigationBarView) {
        [_navigationBarView removeFromSuperview];
    }
    
    if (_containerView) {
        [_containerView removeFromSuperview];
    }
    
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Properties

- (UIView *)contentView
{
    if (_contentView) {
        return _contentView;
    }
    
    UIView *contentView = [[UIView alloc]init];
    contentView.frame = rectMake(0, 0, screenWidth(), screenHeight());
    contentView.backgroundColor = sysWhiteColor();
    [self.view addSubview:contentView];
    _contentView = contentView;
    
    return _contentView;
}

- (UStatusBarView *)statusBarView
{
    if (_statusBarView) {
        return _statusBarView;
    }
    
    CGRect frame = rectMake(0, 0, screenWidth(), statusHeight());
    UStatusBarView *statusBarView = [[UStatusBarView alloc]initWithFrame:frame];
    [self.contentView addSubview:statusBarView];
    _statusBarView = statusBarView;
    
    return _statusBarView;
}

- (UNavigationBarView *)navigationBarView
{
    if (_navigationBarView) {
        return _navigationBarView;
    }
    
    CGRect frame = rectMake(0, statusHeight(), screenWidth(), naviHeight());
    UNavigationBarView *navigationBarView = [[UNavigationBarView alloc]initWithFrame:frame];
    [self.contentView addSubview:navigationBarView];
    _navigationBarView = navigationBarView;
    
    return _navigationBarView;
}

- (UIView *)containerView
{
    if (_containerView) {
        return _containerView;
    }
    
    UIView *containerView = [[UIView alloc]init];
    containerView.frame = rectMake(0, 0, screenWidth(), screenHeight());
    containerView.backgroundColor = sysClearColor();
    containerView.clipsToBounds = NO;
    containerView.userInteractionEnabled = YES;
    [self.contentView addSubview:containerView];
    _containerView = containerView;
    
    return _containerView;
}

- (void)setCountOfControllerToPop:(NSUInteger)count
{
    _countOfControllerToPop = (count < 1)?1:count;
}

#pragma mark - Methods

- (void)pushViewController:(UIViewController *)viewController
{
    [self pushViewController:viewController animated:YES];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.navigationController pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewController
{
    return [self popViewControllerAnimated:YES];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    return [self.navigationController popViewControllerAnimated:animated];
}

- (void)addSubview:(UIView *)view
{
    if (!view || view == _containerView) {
        return;
    }
    
    if (!_containerView) {
        [self.view addSubview:view];
    } else {
        [_containerView addSubview:view];
    }
}

- (void)addAttacheView:(UIView *)view
{
    if (!checkClass(view, UIView)) {
        return;
    }
    
    if (!_attachedViews) {
        _attachedViews = [NSMutableArray array];
    }
    [_attachedViews addObject:view];
    
    if ([view respondsToSelector:@selector(viewDidLoad)]) {
        [view performOnMainThread:@selector(viewDidLoad)];
    }
}

- (void)removeAttachedView:(UIView *)view
{
    if (!checkClass(view, UIView)) {
        return;
    }
    
    if (_attachedViews) {
        [_attachedViews removeObject:view];
    }
}

- (void)removeAllAttachedViews
{
    if (_attachedViews) {
        for (UIView *view in _attachedViews) {
            if (view.superview) {
                [view removeFromSuperview];
            }
        }
        [_attachedViews removeAllObjects];
    }
}

- (void)customizeRelayout
{
    // Reset contentView
    self.contentView.transform = CGAffineTransformMakeTranslation(0, 0);
    self.contentView.originX = 0;
    [self.view addSubview:self.contentView];
    [self.view bringSubviewToFront:self.contentView];
}

#pragma mark - Callback

- (void)controllerWillMove
{
    //
}

- (void)controllerIsMovingWith:(CGFloat)progress
{
    //
}

- (void)controllerWillMoveBack
{
    //
}

- (void)controllerDidMoveBack
{
    //
}

- (void)controllerWillMovePop
{
    //
}

- (void)controllerWillPop
{
    //
}

#pragma mark - HUD

- (void)showWaitingWith:(NSString *)message
{
    [self.containerView showWaitingWith:message];
}

- (void)showSuccessWith:(NSString *)message
{
    [self.containerView showSuccessWith:message];
}

- (void)showErrorWith:(NSString *)message
{
    [self.containerView showErrorWith:message];
}

- (void)dismiss
{
    [self.containerView dismiss];
}

@end

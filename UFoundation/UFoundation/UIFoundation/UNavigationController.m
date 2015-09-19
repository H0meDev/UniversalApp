//
//  BaseNavigationController.m
//  UFoundation
//
//  Created by Think on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UDefines.h"
#import "UNavigationController.h"
#import "UTabBarController.h"
#import "UNavigationBarView.h"
#import "UIColor+UAExtension.h"
#import "UIView+UAExtension.h"
#import "UStatusBarView.h"
#import "UNavigationBarView.h"
#import "NSObject+UAExtension.h"


@interface UNavigationController () <UIGestureRecognizerDelegate>
{
    CGPoint _startPoint;
    BOOL _isGestureMoving;
    CGFloat _transformRate;
    
    UImageView *_lastStatusBGView;
    UImageView *_currentStatusBGView;
    UImageView *_lastNaviBGView;
    UImageView *_currentNaviBGView;
    
    // For bars
    __weak UStatusBarView *_lastStatusView;
    __weak UStatusBarView *_currentStatusView;
    __weak UNavigationBarView *_lastNavigationView;
    __weak UNavigationBarView *_currentNavigationView;
}

@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UIView *shadowView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, weak) UViewController *viewController;

@end

@implementation UNavigationController

@synthesize statusBarView = _statusBarView;
@synthesize navigationBarView = _navigationBarView;

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        // Initalize
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarHidden = YES;
    self.view.backgroundColor = sysClearColor();
    
    _startPoint = CGPointZero;
    _transformRate = (systemVersionFloat() >= 7.0)?animationDuration() - 0.05:1.0;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]init];
    panGesture.maximumNumberOfTouches = 1;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.delegate = self;
    [panGesture addTarget:self action:@selector(panAction:)];
    [self.view addGestureRecognizer:panGesture];
    _panGesture = panGesture;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Refresh Bars
    [self refreshBarUserInterface];
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
    if (_viewController) {
        return _viewController.preferredStatusBarStyle;
    }
    
    return UIStatusBarStyleDefault;
}

- (void)dealloc
{
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
    
    // Status bar background
    UImageView *lastStatusBGView = [[UImageView alloc]init];
    lastStatusBGView.frame = rectMake(0, 0, screenWidth(), statusHeight());
    lastStatusBGView.backgroundColor = sysBlueColor();
    [self.view addSubview:lastStatusBGView];
    _lastStatusBGView = lastStatusBGView;
    
    UImageView *currentStatusBGView = [[UImageView alloc]init];
    currentStatusBGView.frame = rectMake(0, 0, screenWidth(), statusHeight());
    currentStatusBGView.backgroundColor = sysBlueColor();
    [self.view addSubview:currentStatusBGView];
    _currentStatusBGView = currentStatusBGView;
    
    // Navigation bar background
    UImageView *lastNaviBGView = [[UImageView alloc]init];
    lastNaviBGView.frame = rectMake(0, statusHeight(), screenWidth(), naviHeight());
    lastNaviBGView.backgroundColor = rgbColor(239, 239, 239);
    [self.view addSubview:lastNaviBGView];
    _lastNaviBGView = lastNaviBGView;
    
    UImageView *currentNaviBGView = [[UImageView alloc]init];
    currentNaviBGView.frame = rectMake(0, statusHeight(), screenWidth(), naviHeight());
    currentNaviBGView.backgroundColor = rgbColor(239, 239, 239);
    [self.view addSubview:currentNaviBGView];
    _currentNaviBGView = currentNaviBGView;
    
    UIView *contentView = [[UIView alloc]init];
    contentView.frame = rectMake(0, 0, screenWidth(), statusHeight() + naviHeight());
    contentView.userInteractionEnabled = YES;
    contentView.backgroundColor = sysClearColor();
    [self.view addSubview:contentView];
    _contentView = contentView;
    
    return _contentView;
}

- (UIView *)shadowView
{
    if (_shadowView) {
        return _shadowView;
    }
    
    CGFloat originY = 0;
    UIView *shadowView = [[UIView alloc]init];
    shadowView.frame = rectMake(0, originY, screenWidth(), screenHeight() - originY);
    shadowView.backgroundColor = sysBlackColor();
    shadowView.userInteractionEnabled = YES;
    shadowView.alpha = 0;
    _shadowView = shadowView;
    
    return _shadowView;
}

#pragma mark - Methods

- (void)refreshBarUserInterface
{
    UIViewController *controller = [self.viewControllers lastObject];
    UViewController *theController = [self controllerWith:controller];
    [self refreshViewController:theController withPush:NO];
}

- (void)refreshViewController:(UViewController *)viewController withPush:(BOOL)push
{
    _viewController = viewController;
    
    NSInteger count = 1;
    if(!push) {
        count = _viewController.countOfControllerToPop;
    }
    
    // Index
    NSInteger index = self.viewControllers.count - count - 1;
    index = (index < 0)?0:index;
    
    UIViewController *controller = self.viewControllers[index];
    if (controller) {
        if (controller == viewController) {
            if (count >= 1) {
                controller = self.viewControllers[count - 1];
            }
        }
        
        UViewController *theController = [self controllerWith:controller];
        _lastStatusView = theController.statusBarView;
        _lastNavigationView = theController.navigationBarView;
        _lastStatusBGView.backgroundColor = theController.statusBarView.backgroundColor;
        _lastNaviBGView.backgroundColor = theController.navigationBarView.backgroundColor;
    }
    
    _lastStatusView.hidden = YES;
    _lastNavigationView.hidden = YES;
    _currentStatusView.hidden = YES;
    _currentNavigationView.hidden = YES;
    
    _currentStatusView = viewController.statusBarView;
    _currentNavigationView = viewController.navigationBarView;
    _currentStatusBGView.backgroundColor = viewController.statusBarView.backgroundColor;
    _currentNaviBGView.backgroundColor = viewController.navigationBarView.backgroundColor;
    
    _currentStatusView.hidden = NO;
    _currentNavigationView.hidden = NO;
    
    [self.contentView addSubview:_currentStatusView];
    [self.contentView addSubview:_currentNavigationView];
    [self.contentView bringSubviewToFront:_currentStatusView];
    [self.contentView bringSubviewToFront:_currentNavigationView];
    
    // Refresh status bar style
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)isValidateInPoint:(CGPoint)point
{
    return (point.x > 0 && point.x <= 40) && (point.y > naviHeight());
}

- (void)repositionAllViewWithX:(CGFloat)xvalue
{
    xvalue = (xvalue > screenWidth())?screenWidth():xvalue;
    xvalue = (xvalue < 0)?0:xvalue;
    
    // Last controller
    NSInteger count = _viewController.countOfControllerToPop;
    NSInteger index = self.viewControllers.count - count - 1;
    index = (index < 0)?0:index;
    
    __weak UIView *lastContentView = [self contentViewWithIndex:index];
    if (lastContentView) {
        // Reposition current
        __weak UIView *currentContentView = _viewController.contentView;
        currentContentView.originX = xvalue;
        
        // Reposition last
        [currentContentView.superview addSubview:lastContentView];
        [currentContentView.superview insertSubview:currentContentView aboveSubview:lastContentView];
        
        // Moving with currentView
        CGFloat centerX = (xvalue - screenWidth()) * _transformRate;
        lastContentView.transform = CGAffineTransformMakeTranslation(centerX, 0);
        
        // Shadow
        CGFloat progress = xvalue / screenWidth();
        self.shadowView.alpha = (1.0 - progress) * 0.1;
        [lastContentView addSubview:self.shadowView];
        
        // Bar animation
        [self repositionBarsWithX:xvalue];
        
        // Callback
        if (_viewController && [_viewController respondsToSelector:@selector(controllerIsMovingWith:)]) {
            [_viewController controllerIsMovingWith:progress];
        }
    }
}

- (void)repositionBarsWithX:(CGFloat)xvalue
{
    if (_lastNavigationView) {
        _lastNavigationView.hidden = NO;
        [self.contentView addSubview:_lastNavigationView];
        [self.contentView insertSubview:_lastNavigationView belowSubview:_currentNavigationView];
        
        // Reposition last
        [_lastNavigationView performWithName:@"repositionLastWith:" with:@(xvalue - screenWidth())];
    }
    
    if (!_lastNavigationView.leftButton) {
        // As last
        [_currentNavigationView performWithName:@"repositionLastWith:" with:@(xvalue)];
    } else {
        // As current
        [_currentNavigationView performWithName:@"repositionCurrentWith:" with:@(xvalue)];
    }
    
    CGFloat alpha = xvalue / screenWidth();
    // Status background change
    if (![_lastStatusBGView.backgroundColor isEqualToColor:_currentStatusBGView.backgroundColor]) {
        _lastStatusBGView.alpha = alpha;
        _currentStatusBGView.alpha = 1.0 - alpha;
    }
    
    // Navigation background change
    if (![_lastNaviBGView.backgroundColor isEqualToColor:_currentNaviBGView.backgroundColor]) {
        _lastNaviBGView.alpha = alpha;
        _currentNaviBGView.alpha = 1.0 - alpha;
    }
}

- (void)rollbackAnimationWithX:(CGFloat)xvalue
{
    [self repositionAllViewWithX:xvalue];
    
    [UIView animateWithDuration:animationDuration()
                          delay:0
                        options:UIViewAnimationOptionTransitionFlipFromRight
                     animations:^{
                         [self repositionAllViewWithX:0];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             // Remove shadow
                             [self.shadowView removeFromSuperview];
                             
                             // Refresh bar
                             [self refreshBarUserInterface];
                             
                             // If current is UTabBarController
                             UIViewController *currentController = [self.viewControllers lastObject];
                             if (checkClass(currentController, UTabBarController)) {
                                 [currentController viewWillAppear:NO];
                             }
                             
                             // Callback
                             if (_viewController && [_viewController respondsToSelector:@selector(controllerDidMoveBack)]) {
                                 [_viewController controllerDidMoveBack];
                             }
                         }
                     }];
    
    // Callback
    if (_viewController && [_viewController respondsToSelector:@selector(controllerWillMoveBack)]) {
        [_viewController controllerWillMoveBack];
    }
}

- (void)popAnimationWithX:(CGFloat)xvalue
{
    [self repositionAllViewWithX:xvalue];
    
    CGFloat delta = screenWidth() / 4.0;
    CGFloat duration = 0.4 * (screenWidth() - xvalue) / (screenWidth() - delta);
    duration = (duration < 0.25)?0.25:duration;
    [UIView animateWithDuration:animationDuration()
                          delay:0
                        options:UIViewAnimationOptionTransitionFlipFromLeft
                     animations:^{
                         [self repositionAllViewWithX:screenWidth()];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             // Remove shadow
                             [self.shadowView removeFromSuperview];
                             
                             // Pop controller
                             [self popViewControllerAnimated:NO];
                             
                             if (![_lastStatusBGView.backgroundColor isEqualToColor:_currentStatusBGView.backgroundColor]) {
                                 _lastStatusBGView.alpha = 0;
                                 _currentStatusBGView.alpha = 1.0 - _lastStatusBGView.alpha;
                             }
                             
                             if (![_lastNaviBGView.backgroundColor isEqualToColor:_currentNaviBGView.backgroundColor]) {
                                 _lastNaviBGView.alpha = 0;
                                 _currentNaviBGView.alpha = 1.0 - _lastNaviBGView.alpha;
                             }
                         }
                     }];
    
    // Callback
    if (_viewController && [_viewController respondsToSelector:@selector(controllerWillMovePop)]) {
        [_viewController controllerWillMovePop];
    }
}

- (UIView *)contentViewWithIndex:(NSInteger)index
{
    if (index < 0 || index >= self.viewControllers.count) {
        return nil;
    }
    
    CGFloat originY = screenHeight() - tabHeight();
    UIView *contentView = nil;
    UIViewController *theController = self.viewControllers[index];
    
    if (checkClass(theController, UTabBarController)) {
        // UTabBarController tabBarView
        UTabBarView *tabBarView = ((UTabBarController *)theController).tabBarView;
        tabBarView.frame = rectMake(0, originY, screenWidth(), tabHeight());
        
        // Selected ViewController
        theController = ((UTabBarController *)theController).selectedViewController;
        if (checkClass(theController, UViewController)) {
            UViewController *controller = (UViewController *)theController;
            contentView = controller.contentView;
            [contentView addSubview:tabBarView];
            [contentView bringSubviewToFront:tabBarView];
        }
    } else if (checkClass(theController, UViewController)) {
        UViewController *controller = (UViewController *)theController;
        contentView = controller.contentView;
    }
    
    // If current is UTabBarController
    if ((index + 1) < self.viewControllers.count) {
        UIViewController *currentController = [self.viewControllers lastObject];
        if (checkClass(currentController, UTabBarController)) {
            UTabBarView *currentTabBarView = ((UTabBarController *)currentController).tabBarView;
            currentTabBarView.frame = rectMake(0, originY, screenWidth(), tabHeight());
            
            UIViewController *selectedController = ((UTabBarController *)currentController).selectedViewController;
            if (checkClass(selectedController, UViewController)) {
                UViewController *controller = (UViewController *)selectedController;
                [controller.contentView addSubview:currentTabBarView];
            }
        }
    }
    
    return contentView;
}

- (void)setNavigationBarHidden:(BOOL)hidden
{
    [self setNavigationBarHidden:hidden animated:NO];
}

- (UViewController *)controllerWith:(UIViewController *)viewController
{
    while (1) {
        if (checkClass(viewController, UViewController)) {
            return (UViewController *)viewController;
        } else if (checkClass(viewController, UTabBarController)) {
            UTabBarController *tabController = (UTabBarController *)viewController;
            viewController = tabController.selectedViewController;
        } else if (checkClass(viewController, UNavigationController)) {
            UNavigationController *navController = (UNavigationController *)viewController;
            viewController = navController.visibleViewController;
        }
    }
}

- (void)pushAnimation
{
    [self repositionBarsWithX:screenWidth()];
    
    [UIView animateWithDuration:animationDuration()
                          delay:0
                        options:UIViewAnimationOptionTransitionFlipFromRight
                     animations:^{
                         [self repositionBarsWithX:0];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self refreshBarUserInterface];
                         }
                     }];
}

- (void)popAnimation
{
    [self repositionBarsWithX:0];
    
    [UIView animateWithDuration:animationDuration()
                          delay:0
                        options:UIViewAnimationOptionTransitionFlipFromLeft
                     animations:^{
                         [self repositionBarsWithX:screenWidth()];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self refreshBarUserInterface];
                             
                             if (![_lastStatusBGView.backgroundColor isEqualToColor:_currentStatusBGView.backgroundColor]) {
                                 _lastStatusBGView.alpha = 0;
                                 _currentStatusBGView.alpha = 1.0 - _lastStatusBGView.alpha;
                             }
                             
                             if (![_lastNaviBGView.backgroundColor isEqualToColor:_currentNaviBGView.backgroundColor]) {
                                 _lastNaviBGView.alpha = 0;
                                 _currentNaviBGView.alpha = 1.0 - _lastNaviBGView.alpha;
                             }
                         }
                     }];
}

#pragma mark - Override

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (!viewController || _isGestureMoving) {
        return;
    }
    
    [super pushViewController:viewController animated:animated];
    
    // Reset bars
    UViewController *controller = [self controllerWith:viewController];
    [self refreshViewController:controller withPush:YES];
    
    if (animated) {
        // Push animation
        [self pushAnimation];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if (_isGestureMoving) {
        return nil;
    }
    
    NSInteger count = _viewController.countOfControllerToPop;
    NSInteger index = self.viewControllers.count - count - 1;
    if (index >= 0) {
        // Callback
        if (_viewController && [_viewController respondsToSelector:@selector(controllerWillPop)]) {
            [_viewController controllerWillPop];
        }
        
        UIViewController *controller = self.viewControllers[index];
        [super popToViewController:controller animated:animated];
        
        if (animated) {
            // Pop animation
            [self popAnimation];
        } else {
            UIViewController *controller = [self.viewControllers lastObject];
            UViewController *theController = [self controllerWith:controller];
            [self refreshViewController:theController withPush:NO];
        }
        
        return controller;
    }
    
    return nil;
}

#pragma mark - Action

- (void)panAction:(UIGestureRecognizer *)recognizer
{
    if (self.viewControllers.count == 1) {
        return;
    }
    
    CGPoint point = [recognizer locationInView:self.view];
    if (CGPointEqualToPoint(_startPoint, CGPointZero)) {
        _startPoint = point;
    }
    
    // Offset for gesture
    CGFloat offsetX = point.x - _startPoint.x;
    
    // Gesture state action
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _startPoint = point;
        _isGestureMoving = YES;
        
        // Callback
        if (_viewController && [_viewController respondsToSelector:@selector(controllerWillMove)]) {
            [_viewController controllerWillMove];
        }
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        _isGestureMoving = NO;
    } else if (recognizer.state == UIGestureRecognizerStateCancelled) {
        _isGestureMoving = NO;
    }
    
    if (_isGestureMoving) {
        [self repositionAllViewWithX:offsetX];
    } else {
        if (offsetX > screenWidth() * 0.25) {
            [self popAnimationWithX:offsetX];
        } else {
            [self rollbackAnimationWithX:offsetX];
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self.view];
    if ([self isValidateInPoint:point]) {
        NSInteger count = self.viewControllers.count;
        if (count == 1) {
            return NO;
        }
        
        NSString *className = NSStringFromClass(touch.view.class);
        if ([className isEqualToString:@"UIButton"]) {
            return NO;
        }

        return YES;
    }
    
    return NO;
}

@end

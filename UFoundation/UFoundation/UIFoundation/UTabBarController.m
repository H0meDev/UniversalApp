//
//  BaseTabBarController.m
//  UFoundation
//
//  Created by Think on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UDefines.h"
#import "NSObject+UAExtension.h"
#import "UTabBarController.h"
#import "UNavigationController.h"

@interface UTabBarController ()

@end

@implementation UTabBarController

@synthesize tabBarView = _tabBarView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = sysClearColor();
    
    if (systemVersionFloat() >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Layout
    [self customizeLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (UTabBarView *)tabBarView
{
    if (_tabBarView) {
        return _tabBarView;
    }
    
    UTabBarView *tabBarView = [[UTabBarView alloc]init];
    tabBarView.userInteractionEnabled = YES;
    _tabBarView = tabBarView;
    
    // Customize tabBarView layout
    [self customizeLayout];
    
    // Hide original
    self.tabBar.hidden = YES;
    
    return _tabBarView;
}

- (UViewController *)viewController
{
    UIViewController *controller = self.selectedViewController;
    BOOL needsBreak = NO;
    while (!needsBreak) {
        if (!controller || checkClass(controller, UViewController)) {
            needsBreak = YES;
        } else if (checkClass(controller, UNavigationController)) {
            controller = ((UNavigationController *)controller).visibleViewController;
        } else if (checkClass(controller, UTabBarController)) {
            controller = ((UTabBarController *)controller).selectedViewController;
        }
    }
    
    return (UViewController *)controller;
}

- (void)setSelectedIndex:(NSUInteger)index
{
    [super setSelectedIndex:index];
    
    if (checkClass(self.navigationController, UNavigationController)) {
        UNavigationController *controller = (UNavigationController *)self.navigationController;
        [controller performWithName:@"refreshNavigationBarsUserInterface"];
    }
}

#pragma mark - Methods

- (void)customizeLayout
{
    if (_tabBarView) {
        CGFloat originY = screenHeight() - tabHeight();
        _tabBarView.frame = rectMake(0, originY, screenWidth(), tabHeight());
        [self.view addSubview:_tabBarView];
        [self.view bringSubviewToFront:_tabBarView];
    }
}

@end

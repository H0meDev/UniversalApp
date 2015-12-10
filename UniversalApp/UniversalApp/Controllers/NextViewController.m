//
//  NextViewController.m
//  UniversalApp
//
//  Created by Think on 15/8/27.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "NextViewController.h"
#import "LastViewController.h"

@interface NextViewController ()

@end

@implementation NextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBarView.title = @"Next";
//    self.statusBarView.backgroundColor = sysClearColor();
//    self.navigationBarView.backgroundColor = sysClearColor();
    self.containerView.backgroundColor = sysLightGrayColor();
    
//    UNavigationBarButton *rightButton = [UNavigationBarButton button];
//    rightButton.frame = rectMake(screenWidth() - 70, 0, 70, naviHeight() - naviBLineH());
//    [rightButton setHAlpha:0.3];
//    [rightButton setTitle:@"Option"];
//    [rightButton setTitleColor:sysWhiteColor()];
//    [rightButton setTitleFont:systemFont(16)];
//    [rightButton addTarget:self action:@selector(buttonAction)];
//    self.navigationBarView.rightButton = rightButton;
    
    CGFloat height = statusHeight() + naviHeight();
    UView *navigationView = [[UView alloc]init];
    navigationView.frame = rectMake(0, - height, screenWidth(), height);
    navigationView.backgroundColor = sysLightGrayColor();
    [self addSubview:navigationView];
    
    UBarButton *button = [UBarButton button];
    button.frame = rectMake(0, 160, screenWidth(), 50);
    [button setTitle:@"Push"];
    [button setTitleColor:sysWhiteColor()];
    [button setHTitleColor:sysLightGrayColor()];
    button.backgroundColor = sysRedColor();
    [button setTarget:self action:@selector(buttonAction)];
    [self addSubview:button];
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

- (void)buttonAction
{
    LastViewController *next = [[LastViewController alloc]init];
    [self pushViewController:next];
}

@end

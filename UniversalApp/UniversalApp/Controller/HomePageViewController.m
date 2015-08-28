//
//  HomePageViewController.m
//  UniversalApp
//
//  Created by Think on 15/8/26.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "HomePageViewController.h"
#import "NextViewController.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.enableBackButton = NO;
    self.navigationBarView.title = NSLocalizedString(@"HomePageTitle", /*首页*/);
    
    UButton *button = [UButton button];
    button.frame = rectMake(0, 160, screenWidth(), 50);
    [button setTitle:@"Push"];
    button.backgroundColor = sysRedColor();
    [button addTarget:self action:@selector(buttonAction)];
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
    NextViewController *next = [[NextViewController alloc]init];
    [self pushViewController:next];
}

@end

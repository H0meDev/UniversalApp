//
//  NextViewController.m
//  UniversalApp
//
//  Created by Think on 15/8/22.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "NextViewController.h"
#import "HomeViewController.h"

@interface NextViewController ()

@end

@implementation NextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBarView.title = @"下一页";
    
    UButton *button = [UButton customButton];
    button.frame = rectMake(100, 100, screenWidth() - 200, 40);
    button.backgroundColor = sysRedColor();
    [button setTitle:@"Push"];
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
    HomeViewController *home = [[HomeViewController alloc]init];
    [self pushViewController:home];
}

@end

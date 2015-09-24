//
//  CurrentViewController.m
//  UniversalApp
//
//  Created by Think on 15/9/24.
//  Copyright © 2015年 think. All rights reserved.
//

#import "CurrentViewController.h"
#import "NextViewController.h"

@interface CurrentViewController ()

@end

@implementation CurrentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.countOfControllerToPop = 1;
    self.navigationBarView.title = @"Curren";
    [self.navigationBarView.leftButton setTitle:@"Last"];
    self.statusBarView.backgroundColor = rgbaColor(231, 68, 113, 0.2);
    self.navigationBarView.backgroundColor = rgbaColor(231, 68, 113, 0.2);
    
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
    [next.navigationBarView.leftButton setTitle:self.navigationBarView.title];
    [self pushViewController:next];
}

@end

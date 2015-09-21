//
//  LeftPageViewController.m
//  UniversalApp
//
//  Created by Think on 15/8/30.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "LeftPageViewController.h"
#import "NextViewController.h"

@interface LeftPageViewController ()

@end

@implementation LeftPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.enableBackButton = NO;
    self.navigationBarView.title = @"Left";
    
    UButton *button = [UButton button];
    button.frame = rectMake(0, 160, screenWidth(), 50);
    [button setTitle:@"Push"];
    button.backgroundColor = sysRedColor();
    [button addTarget:self action:@selector(buttonAction)];
    [self addSubview:button];
    
//    UIView *layoutView = [[UIView alloc]init];
//    layoutView.frame = rectMake(0, 0, self.containerView.sizeWidth, self.containerView.sizeHeight - tabHeight());
//    layoutView.backgroundColor = sysRedColor();
//    [self addSubview:layoutView];
//    
//    UIViewLayoutParam *param = [UIViewLayoutParam param];
//    param.layoutType = UIViewLayoutTypeHLinearResizeAll;
//    param.edgeInsets = edgeMake(10, 10, 10, 10);
//    param.spacingHorizontal = 10;
//    param.spacingVertical = 10;
//    
//    NSMutableArray *marray = [NSMutableArray array];
//    for (int i = 0; i < 4; i ++) {
//        UIView *view = [[UIView alloc]init];
//        view.size = sizeMake(80, 80);
//        view.backgroundColor = sysYellowColor();
//        [marray addObject:view];
//    }
//    
//    param.layoutViews = marray;
//    layoutView.layoutParam = param;
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

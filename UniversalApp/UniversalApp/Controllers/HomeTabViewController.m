//
//  HomeTabViewController.m
//  UniversalApp
//
//  Created by Think on 15/8/26.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "HomeTabViewController.h"
#import "LeftPageViewController.h"
#import "MiddlePageViewController.h"
#import "RightPageViewController.h"

@interface HomeTabViewController ()
{
    NSArray *_tabButtons;
}

@end

@implementation HomeTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialize
        [self initTabControllers];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

#pragma mark - Methods

- (void)initTabControllers
{
    LeftPageViewController *left = [[LeftPageViewController alloc]init];
    MiddlePageViewController *middle = [[MiddlePageViewController alloc]init];
    RightPageViewController *right = [[RightPageViewController alloc]init];
    
    self.viewControllers = @[left, middle, right];
    
    // Tab bar
    NSArray *titles = @[@"左页", @"中页", @"右页"];
    NSMutableArray *buttons = [NSMutableArray array];
    
    CGFloat originX = 0;
    CGFloat width = screenWidth() / titles.count;
    for (int i = 0; i < titles.count; i ++) {
        UTabBarButton *button = [UTabBarButton button];
        button.tag = i;
        button.frame = rectMake(originX, tabBLineH(), width, tabHeight() - tabBLineH());
        [button setTitle:titles[i]];
        [button setTitleColor:sysDarkGrayColor()];
        [button setHTitleColor:sysDarkGrayColor()];
        [button setSTitleColor:sysRedColor()];
        [button setHTitleFont:boldSystemFont(18)];
        [button setSTitleFont:boldSystemFont(16)];
        [button setBackgroundColor:sysClearColor()];
        [button addTarget:self action:@selector(tabAction:)];
        [self.tabBarView addSubview:button];
        [buttons addObject:button];
        
        originX += width;
    }
    _tabButtons = buttons;
    
    // Default selection
    self.selectedIndex = 0;
}

- (void)setSelectedIndex:(NSUInteger)index
{
    [super setSelectedIndex:index];
    
    for (UTabBarButton *button in _tabButtons) {
        if (button.tag == index) {
            button.selected = YES;
        } else {
            button.selected = NO;
        }
    }
}

#pragma mark - Action

- (void)tabAction:(UTabBarButton *)button
{
    self.selectedIndex = button.tag;
}

@end

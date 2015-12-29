//
//  MiddlePageViewController.m
//  UniversalApp
//
//  Created by Think on 15/8/30.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "MiddlePageViewController.h"
#import "NextViewController.h"

@interface MiddlePageViewController () <UListTableViewDataSource, UListTableViewDelegate>
{
    UListTableView *_tableView;
}

@end

@implementation MiddlePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.enableBackButton = NO;
    self.navigationBarView.title = @"Middle";
    
    CGFloat height = self.containerView.sizeHeight - tabHeight();
    UListTableView *tableView = [[UListTableView alloc]initWith:UListViewStyleVertical];
    tableView.frame = rectMake(0, 0, screenWidth(), height);
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    _tableView = tableView;
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

- (NSInteger)numberOfSectionsInListView:(UListTableView *)tableView
{
    return 10;
}

- (NSInteger)tableView:(UListTableView *)tableView numberOftemsInSection:(NSInteger)section
{
    return 100;
}

- (CGFloat)tableView:(UListTableView *)tableView sizeValueForHeaderInSection:(NSInteger)section
{
    return 16;
}

- (CGFloat)tableView:(UListTableView *)tableView sizeValueForFooterInSection:(NSInteger)section
{
    if (section == 99) {
        return 16;
    }
    
    return 0;
}

- (UIView *)tableView:(UListTableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    @autoreleasepool
    {
        UIView *headerView = [[UIView alloc]init];
        headerView.backgroundColor = sysBrownColor();
        
        return headerView;
    }
}

- (UIView *)tableView:(UListTableView *)tableView viewForFooterInSection:(NSInteger)section
{
    @autoreleasepool
    {
        UIView *footerView = [[UIView alloc]init];
        footerView.backgroundColor = sysBrownColor();
        
        return footerView;
    }
}

- (CGFloat)tableView:(UListTableView *)tableView sizeValueForPath:(UIndexPath *)path
{
    return 80.;
}

- (UListTableViewCell *)tableView:(UListTableView *)tableView cellAtPath:(UIndexPath *)path
{
    NSLog(@"UListTableViewCell item %@ - %@", @(path.section), @(path.index));
    
    return [[UListTableViewCell alloc]initWith:tableView.style];
}

@end

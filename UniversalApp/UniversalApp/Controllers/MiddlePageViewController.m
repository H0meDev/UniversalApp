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
    BOOL _expand;
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
    UListTableView *tableView = [[UListTableView alloc]initWith:UListViewStyleHorizontal];
    tableView.frame = rectMake(0, 0, screenWidth(), height);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = sysClearColor();
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
    return 100;
}

- (NSInteger)tableView:(UListTableView *)tableView numberOftemsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UListTableView *)tableView sizeValueForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UListTableView *)tableView sizeValueForFooterInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UListTableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    @autoreleasepool
    {
        UButton *headerView = [UButton button];
        headerView.tag = section;
        [headerView setBackgroundColor:sysBlueColor()];
        [headerView setTarget:self action:@selector(sectionAction:)];
        
        return headerView;
    }
}

- (UIView *)tableView:(UListTableView *)tableView viewForFooterInSection:(NSInteger)section
{
    @autoreleasepool
    {
        UIView *footerView = [[UIView alloc]init];
        footerView.backgroundColor = sysRedColor();
        
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
    
    UListTableViewCell *cell = [[UListTableViewCell alloc]initWith:tableView.style];
    cell.backgroundColor = sysYellowColor();
    
    return cell;
}

- (void)sectionAction:(UIButton *)button
{
    _expand = !_expand;
    
    [_tableView reloadSection:button.tag];
}

@end

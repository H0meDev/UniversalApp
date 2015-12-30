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
    UListTableView *tableView = [[UListTableView alloc]initWith:UListViewStyleVertical];
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
    if (section == 1 && !_expand) {
        return 0;
    }
    
    return 10;
}

- (CGFloat)tableView:(UListTableView *)tableView sizeValueForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UListTableView *)tableView sizeValueForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UListTableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    @autoreleasepool
    {
        if (section == 1) {
            UButton *headerView = [UButton button];
            [headerView setBackgroundColor:sysBlueColor()];
            [headerView setTarget:self action:@selector(sectionAction)];
            return headerView;
        } else {
            UIView *headerView = [[UIView alloc]init];
            headerView.backgroundColor = sysRedColor();
            return headerView;
        }
        
        return nil;
    }
}

- (UIView *)tableView:(UListTableView *)tableView viewForFooterInSection:(NSInteger)section
{
    @autoreleasepool
    {
        UIView *footerView = [[UIView alloc]init];
        footerView.backgroundColor = rgbColor(25.5 * section, 25.5 * section, (section % 2 == 1)?0:255.);
        
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

- (void)sectionAction
{
    _expand = !_expand;
    
    [_tableView reloadSection:1];
}

@end

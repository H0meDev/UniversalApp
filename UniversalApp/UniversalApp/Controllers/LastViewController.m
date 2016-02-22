//
//  LastViewController.m
//  UniversalApp
//
//  Created by Think on 15/8/27.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "LastViewController.h"
#import "ListViewController.h"
#import "LastListItemCell.h"

@interface LastViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
}

@end

@implementation LastViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.countOfControllerToPop = 1;
    self.navigationBarView.title = @"Last";
    [self.navigationBarView.leftButton setTitle:@"Next"];
    
    [self.navigationBarView.leftButton setTitleColor:sysRedColor()];
    [self.navigationBarView.leftButton setImageWithColor:sysRedColor()];
    
    CGFloat height = self.containerView.sizeHeight;
    UITableView *tableView = [[UITableView alloc]init];
    tableView.frame = rectMake(0, 0, screenWidth(), height);
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    _tableView = tableView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    //
}

- (void)backAction
{
    [super backAction];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1000;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Load UITableViewCell %@", @(indexPath.row));
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.sizeHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LastListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LastListItemCell"];
    if (cell == nil) {
        cell = [[LastListItemCell alloc]initWithReuseIdentifier:@"LastListItemCell"];
    }
    
    NSDictionary *dict = nil;
    NSInteger rowValue = indexPath.row % 3;
    if (rowValue == 0) {
        dict = @{@"title":@"这是一段短文本",@"content":@"这是一段短文本"};
    } else if (rowValue == 1) {
        dict = @{@"title":@"这是一段中文本",@"content":@"这是一段中文本，这是一段中文本,这是一段中文本，这是一段中文本，这是一段中文本，这是一段中文本"};
    } else if (rowValue == 2) {
        dict = @{@"title":@"这是一段长文本",@"content":@"这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本"};
    }
    
    [cell setCellData:dict];
    
//    NSLog(@"Load UITableViewCell %@", @(indexPath.row));
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ListViewController *list = [[ListViewController alloc]init];
    [list.navigationBarView.leftButton setTitle:self.navigationBarView.title];
    [self pushViewController:list];
}

@end

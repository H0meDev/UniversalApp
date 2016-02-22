//
//  ListViewController.m
//  UniversalApp
//
//  Created by Think on 15/12/7.
//  Copyright © 2015年 think. All rights reserved.
//

#import "ListViewController.h"
#import "ListItemCell.h"

@interface ListViewController () <UListViewDelegate, UListViewDataSource>
{
    UListView *_listView;
}

@end

@implementation ListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBarView.title = @"List";
    
    self.statusBarView.backgroundColor = sysWhiteColor();
    self.navigationBarView.backgroundColor = sysWhiteColor();
    
    CGFloat height = self.containerView.sizeHeight;
    _listView = [[UListView alloc]initWith:UListViewStyleVertical];
    _listView.tag = 1;
    _listView.frame = rectMake(0, 0, screenWidth(), height);
    _listView.delegate = self;
    _listView.dataSource = self;
    _listView.cancelable = NO;
    _listView.multipleSelected = NO;
    [self addSubview:_listView];
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

#pragma mark -  UListViewDataSource & UListViewDelegate

- (NSInteger)numberOfItemsInListView:(UListView *)listView
{
    return 1000;
}

- (CGFloat)listView:(UListView *)listView sizeValueForIndex:(NSInteger)index
{
    UListViewCell *cell = [self listView:listView cellAtIndex:index];
    return cell.sizeHeight;
}

- (UListViewCell *)listView:(UListView *)listView cellAtIndex:(NSInteger)index
{
    ListItemCell *cell = (ListItemCell *)[listView dequeueReusableCellWithIdentifier:@"ListItemCell"];
    if (!cell) {
        cell = (ListItemCell *)[listView cellReuseWith:@"ListItemCell" forIdentifier:@"ListItemCell"];
    }
    
    NSDictionary *dict = nil;
    NSInteger rowValue = index % 3;
    if (rowValue == 0) {
        dict = @{@"title":@"这是一段短文本",@"content":@"这是一段短文本"};
    } else if (rowValue == 1) {
        dict = @{@"title":@"这是一段中文本",@"content":@"这是一段中文本，这是一段中文本,这是一段中文本，这是一段中文本，这是一段中文本，这是一段中文本"};
    } else if (rowValue == 2) {
        dict = @{@"title":@"这是一段长文本",@"content":@"这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本"};
    }
    
    [cell setCellData:dict];
    
    NSLog(@"Load UListViewCell %@", @(index));
    
    return cell;
}

- (void)listView:(UListView *)listView didSelectCellAtIndex:(NSInteger)index
{
    NSLog(@"UListViewCell selected %@", @(index));
    
    [listView deselectCellAtIndex:index];
    
    ListViewController *list = [[ListViewController alloc]init];
    [list.navigationBarView.leftButton setTitle:self.navigationBarView.title];
    [self pushViewController:list];
}

- (void)listView:(UListView *)listView didDeselectCellAtIndex:(NSInteger)index
{
    NSLog(@"UListViewCell deselected %@", @(index));
}

@end

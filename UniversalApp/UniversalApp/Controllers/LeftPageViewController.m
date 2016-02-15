//
//  LeftPageViewController.m
//  UniversalApp
//
//  Created by Think on 15/8/30.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "LeftPageViewController.h"
#import "NextViewController.h"
#import "LeftListItemCell.h"

@interface LeftPageViewController () <UListViewDataSource, UListViewDelegate>
{
    UListView *_listView;
    NSArray *_dataList;
}

@end

@implementation LeftPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.enableBackButton = NO;
    self.navigationBarView.title = @"Left";
    
    UButton *rightView = [UButton button];
    rightView.selected = YES;
    rightView.frame = rectMake(screenWidth() - 60, 0, 60, naviHeight());
    [rightView setTitle:@"Option"];
    [rightView setTitleColor:sysBlackColor()];
    [rightView setTitleFont:systemFont(16)];
    [rightView setTarget:self action:@selector(buttonAction:)];
    self.navigationBarView.rightView = rightView;
    
    CGFloat height = self.containerView.sizeHeight - tabHeight();
    _listView = [[UListView alloc]initWith:UListViewStyleHorizontal];
    _listView.frame = rectMake(0, 0, screenWidth(), height);
    _listView.delegate = self;
    _listView.dataSource = self;
    _listView.cancelable = YES;
    _listView.multipleSelected = YES;
    [self addSubview:_listView];
    
    _dataList = @[@"http://www.xiaoxiongbizhi.com/wallpapers/1920_1200_85/y/w/ywzwdjof0.jpg",
                  @"http://www.xiaoxiongbizhi.com/wallpapers/1920_1200_85/y/g/ygjngsyu0.jpg",
                  @"http://www.xiaoxiongbizhi.com/wallpapers/1920_1200_85/y/o/yoczvk12l.jpg",
                  @"http://www.xiaoxiongbizhi.com/wallpapers/1920_1200_85/1/1/11rokrbk1.jpg",
                  @"http://www.xiaoxiongbizhi.com/wallpapers/1920_1200_85/1/3/133hlkh8y.jpg",
                  @"http://www.xiaoxiongbizhi.com/wallpapers/1920_1200_85/1/3/13arkybo4.jpg",
                  @"http://www.xiaoxiongbizhi.com/wallpapers/1920_1200_85/1/6/169a41rlj.jpg",
                  @"http://www.xiaoxiongbizhi.com/wallpapers/1920_1200_85/1/6/16htzbdrp.jpg",
                  @"http://www.xiaoxiongbizhi.com/wallpapers/1920_1200_85/1/6/16pkkxz7p.jpg",
                  @"http://www.xiaoxiongbizhi.com/wallpapers/1920_1200_85/1/9/19j8uqb10n.jpg",
                  @"http://www.xiaoxiongbizhi.com/wallpapers/1920_1200_85/1/9/19r0an0jm.jpg",
                  @"http://www.xiaoxiongbizhi.com/wallpapers/1920_1200_85/1/9/19yhu49sq.jpg",
                  @"http://www.xiaoxiongbizhi.com/wallpapers/1920_1200_85/1/g/1gz8lq6a4.jpg",
                  @"http://www.xiaoxiongbizhi.com/wallpapers/1920_1200_85/1/h/1h8l5bv9s.jpg"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)buttonAction:(UButton *)button
{
    [UHTTPImage removeAllCaches];
    [_listView reloadData];
}

- (void)headerAction
{
    [UTimerBooster addTarget:self sel:@selector(finishHeaderRefresh) time:3.0];
}

- (void)footerAction
{
    [UTimerBooster addTarget:self sel:@selector(finishFooterRefresh) time:3.0];
}

#pragma mark -  UListViewDataSource & UListViewDelegate

- (NSInteger)numberOfItemsInListView:(UListView *)listView
{
    return 10000;
}

- (CGFloat)listView:(UListView *)listView sizeValueForIndex:(NSInteger)index
{
    if (listView.style == UListViewStyleHorizontal) {
        return screenWidth();
    }
    
    return 200;
}

- (UListViewCell *)listView:(UListView *)listView cellAtIndex:(NSInteger)index
{
    LeftListItemCell *cell = (LeftListItemCell *)[listView dequeueReusableCellWithIdentifier:@"LeftListItemCell"];
    if (!cell) {
        cell = (LeftListItemCell *)[listView cellReuseWith:@"LeftListItemCell" forIdentifier:@"LeftListItemCell"];
    }
    
    NSInteger indexValue = index % _dataList.count;
    [cell setCellData:_dataList[indexValue]];
    
    NSLog(@"Load item %@", @(index));
    
    return cell;
}

- (void)listView:(UListView *)listView didSelectCellAtIndex:(NSInteger)index
{
    [listView deselectCellAtIndex:index];
    
    NSLog(@"UListViewCell selected %@", @(index));
}

- (void)listView:(UListView *)listView didDeselectCellAtIndex:(NSInteger)index
{
    NSLog(@"UListViewCell deselected %@", @(index));
}

@end

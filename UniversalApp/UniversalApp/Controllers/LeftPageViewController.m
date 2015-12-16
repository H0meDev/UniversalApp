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
    
//    UButton *rightView = [UButton button];
//    rightView.selected = YES;
//    rightView.frame = rectMake(screenWidth() - 68, 0, 60, naviHeight());
//    [rightView setTitle:@"Option"];
//    [rightView setTitleColor:sysBlackColor()];
//    [rightView setTitleFont:systemFont(16)];
//    [rightView setTarget:self action:@selector(buttonAction:)];
//    self.navigationBarView.rightView = rightView;
    
    CGFloat height = self.containerView.sizeHeight - tabHeight();
    _listView = [[UListView alloc]initWith:UListViewStyleVertical];
    _listView.frame = rectMake(0, 0, screenWidth(), height);
    _listView.delegate = self;
    _listView.dataSource = self;
    [self addSubview:_listView];
    
    _dataList = @[@"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png",
                  @"http://jiangsu.china.com.cn/uploadfile/2015/1210/1449719387615370.jpg",
                  @"http://gz.sese.com.cn/share/upload/20151117/0bf7affd-549d-476d-aed3-bb2bd354433b.jpg",
                  @"http://image.fvideo.cn/uploadfile/2012/03/15/20120315110710016.jpg",
                  @"http://news.cz001.com.cn/attachement/jpg/site2/20120614/d067e519eae31143846013.jpg"];
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
    return 1000;
}

- (CGFloat)listView:(UListView *)listView sizeValueForIndex:(NSInteger)index
{
    if (listView.style == UListViewStyleHorizontal) {
        return listView.sizeWidth / 3.;
    } else {
        return listView.sizeHeight / 3.;
    }
}

- (UListViewCell *)listView:(UListView *)listView cellAtIndex:(NSInteger)index
{
    LeftListItemCell *cell = (LeftListItemCell *)[listView dequeueReusableCellWithIdentifier:@"LeftListItemCell"];
    if (!cell) {
        [listView registerCell:@"LeftListItemCell" forIdentifier:@"LeftListItemCell"];
        cell = (LeftListItemCell *)[listView dequeueReusableCellWithIdentifier:@"LeftListItemCell"];
    }
    
//    NSInteger indexValue = index % _dataList.count;
    [cell setCellData:_dataList[0]];
    
    NSLog(@"Load item %@", @(index));
    
    return cell;
}

- (void)listView:(UListView *)listView didSelectCellAtIndex:(NSInteger)index
{
//    [listView deselectCellAtIndex:index];
    
    NSLog(@"UListViewCell selected %@", @(index));
}

- (void)listView:(UListView *)listView didDeselectCellAtIndex:(NSInteger)index
{
    NSLog(@"UListViewCell deselected %@", @(index));
}

@end

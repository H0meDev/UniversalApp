//
//  LeftPageViewController.m
//  UniversalApp
//
//  Created by Think on 15/8/30.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "LeftPageViewController.h"
#import "NextViewController.h"

@interface LeftPageViewController () <UListViewDataSource, UListViewDelegate>
{
    UListView *_listView;
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
    rightView.frame = rectMake(screenWidth() - 68, 0, 60, naviHeight());
    [rightView setTitle:@"Option"];
    [rightView setTitleColor:sysBlackColor()];
    [rightView setTitleFont:systemFont(16)];
    [rightView addTarget:self action:@selector(buttonAction:)];
    self.navigationBarView.rightView = rightView;
    
    CGFloat height = self.containerView.sizeHeight - tabHeight();
    _listView = [[UListView alloc]initWithStyle:UListViewStyleVertical];
    _listView.frame = rectMake(0, 0, screenWidth(), height);
    _listView.delegate = self;
    _listView.dataSource = self;
    [_listView addHeaderTarget:self action:@selector(headerAction)];
    [_listView addFooterTarget:self action:@selector(footerAction)];
    [self addSubview:_listView];
    
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

- (void)finishHeaderRefresh
{
    [_listView performOnMainThread:@selector(finishHeaderRefresh)];
}

- (void)finishFooterRefresh
{
    [_listView performOnMainThread:@selector(finishFooterRefresh)];
}

#pragma mark -  UListViewDataSource & UListViewDelegate

- (NSInteger)numberOfItemsInListView:(UListView *)listView
{
    return 1000;
}

- (CGFloat)listView:(UListView *)listView heightOrWidthForIndex:(NSInteger)index
{
    if (listView.style == UListViewStyleHorizontal) {
        return listView.sizeWidth / 3.;
    } else {
        return listView.sizeHeight / 3.;
    }
}

- (UListViewCell *)listView:(UListView *)listView cellAtIndex:(NSInteger)index
{
    UListViewCell *cell = [listView dequeueReusableCellWithIdentifier:@"UListViewCell"];
    if (!cell) {
        [listView registerCell:@"UListViewCell" forIdentifier:@"UListViewCell"];
        cell = [listView dequeueReusableCellWithIdentifier:@"UListViewCell"];
    }
    
    cell.backgroundColor = rgbColor((index % 2) * 200, 0, 0);
    
    NSLog(@"Load item %@", @(index));
    
    return cell;
}

@end

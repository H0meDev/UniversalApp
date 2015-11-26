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
    
    _listView = [[UListView alloc]initWithStyle:UListViewStyleHorizontal];
    _listView.frame = rectMake(0, 0, screenWidth(), 300);
    _listView.dataSource = self;
    _listView.delegate = self;
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

#pragma mark -  UListViewDataSource & UListViewDelegate

- (NSInteger)numberOfRowInListView:(UListView *)listView
{
    return 100;
}

- (CGFloat)listView:(UListView *)listView heightOrWidthForIndex:(NSInteger)index
{
    return 100;
}

- (UListViewCell *)listView:(UListView *)listView cellAtIndex:(NSInteger)index
{
    UListViewCell *cell = [listView dequeueReusableCellWithIdentifier:@"UListViewCell"];
    if (!cell) {
        cell = [UListViewCell cell];
        [listView reuseCell:cell forIdentifier:@"UListViewCell"];
    }
    
    return cell;
}

@end

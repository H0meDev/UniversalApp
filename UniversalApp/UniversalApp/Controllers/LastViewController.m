//
//  LastViewController.m
//  UniversalApp
//
//  Created by Think on 15/8/27.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "LastViewController.h"
#import "ListViewController.h"

@interface LastViewController () <UTableViewDefaultDelegate>
{
    UTableView *_tableView;
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
//    self.statusBarView.backgroundColor = [sysBlueColor() setAlphaValue:0.3];
//    self.navigationBarView.backgroundColor = [sysBlueColor() setAlphaValue:0.3];
   
    UButton *rightView = [UButton button];
    rightView.selected = YES;
    rightView.frame = rectMake(screenWidth() - 68, 0, 60, naviHeight());
    [rightView setTitle:@"Option"];
    [rightView setTitleColor:sysBlackColor()];
    [rightView setTitleFont:systemFont(16)];
    [rightView addTarget:self action:@selector(buttonAction:)];
    self.navigationBarView.rightView = rightView;
    
    UTableView *tableView = [[UTableView alloc]init];
    tableView.frame = rectMake(0, - 64, screenWidth(), screenHeight());
    tableView.contentInset = edgeMake(64, 0, 0, 0);
    tableView.scrollIndicatorInsets = edgeMake(64, 0, 0, 0);
    tableView.defaultDelegate = self;
//    [tableView addHeaderTarget:self action:@selector(headerAction:)];
//    [tableView addFooterTarget:self action:@selector(footerAction:)];
    [self addSubview:tableView];
    _tableView = tableView;
    
    // KVO
    [self addKeyValueObject:_tableView keyPath:@"contentOffset"];
    
    UTableViewDataSection *section = [UTableViewDataSection section];
    for (int i = 0; i < 1000; i ++) {
        UTableViewDataRow *row = [UTableViewDataRow row];
        row.cellHeight = -1;
        row.cellName = @"LastListItemCell";
        
        NSInteger rowValue = i % 3;
        if (rowValue == 0) {
            row.cellData = @{@"title":@"这是一段短文本",@"content":@"这是一段短文本"};
        } else if (rowValue == 1) {
            row.cellData = @{@"title":@"这是一段中文本",@"content":@"这是一段中文本，这是一段中文本,这是一段中文本，这是一段中文本，这是一段中文本，这是一段中文本"};
        } else if (rowValue == 2) {
            row.cellData = @{@"title":@"这是一段长文本",@"content":@"这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本"};
        }
        
        [section addRow:row];
    }
    
    tableView.sectionArray = @[section];
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

- (void)receivedKVObserverValueForKayPath:(NSString *)keyPath
                                 ofObject:(id)object
                                   change:(NSDictionary *)change
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        //
    }
}

- (void)dealloc
{
    [_tableView removeHeaderView];
    [_tableView removeFooterView];
}

- (void)controllerWillMove
{
    [_tableView finishHeaderRefresh];
    [_tableView finishFooterRefresh];
}

- (void)backAction
{
    [super backAction];
    
    [_tableView finishHeaderRefresh];
    [_tableView finishFooterRefresh];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)headerAction:(UIScrollView *)scrollView
{
    [UTimerBooster addTarget:scrollView sel:@selector(finishHeaderRefresh) time:3.0];
}

- (void)footerAction:(UIScrollView *)scrollView
{
    [UTimerBooster addTarget:scrollView sel:@selector(finishFooterRefresh) time:3.0];
}

- (void)buttonAction:(UIButton *)button
{
    button.selected = !button.selected;
    
    _tableView.headerEnable = button.selected;
    _tableView.footerEnable = button.selected;
}

- (void)tableView:(UTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ListViewController *list = [[ListViewController alloc]init];
    [list.navigationBarView.leftButton setTitle:self.navigationBarView.title];
    [self pushViewController:list];
}

@end

//
//  LastViewController.m
//  UniversalApp
//
//  Created by Think on 15/8/27.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "LastViewController.h"
#import "CurrentViewController.h"

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
//    self.statusBarView.backgroundColor = rgbaColor(231, 68, 113, 0.2);
//    self.navigationBarView.backgroundColor = rgbaColor(231, 68, 113, 0.2);
    
//    self.statusBarView.backgroundColor = sysClearColor();
//    self.navigationBarView.backgroundColor = sysClearColor();
    
//    UILabel *leftView = [[UILabel alloc]init];
//    leftView.frame = rectMake(8, 0, 60, naviHeight());
//    leftView.text = @"Next";
//    leftView.textColor = sysWhiteColor();
//    self.navigationBarView.leftView = leftView;
//    
//    UILabel *centerView = [[UILabel alloc]init];
//    centerView.frame = rectMake(0, 0, 100, naviHeight());
//    centerView.text = @"Last";
//    centerView.textColor = sysWhiteColor();
//    centerView.textAlignment = NSTextAlignmentCenter;
//    self.navigationBarView.centerView = centerView;
//    
    UButton *rightView = [UButton button];
    rightView.selected = YES;
    rightView.frame = rectMake(screenWidth() - 68, 0, 60, naviHeight());
    [rightView setTitle:@"Option"];
    [rightView setTitleColor:sysBlackColor()];
    [rightView setTitleFont:systemFont(16)];
    [rightView addTarget:self action:@selector(buttonAction:)];
    self.navigationBarView.rightView = rightView;
    
//    UButton *button = [UButton button];
//    button.frame = rectMake(0, 160, screenWidth(), 50);
//    [button setTitle:@"Push"];
//    button.backgroundColor = sysRedColor();
//    [button addTarget:self action:@selector(buttonAction)];
//    [self addSubview:button];
    
    UTableView *tableView = [[UTableView alloc]init];
    tableView.frame = rectMake(0, 0, screenWidth(), screenHeight() - 64);
    tableView.contentInset = edgeMake(0, 0, 0, 0);
    tableView.scrollIndicatorInsets = edgeMake(0, 0, 0, 0);
    tableView.defaultDelegate = self;
    [tableView addHeaderTarget:self action:@selector(headerAction:)];
    [tableView addFooterTarget:self action:@selector(footerAction:)];
    [self addSubview:tableView];
    _tableView = tableView;
    
    // Start refresh
//    [tableView startHeaderRefresh];
    
    // KVO
    [self addKeyValueObject:_tableView keyPath:@"contentOffset"];
    
    NSMutableArray *sectionArray = [NSMutableArray array];
    for (int i = 0; i < 10; i ++) {
        UTableViewDataSection *section = [UTableViewDataSection section];
        for (int j = 0; j < 3; j ++) {
            UTableViewDataRow *row = [UTableViewDataRow row];
            row.cellHeight = -1;
            row.cellName = @"LastListItemCell";
            
            if (j == 0) {
                row.cellData = @{@"title":@"这是一段短文本",@"content":@"这是一段短文本"};
            } else if (j == 1) {
                row.cellData = @{@"title":@"这是一段中文本",@"content":@"这是一段中文本，这是一段中文本,这是一段中文本，这是一段中文本，这是一段中文本，这是一段中文本"};
            } else if (j == 2) {
                row.cellData = @{@"title":@"这是一段长文本",@"content":@"这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本，这是一段长文本"};
            }
            
            [section addRow:row];
        }
        
        if (i > 0) {
            section.headerHeight = 5;
        }
        
        if (i < 9) {
            section.footerHeight = 5;
        }
        
        [sectionArray addObject:section];
    }
    
    tableView.sectionArray = sectionArray;
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
        CGPoint offset = [change[@"new"] CGPointValue];
        CGFloat alpha = fabs(offset.y / 320);
        alpha = (alpha < 0)?0:alpha;
        alpha = (alpha > 1)?1:alpha;
        
//        dispatch_async(main_queue(), ^{
//            UIColor *color = rgbaColor(0, 255, 0, alpha);
//            self.statusBarView.backgroundColor = color;
//            self.navigationBarView.backgroundColor = color;
//        });
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
//    scrollView.headerEnable = NO;
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
    
    CurrentViewController *current = [[CurrentViewController alloc]init];
    [current.navigationBarView.leftButton setTitle:self.navigationBarView.title];
    [self pushViewController:current];
}

@end

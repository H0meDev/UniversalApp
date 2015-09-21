//
//  LastViewController.m
//  UniversalApp
//
//  Created by Think on 15/8/27.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "LastViewController.h"
#import "NextViewController.h"

@interface LastViewController () <UTableViewDefaultDelegate>

@end

@implementation LastViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.countOfControllerToPop = 1;
    self.navigationBarView.title = @"Last";
    [self.navigationBarView.leftButton setTitle:@"Next"];
    
    UILabel *leftView = [[UILabel alloc]init];
    leftView.frame = rectMake(8, 0, 60, naviHeight());
    leftView.text = @"Next";
    leftView.textColor = sysWhiteColor();
    self.navigationBarView.leftView = leftView;
    
    UILabel *centerView = [[UILabel alloc]init];
    centerView.frame = rectMake(0, 0, 100, naviHeight());
    centerView.text = @"Last";
    centerView.textColor = sysWhiteColor();
    centerView.textAlignment = NSTextAlignmentCenter;
    self.navigationBarView.centerView = centerView;
    
    UILabel *rightView = [[UILabel alloc]init];
    rightView.frame = rectMake(screenWidth() - 68, 0, 60, naviHeight());
    rightView.text = @"Option";
    rightView.textColor = sysWhiteColor();
    rightView.textAlignment = NSTextAlignmentRight;
    self.navigationBarView.rightView = rightView;
    
//    UButton *button = [UButton button];
//    button.frame = rectMake(0, 160, screenWidth(), 50);
//    [button setTitle:@"Push"];
//    button.backgroundColor = sysRedColor();
//    [button addTarget:self action:@selector(buttonAction)];
//    [self addSubview:button];
    
    UTableView *tableView = [[UTableView alloc]init];
    tableView.frame = rectMake(0, 0, screenWidth(), self.containerView.sizeHeight);
    tableView.defaultDelegate = self;
    [self addSubview:tableView];
    
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

- (void)buttonAction
{
    NextViewController *next = [[NextViewController alloc]init];
    [next.navigationBarView.leftButton setTitle:self.navigationBarView.title];
    [self pushViewController:next];
}

- (void)tableView:(UTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NextViewController *next = [[NextViewController alloc]init];
    [next.navigationBarView.leftButton setTitle:self.navigationBarView.title];
    [self pushViewController:next];
}

@end

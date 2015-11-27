//
//  UTableViewController.h
//  UFoundation
//
//  Created by Think on 15/9/19.
//  Copyright © 2015年 think. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UViewController.h"

@interface UTableViewController : UViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, readonly, strong) UITableView *tableView;

@end

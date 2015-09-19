//
//  BaseTableView.h
//  UFoundation
//
//  Created by Think on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UTableViewCell.h"

@interface UTableView : UITableView

@end

@interface UTableViewDataRow : NSObject

@property (nonatomic, strong) NSString *cellName;
@property (nonatomic, assign) CGFloat cellHeight; // - 1 autoresize
@property (nonatomic, strong) id cellData;
@property (nonatomic, assign) UITableViewCellStyle style;

+ (UTableViewDataRow *)row;

@end

@interface UTableViewDataSection : NSObject

@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;

// UTableViewDataRow array for cell rows
@property (nonatomic, readonly) NSArray *rowArray;

+ (UTableViewDataSection *)section;

// Add row
- (void)addRow:(UTableViewDataRow *)row;

@end

@protocol UTableViewDefaultDelegate <NSObject>

@optional
- (void)tableView:(UTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UTableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface UTableView (UTableViewDefault) <UITableViewDataSource, UITableViewDelegate>

// UTableViewDataSection array for cell sections
- (NSArray *)sectionArray;
- (void)setSectionArray:(NSArray *)sectionArray;

// Delegate for default
- (id<UTableViewDefaultDelegate>)defaultDelegate;
- (void)setDefaultDelegate:(id<UTableViewDefaultDelegate>)delegate;

@end

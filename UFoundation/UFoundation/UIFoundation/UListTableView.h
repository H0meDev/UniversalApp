//
//  UListTableView.h
//  UFoundation
//
//  Created by Think on 15/12/29.
//  Copyright © 2015年 think. All rights reserved.
//

#import "UListView.h"

@interface UIndexPath : NSObject

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger index;

+ (id)path;

@end

@class UListTableView;
@class UListTableViewCell;

@protocol UListTableViewDataSource <NSObject>

@required
- (NSInteger)numberOfSectionsInListView:(UListTableView *)tableView;
- (NSInteger)tableView:(UListTableView *)tableView numberOftemsInSection:(NSInteger)section;
- (UListTableViewCell *)tableView:(UListTableView *)tableView cellAtPath:(UIndexPath *)path;
- (UIView *)tableView:(UListTableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (UIView *)tableView:(UListTableView *)tableView viewForFooterInSection:(NSInteger)section;

@end

@protocol UListTableViewDelegate <NSObject>

@required
- (CGFloat)tableView:(UListTableView *)tableView sizeValueForPath:(UIndexPath *)path;

@optional
- (void)tableView:(UListTableView *)tableView didSelectCellAtPath:(UIndexPath *)path;
- (void)tableView:(UListTableView *)tableView didDeselectCellAtPath:(UIndexPath *)path;
- (CGFloat)tableView:(UListTableView *)tableView sizeValueForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(UListTableView *)tableView sizeValueForFooterInSection:(NSInteger)section;

@end

@interface UListTableViewCell : UListViewCell

@end

@interface UListTableView : UIView

@property (nonatomic, weak) id<UListTableViewDelegate> delegate;
@property (nonatomic, weak) id<UListTableViewDataSource> dataSource;
@property (nonatomic, readonly) UListViewStyle style;
@property (nonatomic, assign) UListViewCellSepratorLineStyle separatorStyle; // Default is UListViewCellSepratorLineStyleNone

- (id)initWith:(UListViewStyle)style;
- (id)initWithFrame:(CGRect)frame style:(UListViewStyle)style;

- (void)reloadData;

@end

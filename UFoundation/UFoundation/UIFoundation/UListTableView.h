//
//  UListTableView.h
//  UFoundation
//
//  Created by Think on 15/12/29.
//  Copyright © 2015年 think. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UDefines.h"

typedef NS_ENUM(NSInteger, UListTableViewStyle)
{
    UListTableViewStyleVertical = 0,
    UListTableViewStyleHorizontal,
};

typedef NS_ENUM(NSInteger, UListTableViewCellSepratorLineStyle)
{
    UListTableViewCellSepratorLineStyleNone = 0,
    UListTableViewCellSepratorLineStyleNoEnds,
    UListTableViewCellSepratorLineStyleFull,
};

@interface UIndexPath : NSObject

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger index;

+ (id)path;
- (BOOL)isEqualsToPath:(UIndexPath *)path;

@end

@class UListTableView;
@class UListTableViewCell;

@protocol UListTableViewDataSource <NSObject>

@required
- (NSInteger)numberOfSectionsInListView:(UListTableView *)tableView;
- (NSInteger)tableView:(UListTableView *)tableView numberOftemsInSection:(NSInteger)section;
- (UListTableViewCell *)tableView:(UListTableView *)tableView cellAtPath:(UIndexPath *)path;

@optional
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

@interface UListTableViewCell : UIView

@property (nonatomic, readonly) UListTableViewStyle style;    // Default style is UListTableViewStyleVertical
@property (nonatomic, strong) UIColor *highlightedColor; // Color of highlighted and selected
@property (nonatomic, readonly) BOOL selected;

+ (id)cell; // Default style is UListTableViewStyleVertical
- (id)initWith:(UListTableViewStyle)style; // The style must be consistent with UListTableView

// To be overrided
- (void)cellDidLoad;       // For initialization
- (void)cellNeedsUpdate;   // For update option if reuseable
- (void)cellDidSelected;   // For selected option
- (void)cellDidDeselected; // For deselected option

@end

@interface UListTableView : UIView

@property (nonatomic, weak) id<UListTableViewDelegate> delegate;
@property (nonatomic, weak) id<UListTableViewDataSource> dataSource;
@property (nonatomic, readonly) UListTableViewStyle style;
@property (nonatomic, assign) UListTableViewCellSepratorLineStyle separatorStyle; // Default is UListViewCellSepratorLineStyleNone
@property (nonatomic, assign) BOOL multipleSelected; // Default is NO
@property (nonatomic, assign) BOOL cancelable;       // Default is NO
@property (nonatomic, readonly) NSArray *selectedIndexs;

- (id)initWith:(UListTableViewStyle)style;
- (id)initWithFrame:(CGRect)frame style:(UListTableViewStyle)style;

// Cell reuse
- (UListTableViewCell *)cellReuseWith:(NSString *)cellName forIdentifier:(NSString *)identifier;
- (UListTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

// Refresh
- (void)reloadData;
- (void)reloadDataWith:(CGPoint)offset;
- (void)reloadSection:(NSInteger)section;

// Selection
- (void)deselectCellAtPath:(UIndexPath *)path;
- (void)deselectCellAtPath:(UIndexPath *)path animated:(BOOL)animated;

// Move
- (void)moveToPath:(UIndexPath *)path;
- (void)moveToPath:(UIndexPath *)path animated:(BOOL)animated;

@end

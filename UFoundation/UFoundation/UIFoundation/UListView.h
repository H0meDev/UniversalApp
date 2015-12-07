//
//  UListView.h
//  UFoundation
//
//  Created by Think on 15/11/26.
//  Copyright © 2015年 think. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UListViewStyle)
{
    UListViewStyleVertical = 0,
    UListViewStyleHorizontal,
};

typedef NS_ENUM(NSInteger, UListViewCellSepratorLineStyle)
{
    UListViewCellSepratorLineStyleNone = 0,
    UListViewCellSepratorLineStyleNoEnds,
    UListViewCellSepratorLineStyleFull,
};

@class UListView;
@class UListViewCell;

@protocol UListViewDataSource <NSObject>

@required
- (NSInteger)numberOfItemsInListView:(UListView *)listView;
- (UListViewCell *)listView:(UListView *)listView cellAtIndex:(NSInteger)index;

@end

@protocol UListViewDelegate <NSObject>

@required
- (CGFloat)listView:(UListView *)listView sizeValueForIndex:(NSInteger)index;

@end

@interface UListViewCell : UIView

@property (nonatomic, readonly) UListViewStyle style; // Default style is UListViewStyleVertical

+ (id)cell; // Default style is UListViewStyleVertical
- (id)initWith:(UListViewStyle)style;

// To be overrided
- (void)cellDidLoad;      // For initialization
- (void)cellWillAppear;   // For preparing
- (void)cellDidDisappear; // For canceling

@end;

@interface UListView : UIView

@property (nonatomic, assign) CGFloat spaceValue;    // Default is 0.
@property (nonatomic, assign) CGFloat headerValue;   // Default is 0.
@property (nonatomic, assign) CGFloat footerValue;   // Default is 0.
@property (nonatomic, assign) UListViewCellSepratorLineStyle separatorStyle; // Default is UListViewSepratorLineStyleNoEnds

@property (nonatomic, weak) id<UListViewDelegate> delegate;
@property (nonatomic, weak) id<UListViewDataSource> dataSource;
@property (nonatomic, readonly) UListViewStyle style;

- (id)initWith:(UListViewStyle)style;
- (id)initWithFrame:(CGRect)frame style:(UListViewStyle)style;

// Cell reuse
- (void)registerCell:(NSString *)cellName forIdentifier:(NSString *)identifier;
- (UListViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

// Refresh
- (void)reloadData;

@end

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

@class UListView;
@class UListViewCell;

@protocol UListViewDataSource <NSObject>

@required
- (NSInteger)numberOfRowInListView:(UListView *)listView;
- (UListViewCell *)listView:(UListView *)listView cellAtIndex:(NSInteger)index;

@end

@protocol UListViewDelegate <NSObject>

@optional
- (CGFloat)listView:(UListView *)listView heightForIndex:(NSInteger)index; // Default is 44.0px

@end

@interface UListViewCell : UIView

+ (id)cell;

@end;

@interface UListView : UIView

@property (nonatomic, readonly) UListViewStyle style;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, weak) id <UListViewDataSource> dataSource;
@property (nonatomic, weak) id <UListViewDelegate> delegate;

- (id)initWithStyle:(UListViewStyle)style;
- (id)initWithFrame:(CGRect)frame style:(UListViewStyle)style;

// Cell reuse
- (void)reuseCell:(UListViewCell *)cell forIdentifier:(NSString *)identifier;
- (UListViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

@end

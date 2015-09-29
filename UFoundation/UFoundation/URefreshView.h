//
//  URefreshView.h
//  UFoundation
//
//  Created by Think on 15/9/22.
//  Copyright © 2015年 think. All rights reserved.
//

#import <UFoundation/UFoundation.h>

typedef NS_ENUM(NSInteger, URefreshState)
{
    URefreshStateIdle = 0,
    URefreshStateReady,
    URefreshStateRefreshing,
    URefreshStateDisable,
};

@class URefreshView;
@protocol URefreshViewDelegate <NSObject>

@optional
- (void)refreshView:(URefreshView *)view progress:(CGFloat)progress; // Progress from 0 to 1.0

@end

#define URefreshViewHeaderIdleTitle        @"下拉刷新"
#define URefreshViewHeaderReadyTitle       @"松开刷新"
#define URefreshViewHeaderRefreshingTitle  @"正在刷新"
#define URefreshViewHeaderDisableTitle     @"暂无刷新"

#define URefreshViewFooterIdleTitle        @"上拉加载"
#define URefreshViewFooterReadyTitle       @"松开加载"
#define URefreshViewFooterRefreshingTitle  @"正在加载"
#define URefreshViewFooterDisableTitle     @"没有数据"

@interface URefreshView : UView

@property (nonatomic, weak) id<URefreshViewDelegate> delegate;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat height; //  Default is 50.
@property (nonatomic, assign) BOOL enable;    //  Default is YES

- (void)addTarget:(id)target action:(SEL)action;

// Refresh
- (void)startRefresh;
- (void)finishRefresh;

@end

@interface URefreshHeaderView : URefreshView

@end

@interface URefreshFooterView : URefreshView

@end

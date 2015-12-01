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
    URefreshStateNone = -1,
    URefreshStateIdle,
    URefreshStateReady,
    URefreshStateLoading,
    URefreshStateDisable,
};

@class URefreshView;
@protocol URefreshViewDelegate <NSObject>

@optional
- (void)refreshView:(URefreshView *)view progress:(CGFloat)progress; // Progress from 0 to 1.0

@end

// Default titles
#define URefreshViewHeaderIdleTitle        @"下拉准备刷新"
#define URefreshViewHeaderReadyTitle       @"松开立即刷新"
#define URefreshViewHeaderLoadingTitle     @"正在请求刷新"
#define URefreshViewHeaderDisableTitle     @"暂无更新"

#define URefreshViewFooterIdleTitle        @"上拉准备加载"
#define URefreshViewFooterReadyTitle       @"松开立即加载"
#define URefreshViewFooterLoadingTitle     @"正在请求加载"
#define URefreshViewFooterDisableTitle     @"没有数据"

@interface URefreshView : UView

@property (nonatomic, weak) id<URefreshViewDelegate> delegate;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat height; //  Default is 60.
@property (nonatomic, assign) BOOL enable;    //  Default is YES

@property (nonatomic, copy) NSString *titleOfIdle;
@property (nonatomic, copy) NSString *titleOfReady;
@property (nonatomic, copy) NSString *titleOfLoading;
@property (nonatomic, copy) NSString *titleOfDisable;

- (void)addTarget:(id)target action:(SEL)action;

// Refresh
- (void)startRefresh;
- (void)finishRefresh;

@end

@interface URefreshHeaderView : URefreshView

@end

@interface URefreshFooterView : URefreshView

@end

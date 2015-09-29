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
};

@class URefreshView;
@protocol URefreshViewDelegate <NSObject>

@required
- (void)refreshView:(URefreshView *)view progress:(CGFloat)progress; // Progress from 0 to 1.0

@end

@interface URefreshView : UView

@property (nonatomic, weak) id<URefreshViewDelegate> delegate;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat height; //  Default is 50.

- (void)addTarget:(id)target action:(SEL)action;

// Refresh
- (void)startRefresh;
- (void)finishRefresh;

@end

@interface URefreshHeaderView : URefreshView

@end

@interface URefreshFooterView : URefreshView

@end

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
    URefreshStateNone = 0,
    URefreshStateHeaderRefreshing,
    URefreshStateFooterRefreshing,
};

@interface URefreshView : UView

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, assign) URefreshState state;

- (void)addTarget:(id)target action:(SEL)action;

// Refresh
- (void)startRefresh;
- (void)finishRefresh;

@end

@interface URefreshHeaderView : URefreshView

@end

@interface URefreshFooterView : URefreshView

@end

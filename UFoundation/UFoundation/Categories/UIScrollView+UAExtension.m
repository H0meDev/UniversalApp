//
//  UIScrollView+UAExtension.m
//  UFoundation
//
//  Created by Think on 15/9/18.
//  Copyright © 2015年 think. All rights reserved.
//

#import "UIScrollView+UAExtension.h"
#import <objc/runtime.h>
#import "URefreshView.h"

@interface UIScrollView (UAExtensionProperty)

@property (nonatomic, strong) URefreshHeaderView *headerView;
@property (nonatomic, strong) URefreshFooterView *footerView;

@end

@implementation UIScrollView (UAExtensionProperty)

@dynamic headerView;
@dynamic footerView;

- (URefreshHeaderView *)headerView
{
    URefreshHeaderView *_headerView = objc_getAssociatedObject(self, "UIScrollViewHeader");
    if (_headerView) {
        return _headerView;
    }
    
    _headerView = [[URefreshHeaderView alloc]init];
    [self setHeaderView:_headerView];
    
    return _headerView;
}

- (void)setHeaderView:(URefreshHeaderView *)headerView
{
    headerView.scrollView = self;
    objc_setAssociatedObject(self, "UIScrollViewHeader", headerView, OBJC_ASSOCIATION_RETAIN);
}

- (URefreshFooterView *)footerView
{
    URefreshFooterView *_footerView = objc_getAssociatedObject(self, "UIScrollViewFooter");
    if (_footerView) {
        return _footerView;
    }
    
    _footerView = [[URefreshFooterView alloc]init];
    [self setFooterView:_footerView];
    
    return _footerView;
}

- (void)setFooterView:(URefreshFooterView *)footerView
{
    footerView.scrollView = self;
    objc_setAssociatedObject(self, "UIScrollViewFooter", footerView, OBJC_ASSOCIATION_RETAIN);
}

@end

@implementation UIScrollView (UAExtension)

- (void)addHeaderTarget:(id)target action:(SEL)selector
{
    [self.headerView addTarget:target action:selector];
}

- (void)addFooterTarget:(id)target action:(SEL)selector
{
    [self.footerView addTarget:target action:selector];
}

- (void)startHeaderRefresh
{
    [self.headerView performOnMainThread:@selector(startRefresh)];
}

- (void)startFooterRefresh
{
    [self.footerView performOnMainThread:@selector(startRefresh)];
}

- (void)finishHeaderRefresh
{
    [self.headerView performOnMainThread:@selector(finishRefresh)];
}

- (void)finishFooterRefresh
{
    [self.footerView performOnMainThread:@selector(finishRefresh)];
}

- (BOOL)headerEnable
{
    return self.headerView.enable;
}

- (void)setHeaderEnable:(BOOL)enable
{
    self.headerView.enable = enable;
}

- (BOOL)headerScrollEnableWhenLoading
{
    return self.headerView.scrollEnableWhenRefreshing;
}

- (void)setHeaderScrollEnableWhenLoading:(BOOL)enable
{
    self.headerView.scrollEnableWhenRefreshing = enable;
}

- (BOOL)footerEnable
{
    return self.footerView.enable;
}

- (void)setFooterEnable:(BOOL)enable
{
    self.footerView.enable = enable;
}

- (BOOL)footerScrollEnableWhenLoading
{
    return self.footerView.scrollEnableWhenRefreshing;
}

- (void)setFooterScrollEnableWhenLoading:(BOOL)enable
{
    self.footerView.scrollEnableWhenRefreshing = enable;
}

- (void)removeHeaderView
{
    URefreshHeaderView *_headerView = objc_getAssociatedObject(self, "UIScrollViewHeader");
    if (_headerView) {
        [_headerView removeFromSuperview];
        self.headerView = nil;
    }
}

- (void)removeFooterView
{
    URefreshFooterView *_footerView = objc_getAssociatedObject(self, "UIScrollViewFooter");
    if (_footerView) {
        [_footerView removeFromSuperview];
        self.footerView = nil;
    }
}

@end

//
//  UIScrollView+UAExtension.h
//  UFoundation
//
//  Created by Think on 15/9/18.
//  Copyright © 2015年 think. All rights reserved.
//

#import "URefreshView.h"

@interface UIScrollView (UAExtension)

// Header & Footer
- (void)setHeaderDelegate:(id)delegate;  // URefreshViewDelegate
- (void)setFooterDelegate:(id)delegate;  // URefreshViewDelegate
- (void)setHeaderHeight:(CGFloat)height; // Default is 60.0
- (void)setFooterHeight:(CGFloat)height; // Default is 60.0

// Titles
- (void)setHeaderTitleOfIdle:(NSString *)title;
- (void)setHeaderTitleOfReady:(NSString *)title;
- (void)setHeaderTitleOfLoading:(NSString *)title;
- (void)setHeaderTitleOfDisable:(NSString *)title;
- (void)setFooterTitleOfIdle:(NSString *)title;
- (void)setFooterTitleOfReady:(NSString *)title;
- (void)setFooterTitleOfLoading:(NSString *)title;
- (void)setFooterTitleOfDisable:(NSString *)title;

// Add subview
- (void)addHeaderSubview:(UIView *)view;
- (void)addFooterSubview:(UIView *)view;
- (void)addHeaderTarget:(id)target action:(SEL)selector;
- (void)addFooterTarget:(id)target action:(SEL)selector;

// Refresh
- (void)startHeaderRefresh;
- (void)startFooterRefresh;
- (void)finishHeaderRefresh;
- (void)finishFooterRefresh;

// Refresh enable
- (BOOL)headerEnable;
- (BOOL)footerEnable;
- (void)setHeaderEnable:(BOOL)enable;
- (void)setFooterEnable:(BOOL)enable;
- (BOOL)headerScrollEnableWhenLoading;
- (BOOL)footerScrollEnableWhenLoading;
- (void)setHeaderScrollEnableWhenLoading:(BOOL)enable;
- (void)setFooterScrollEnableWhenLoading:(BOOL)enable;

// Must be called when header or footer not be used any more.
- (void)removeHeaderView;
- (void)removeFooterView;

@end

//
//  UIScrollView+UAExtension.h
//  UFoundation
//
//  Created by Think on 15/9/18.
//  Copyright © 2015年 think. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URefreshView.h"

@interface UIScrollView (UAExtension)

- (void)addHeaderTarget:(id)target action:(SEL)selector;
- (void)addFooterTarget:(id)target action:(SEL)selector;

- (void)startHeaderRefresh;
- (void)startFooterRefresh;
- (void)finishHeaderRefresh;
- (void)finishFooterRefresh;

- (BOOL)headerEnable;
- (void)setHeaderEnable:(BOOL)enable;
- (BOOL)headerScrollEnableWhenLoading;
- (void)setHeaderScrollEnableWhenLoading:(BOOL)enable;

- (BOOL)footerEnable;
- (void)setFooterEnable:(BOOL)enable;
- (BOOL)footerScrollEnableWhenLoading;
- (void)setFooterScrollEnableWhenLoading:(BOOL)enable;

// Must be called when header or footer not be used any more.
- (void)removeHeaderView;
- (void)removeFooterView;

@end

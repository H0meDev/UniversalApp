//
//  BaseTableView.h
//  UniversalApp
//
//  Created by Think on 15/8/13.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <UFoundation/UFoundation.h>

@interface BaseTableView : UTableView

- (void)addHeaderRefreshWith:(id)target action:(SEL)selector;
- (void)addFooterRefreshWith:(id)target action:(SEL)selector;

@end

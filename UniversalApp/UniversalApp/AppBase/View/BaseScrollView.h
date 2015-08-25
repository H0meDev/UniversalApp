//
//  BaseScrollView.h
//  UniversalApp
//
//  Created by Think on 15/8/13.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseScrollView : UIScrollView

- (void)addHeaderRefreshWith:(id)target action:(SEL)selector;
- (void)addFooterRefreshWith:(id)target action:(SEL)selector;

@end

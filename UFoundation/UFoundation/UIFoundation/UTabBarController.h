//
//  BaseTabBarController.h
//  UFoundation
//
//  Created by Think on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UTabBarView.h"
#import "UViewController.h"

@interface UTabBarController : UITabBarController

/*
 * You'd better use tabBarView replace with tabBar
 * self.tabBar will not work properly as well
 */
@property (nonatomic, readonly) UTabBarView *tabBarView;

/*
 * Selected controller
 */
@property (nonatomic, weak, readonly) UViewController *viewController;

@end

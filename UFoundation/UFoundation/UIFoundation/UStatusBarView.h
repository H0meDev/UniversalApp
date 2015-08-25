//
//  UStatusBarView.h
//  UFoundation
//
//  Created by Think on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UStatusBarView : UIView

- (void)stretch;
- (void)collapse;
- (void)stretchWithAnimation;
- (void)collapseWithAnimation;

@end

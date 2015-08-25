//
//  UBarButton.h
//  UFoundation
//
//  Created by Think on 15/8/23.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UBarButtonType)
{
    UBarButtonTypeImageLeftTitleRight = 0, // Default
    UBarButtonTypeImageRightTitleLeft = 1,
    UBarButtonTypeImageUpTitleDown    = 2,
    UBarButtonTypeImageDownTitleUp    = 3,
};

@interface UBarButton : UIControl

+ (UBarButton *)button;
+ (UBarButton *)buttonWith:(UBarButtonType)type;

- (void)setTitle:(NSString *)title;
- (void)setTitleColor:(UIColor *)color;

// Action
- (void)addTarget:(id)target action:(SEL)action;
- (void)addTouchDownTarget:(id)target action:(SEL)action;

- (void)removeTarget:(id)target action:(SEL)action;
- (void)removeTouchDownTarget:(id)target action:(SEL)action;

@end

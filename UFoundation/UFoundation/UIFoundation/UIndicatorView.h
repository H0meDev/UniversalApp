//
//  UIndicatorView.h
//  UFoundation
//
//  Created by Think on 15/9/23.
//  Copyright © 2015年 think. All rights reserved.
//

#import <UFoundation/UFoundation.h>

typedef NS_ENUM(NSInteger, UIndicatorStyle)
{
    UIndicatorStyleCircle, // Default
    UIndicatorStyleProgressCircle,
};

@interface UIndicatorView : UView

@property (nonatomic, assign) UIndicatorStyle style;
@property (nonatomic, copy) UIColor *indicatorColor;
@property (nonatomic, assign) CGFloat indicatorWidth; // Default is 1.0f

// Titles
@property (nonatomic, copy) NSString *titleOfReady;
@property (nonatomic, copy) NSString *titleOfRefreshing;
@property (nonatomic, copy) NSString *titleOfFinish;

- (void)startAnimation;
- (void)stopAnimation;

@end

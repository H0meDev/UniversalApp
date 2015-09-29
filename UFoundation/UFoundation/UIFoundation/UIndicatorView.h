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
    UIndicatorStylePetal  = 0, // Default
    UIndicatorStyleRing,
};

@interface UIndicatorView : UView

@property (nonatomic, copy) UIColor *indicatorColor;  // Default is black color
@property (nonatomic, assign) CGFloat indicatorWidth; // Default is 2.0f

// Titles
@property (nonatomic, copy) NSString *titleOfReady;
@property (nonatomic, copy) NSString *titleOfRefreshing;
@property (nonatomic, copy) NSString *titleOfFinish;

- (id)initWithStyle:(UIndicatorStyle)style;

- (void)startAnimation;
- (void)stopAnimation;

@end

//
//  UProgressIndicatorView.h
//  UFoundation
//
//  Created by Think on 15/9/23.
//  Copyright © 2015年 think. All rights reserved.
//

#import <UFoundation/UFoundation.h>

typedef NS_ENUM(NSInteger, UProgressIndicatorStyle)
{
    UProgressIndicatorStyleAnnulus = 0, // Default
    UProgressIndicatorStyleBar,
};

@interface UProgressIndicatorView : UView

@property (nonatomic, assign) UProgressIndicatorStyle style;

@end

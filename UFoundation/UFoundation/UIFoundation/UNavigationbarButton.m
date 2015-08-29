//
//  UNavigationBarButton.m
//  UFoundation
//
//  Created by Think on 15/8/23.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UNavigationBarButton.h"
#import "UDefines.h"

@interface UNavigationBarButton ()

@end

@implementation UNavigationBarButton

- (id)init
{
    self = [super init];
    if (self) {
        //
    }
    
    return self;
}

- (void)setImageFrame:(CGRect)frame
{
    [super setImageFrame:rectMake(8, 0, 16, naviHeight())];
}

- (void)setTitleFrame:(CGRect)frame
{
    [super setTitleFrame:rectMake(24, 0, frame.size.width, naviHeight())];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

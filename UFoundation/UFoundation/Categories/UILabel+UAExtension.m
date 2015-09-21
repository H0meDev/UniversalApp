//
//  UILabel+UAExtension.m
//  UFoundation
//
//  Created by Think on 15/7/2.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UILabel+UAExtension.h"
#import "NSString+UAExtension.h"
#import "UIView+UAExtension.h"
#import "UDefines.h"

@implementation UILabel (UAExtension)

#pragma mark - Methods

- (CGFloat)contentWidth
{
    return [self contentSizeWith:sizeMake(MAXFLOAT, self.sizeHeight)].width;
}

- (CGFloat)contentHeight
{
    return [self contentSizeWith:sizeMake(self.sizeWidth, MAXFLOAT)].height;
}

- (void)resizeToFitWidth
{
    self.sizeWidth = self.contentWidth;
}

- (void)resizeToFitHeight
{
    self.sizeHeight = self.contentHeight;
}

- (void)resizeToFitContent
{
    self.size = sizeMake(self.contentWidth, self.contentHeight);
}

- (CGSize)contentSizeWith:(CGSize)size
{
    if (!checkClass(self.text, NSString)) {
        return CGSizeZero;
    }
    
    return [self sizeThatFits:size];
}

@end

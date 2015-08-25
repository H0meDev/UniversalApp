//
//  UITextField+UAExtension.m
//  UFoundation
//
//  Created by Think on 15/8/7.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UITextField+UAExtension.h"
#import "NSString+UAExtension.h"
#import "UIView+UAExtension.h"
#import "UDefines.h"


@implementation UITextField (UAExtension)

- (CGFloat)contentWidth
{
    return [self contentSizeWith:sizeMake(MAXFLOAT, self.frame.size.height)].width; // left + right margin
}

- (CGFloat)contentHeight
{
    return [self contentSizeWith:sizeMake(self.frame.size.width, MAXFLOAT)].height; // top + bottom margin
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
    
    NSDictionary *attributes = nil;
    if (systemVersionFloat() >= 7.0) {
        attributes = self.defaultTextAttributes;
    } else {
        __autoreleasing NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.lineBreakMode = NSLineBreakByWordWrapping;
        attributes = @{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:style.copy};
    }
    
    return [self.text contentSizeWithAttributes:attributes size:size];
}

@end

//
//  UITextView+UAExtension.m
//  UFoundation
//
//  Created by Think on 15/8/1.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UITextView+UAExtension.h"
#import "NSString+UAExtension.h"
#import "UIView+UAExtension.h"
#import "UDefines.h"

@implementation UITextView (UAExtension)

#pragma mark - Methods

- (CGFloat)contentWidth
{
    CGFloat delta = 16;
    if (systemVersionFloat() >= 7.0) {
        delta = self.textContainerInset.left + self.textContainerInset.right;
        delta += self.textContainer.lineFragmentPadding * 2;
    }
    
    return [self contentSizeWith:sizeMake(MAXFLOAT, self.frame.size.height)].width + delta; // left + right margin
}

- (CGFloat)contentHeight
{
    CGFloat delta = 16;
    if (systemVersionFloat() >= 7.0) {
        delta = self.textContainerInset.top + self.textContainerInset.bottom;
    }
    
    return [self contentSizeWith:sizeMake(self.frame.size.width, MAXFLOAT)].height + delta; // top + bottom margin
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
    
    __autoreleasing NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    if (systemVersionFloat() >= 7.0) {
        style.lineBreakMode = self.textContainer.lineBreakMode;
    } else {
        style.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    NSDictionary *attributes = @{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:style.copy};
    
    return [self.text contentSizeWithAttributes:attributes size:size];
}

@end

//
//  UITextView+UAExtension.m
//  UFoundation
//
//  Created by Think on 15/8/1.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UITextView+UAExtension.h"
#import <objc/runtime.h>
#import "UDefines.h"

@interface UITextView (UAExtensionExtra)

@property (nonatomic, strong) UILabel *holderLabel;

@end

@implementation UITextView (UAExtensionExtra)

@dynamic holderLabel;

- (UILabel *)holderLabel
{
    UILabel *_holderLabel = objc_getAssociatedObject(self, "UITextViewHolder");
    if (_holderLabel) {
        return _holderLabel;
    }
    
    _holderLabel = [[UILabel alloc]init];
    _holderLabel.userInteractionEnabled = NO;
    _holderLabel.numberOfLines = 0;
    _holderLabel.backgroundColor = sysClearColor();
    [self addSubview:_holderLabel];
    
    objc_setAssociatedObject(self, "UITextViewHolder", _holderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return _holderLabel;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGFloat top = self.textContainerInset.top;
    CGFloat left = self.textContainerInset.left;
    CGFloat right = self.textContainerInset.right;
    
    self.holderLabel.frame = rectMake(left, top, frame.size.width - left - right, 0);
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
}

@end

@implementation UITextView (UAExtension)

- (NSString *)placeholder
{
    return self.holderLabel.text;
}

- (UIColor *)placeholderColor
{
    return self.holderLabel.textColor;
}

- (UIFont *)placeholderFont
{
    return self.holderLabel.font;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    self.holderLabel.text = placeholder;
    
    // Resize
    self.holderLabel.sizeHeight = self.holderLabel.contentHeight;
}

- (void)setPlaceholderColor:(UIColor *)color
{
    self.holderLabel.textColor = color;
    
    // Resize
    self.holderLabel.sizeHeight = self.holderLabel.contentHeight;
}

- (void)setPlaceholderFont:(UIFont *)font
{
    self.holderLabel.font = font;
}

@end

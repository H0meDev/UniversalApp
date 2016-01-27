//
//  BaseTextView.m
//  UFoundation
//
//  Created by Think on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UTextView.h"
#import "UDefines.h"

@interface UTextView ()

@property (nonatomic, strong) UILabel *holderLabel;

@end

@implementation UTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UILabel *)holderLabel
{
    if (_holderLabel) {
        return _holderLabel;
    }
    
    UILabel *holderLabel = [[UILabel alloc]init];
    holderLabel.font = self.font;
    holderLabel.userInteractionEnabled = NO;
    holderLabel.backgroundColor = sysClearColor();
    holderLabel.numberOfLines = 0;
    [self addSubview:holderLabel];
    _holderLabel = holderLabel;
    
    return _holderLabel;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGFloat width = frame.size.width;
    CGFloat top = (systemVersionFloat() >= 7.0)?self.textContainerInset.top:8.0;
    CGFloat left = (systemVersionFloat() >= 7.0)?self.textContainer.lineFragmentPadding:8.0;
    
    self.holderLabel.frame = rectMake(left, top, width - left * 2, 0);
    self.holderLabel.sizeHeight = self.holderLabel.contentHeight;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.holderLabel.font = font;
    self.holderLabel.sizeHeight = self.holderLabel.contentHeight;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    if (checkValidNSString(text)) {
        self.holderLabel.text = nil;
    }
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    self.holderLabel.text = placeholder;
    self.holderLabel.sizeHeight = self.holderLabel.contentHeight;
}

- (void)setPlaceholderColor:(UIColor *)color
{
    _placeholderColor = color;
    
    self.holderLabel.textColor = color;
}

- (BOOL)becomeFirstResponder
{
    self.holderLabel.text = nil;
    
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    if (!checkValidNSString(self.text)) {
        self.holderLabel.text = _placeholder;
    }
    
    return [super resignFirstResponder];
}

- (void)dealloc
{
    if (_holderLabel) {
        [_holderLabel removeFromSuperview];
        _holderLabel = nil;
    }
}

@end

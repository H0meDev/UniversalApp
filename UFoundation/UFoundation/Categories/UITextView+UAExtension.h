//
//  UITextView+UAExtension.h
//  UFoundation
//
//  Created by Think on 15/8/1.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+UAExtension.h"

@interface UITextView (UAExtension)

- (NSString *)placeholder;
- (UIColor *)placeholderColor;
- (UIFont *)placeholderFont;

- (void)setPlaceholder:(NSString *)placeholder;
- (void)setPlaceholderColor:(UIColor *)color;
- (void)setPlaceholderFont:(UIFont *)font;

@end

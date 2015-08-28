//
//  UITextView+UAExtension.h
//  UFoundation
//
//  Created by Think on 15/8/1.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (UAExtension)

// Current content width
- (CGFloat)contentWidth;

// Current content height
- (CGFloat)contentHeight;

// Resize to fill width
- (void)resizeToFitWidth;

// Resize to fill width
- (void)resizeToFitHeight;

// Resize to fill content
- (void)resizeToFitContent;

@end

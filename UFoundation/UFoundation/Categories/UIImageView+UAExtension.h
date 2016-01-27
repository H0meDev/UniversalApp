//
//  UIImageView+UAExtension.h
//  UFoundation
//
//  Created by Think on 15/8/28.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (UAExtension)

// Get the point of image color
- (UIColor*)colorForPoint:(CGPoint)point;

// Network image
- (void)setNetworkImage:(NSString *)imageURL;
- (void)setNetworkImage:(NSString *)imageURL placeholder:(UIImage *)image;
- (void)setNetworkImage:(NSString *)imageURL cachedKey:(NSString *)cachedKey;
- (void)setNetworkImage:(NSString *)imageURL cachedKey:(NSString *)cachedKey placeholder:(UIImage *)image;

@end

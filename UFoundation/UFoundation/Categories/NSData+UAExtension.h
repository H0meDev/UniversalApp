//
//  NSData+UAExtension.h
//  UFoundation
//
//  Created by Think on 15/8/2.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (UAExtension)

/*
 * For base64
 */
+ (NSData *)dataWithBase64String:(NSString *)string;
- (NSString *)base64String;
- (NSString *)base64StringWithLineSeparate:(BOOL)separate;

@end

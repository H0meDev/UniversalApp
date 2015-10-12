//
//  NSString+UAExtension.h
//  UFoundation
//
//  Created by Think on 15/6/16.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (UAExtension)

/*
 * URL encode string
 */
- (NSString *)URLEncodedString;

/*
 * URL decode string
 */
- (NSString*)URLDecodedString;

/*
 * MD5 string value
 */
- (NSString *)MD5String;

/*
 * Size of content
 */
- (CGSize)contentSizeWithFont:(UIFont *)font size:(CGSize)size;

/*
 * Size of content with attributes
 *
 *  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
 *  style.lineBreakMode = NSLineBreakByWordWrapping;
 *  NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style.copy};
 *
 */
- (CGSize)contentSizeWithAttributes:(NSDictionary *)attributes size:(CGSize)size;

/*
 * NSString to JSON dictionary
 */
- (NSDictionary *)JSONValue;

/*
 * NSString to NSDate
 */
- (NSDate *)dateWithFormat:(NSString *)format;

/*
 * Hex color value to UIColor
 */
- (UIColor *)colorValue;

/*
 * Check is email address or not
 */
- (BOOL)isEmailFormat;

/*
 * Check is deceimal number or not
 */
- (BOOL)isNumberFormat;


@end
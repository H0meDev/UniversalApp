//
//  NSDate+UAExtension.h
//
//  Created by Jon Crosby on 10/19/07.
//  Copyright 2007 Kaboomerang LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSDate (UAExtension)

// Get timeinterval since 1970 (Asia/Shanghai)
+ (NSTimeInterval)timeInterval;

// NSDate with format
+ (NSDate *)dateWithFormat:(NSString *)format;

// NSString value with format
- (NSString *)stringWithFormat:(NSString *)format;

// NSDate with years、months、days to current
- (NSDate *)dateWithYears:(NSInteger)years months:(NSInteger)months days:(NSInteger)days;

// NSDate with hours、minutes、seconds to current
- (NSDate *)dateWithHours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds;

@end

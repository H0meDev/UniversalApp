//
//  NSDate+UAExtension.h
//
//  Created by Jon Crosby on 10/19/07.
//  Copyright 2007 Kaboomerang LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSDate (UAExtension)

// Get timeinterval since 1970
+ (NSTimeInterval)timeInterval;

// Date with format
+ (NSDate *)dateWithFormat:(NSString *)format;

// Time gap day
- (NSInteger)numberOfDaysFromDate:(NSDate *)date;

// Time gap hours
- (NSInteger)numberOfHoursFromDate:(NSDate *)date;

// Time gap minute
- (NSInteger)numberOfMinutesFromDate:(NSDate *)date;

// Time gap seconds
- (NSInteger)numberOfSecondsFromDate:(NSDate *)date;

// NSString
- (NSString *)stringWithFormat:(NSString *)format;

// Time < 0: the day after, else the day before
- (NSDate *)dateWithTimeInterval:(NSTimeInterval)time;

// NSString
+ (NSString *)currentWithFormat:(NSString *)format;

@end

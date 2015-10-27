//
//  NSDate+UAExtension.m
//
//  Created by Jon Crosby on 10/19/07.
//  Copyright 2007 Kaboomerang LLC. All rights reserved.
//

#import "NSDate+UAExtension.h"

@implementation NSDate (UAExtension)

+ (NSTimeInterval)timeInterval
{
    @autoreleasepool
    {
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
        [dateFormatter setTimeZone:timeZone];
        NSString *timestamp = [dateFormatter stringFromDate:[NSDate date]];
        
        return [[dateFormatter dateFromString:timestamp]timeIntervalSince1970];
    }
}

+ (NSDate *)dateWithFormat:(NSString *)format
{
    @autoreleasepool
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:format];
        NSDate *date = [NSDate date];
    
        return [dateFormatter dateFromString:[dateFormatter stringFromDate:date]];
    }
}

- (NSString *)stringWithFormat:(NSString *)format
{
    @autoreleasepool
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:format];
        
        return [formatter stringFromDate:self];
    }
}

- (NSDate *)dateWithYears:(NSInteger)years months:(NSInteger)months days:(NSInteger)days
{
    @autoreleasepool
    {
        NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [[NSDateComponents alloc]init];
        
        [components setYear:years];
        [components setMonth:months];
        [components setDay:days];
        
        return [calendar dateByAddingComponents:components toDate:self options:NSCalendarWrapComponents];
    }
}

- (NSDate *)dateWithHours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds
{
    @autoreleasepool
    {
        NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [[NSDateComponents alloc]init];
        
        [components setHour:hours];
        [components setMinute:minutes];
        [components setSecond:seconds];
        
        return [calendar dateByAddingComponents:components toDate:self options:NSCalendarWrapComponents];
    }
}

@end

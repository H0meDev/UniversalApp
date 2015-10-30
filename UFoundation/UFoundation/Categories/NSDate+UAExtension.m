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
    return [[NSDate date]timeIntervalSince1970];
}

+ (NSTimeInterval)timeIntervalOfChina
{
    @autoreleasepool
    {
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setTimeZone:timeZone];
        [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
        NSString *timestamp = [formatter stringFromDate:[NSDate date]];
        
        return [[formatter dateFromString:timestamp]timeIntervalSince1970];
    }
}

+ (NSDate *)dateWithFormat:(NSString *)format
{
    @autoreleasepool
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
        [formatter setDateFormat:format];
        NSDate *date = [NSDate date];
    
        return [formatter dateFromString:[formatter stringFromDate:date]];
    }
}

+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)format
{
    @autoreleasepool
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
        [formatter setDateFormat:format];
        
        return [formatter dateFromString:string];
    }
}

- (NSString *)stringWithFormat:(NSString *)format
{
    @autoreleasepool
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
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

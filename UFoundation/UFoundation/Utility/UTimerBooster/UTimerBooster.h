//
//  UTimerBooster.h
//  UFoundation
//
//  Created by Cailiang on 14-9-20.
//  Copyright (c) 2014年 Cailiang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^UTimerAction)(NSInteger remainder);

/* 
 * UTimerBooster is aimed to timer solutions, it`s powerful for you.
 * UTimerBooster can be used for time counter, timeout action, and so on.
 * You`d better not use any thread sleeping method in your target(s) or action(s).
 * If you have to, the sleeping time must be less than time interval.
 * When you change NSTimer configuration, note that thread safety.
 * Any question? 362397585@qq.com, you know.
 */

@interface UTimerBooster : NSObject

// Set duration of timer
// Before timer start
+ (void)setTimeDuration:(NSTimeInterval)duration; // Default is 0.1s，more slower less CPU used.

// Start timer
+ (void)start;

// Add target
+ (void)addTarget:(id)target sel:(SEL)selector time:(NSTimeInterval)time;

// Add target with repeat
// repeat is -1 means timer life circle, be excuted repeat times
+ (void)addTarget:(id)target sel:(SEL)selector time:(NSTimeInterval)time repeat:(NSInteger)repeat;

// Add target with object
+ (void)addTarget:(id)target sel:(SEL)selector object:(id)object time:(NSTimeInterval)time;

// Add target with object and repeat count
// repeat is -1 means timer life circle, be excuted repeat times
+ (void)addTarget:(id)target
              sel:(SEL)selector
            object:(id)object
             time:(NSTimeInterval)time
           repeat:(NSInteger)repeat;

// Remove all items with the target
+ (void)removeTarget:(id)target;

// Remove target once
+ (void)removeTarget:(id)target sel:(SEL)selector;

// Remove target
+ (void)removeTarget:(id)target sel:(SEL)selector all:(BOOL)removeAll;

// Block style
+ (void)addTarget:(UTimerAction)action time:(NSTimeInterval)time;

// Block style with repeat count
// repeat is -1 means timer life circle
+ (void)addTarget:(UTimerAction)action time:(NSTimeInterval)time repeat:(NSInteger)repeat;

// Stop timer
// Frequently option (start and stop) is not recommended
+ (void)stop;

@end

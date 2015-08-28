//
//  UTimerBooster.m
//  UFoundation
//
//  Created by Cailiang on 14-9-20.
//  Copyright (c) 2014年 Cailiang. All rights reserved.
//

#import "UTimerBooster.h"
#import <objc/message.h>
#import "UThreadPool.h"

#pragma mark - UTimerItem

@interface UTimerItem : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) id object;
@property (nonatomic, assign) UTimerAction action;

@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval excuteTime;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, assign) NSInteger repeat;

- (id)init;
- (BOOL)execute;

@end

@implementation UTimerItem

- (id)init
{
    self = [super init];
    if (self) {
        self.startTime = 0.0f;
        self.excuteTime = 0.0f;
        self.target = nil;
        self.selector = nil;
        self.object = nil;
        self.repeat = 0;
        self.action = NULL;
    }
    
    return self;
}

- (BOOL)execute
{
    BOOL result = NO;
    if (self.repeat > 0 || self.repeat == -1) {
        if (self.repeat > 0) {
            self.repeat --;
        }
        
        if (self.target && self.selector && [self.target respondsToSelector:self.selector]) {
            // Execute item
            IMP imp = [self.target methodForSelector:self.selector];
            void (*execute)(id, SEL, id) = (void *)imp;
            execute(self.target, self.selector, self.object);
            result = YES;
            
            // Reset
            imp = nil;
            execute = nil;
        } else if (self.action != NULL) {
            self.action(self.repeat);
            result = YES;
        }
    }
    
    return result;
}

- (void)dealloc
{
    self.action = NULL;
    self.target = nil;
    self.selector = nil;
    self.object = nil;
    self.repeat = 0;
    self.excuteTime = 0.0f;
    self.timeInterval = 0.0f;
    
    NSLog(@"UTimerItem dealloc");
}

@end

#pragma mark - UTimerBooster

static UTimerBooster *sharedManager = nil;

@interface UTimerBooster ()
{
    NSDateFormatter *_formatter;
    NSTimeInterval _timeDuration;
    NSString *_formartContent;
}

@property (nonatomic, strong) NSTimer *timer;
@property (atomic, strong) NSArray *itemArray;

// Inner methods
- (void)setTimeDuration:(NSTimeInterval)timeInterval;
- (void)addTarget:(id)target
              sel:(SEL)selector
           object:(id)object
             time:(NSTimeInterval)time
           repeat:(NSInteger)repeat;
- (void)remove:(id)target sel:(SEL)selector all:(BOOL)removeAll;
- (void)addItem:(UTimerItem *)item;
- (void)removeItem:(UTimerItem *)item;
- (void)stop;

@end

@implementation UTimerBooster

+ (id)sharedManager
{
    @synchronized (self) {
        if (sharedManager == nil) {
            return [[self alloc]init];
        }
    }
    
    return sharedManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized (self) {
        if (sharedManager == nil) {
            return [super allocWithZone:zone];
        }
    }
    
    return nil;
}

- (id)init
{
    @synchronized(self) {
        self = [super init];
        // Initialize
        sharedManager = self;
        
        // Keep time interval same
        NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        _formatter = [[NSDateFormatter alloc]init];
        [_formatter setTimeZone:zone];
        [_formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
        zone = nil;
        
        // Default duration
        [self setTimeDuration:0.1];
        
        return self;
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - Properties

- (NSTimer *)timer
{
    if (_timer) {
        return _timer;
    }
    
    _itemArray = @[];
    _timer = [NSTimer scheduledTimerWithTimeInterval:_timeDuration // More slower, less cpu used
                                              target:self
                                            selector:@selector(timeCounter)
                                            userInfo:nil
                                             repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    
    // Make thread pool concurrent
    [UThreadPool setConcurrent:YES];
    
    return _timer;
}

#pragma mark - Self Methods

- (void)setTimeDuration:(NSTimeInterval)duration
{
    if (!_timer) {
        _timeDuration = duration;
        if (duration >= 1) {
            _formartContent = @"%d";
        } else if (duration < 1 && duration >= 0.1) {
            _formartContent = @"%.1lf";
        } else if (duration < 0.1 && duration >= 0.01) {
            _formartContent = @"%.2lf";
        } else {
            _formartContent = @"%.3lf";
        }
    }
}

- (NSTimeInterval)timeInterval
{
    @autoreleasepool
    {
        NSString *timestamp = [_formatter stringFromDate:[NSDate date]];
        NSTimeInterval timeInterval = [[_formatter dateFromString:timestamp]timeIntervalSince1970];
        timestamp = [NSString stringWithFormat:_formartContent, timeInterval];
        
        return (NSTimeInterval)[timestamp doubleValue];
    }
}

- (void)timeCounter
{
    NSTimeInterval timeInterval = [self timeInterval];
    for (UTimerItem *item in self.itemArray) {
        if (item.excuteTime <= timeInterval) {
#ifdef DEBUG // To avoid mass execution when debugging
            item.excuteTime = timeInterval + item.timeInterval;
#else
            item.excuteTime += item.timeInterval;
#endif
            // Excute in thread pool
            [UThreadPool addTarget:self sel:@selector(executeWith:) object:item];
        }
    }
}

- (void)executeWith:(UTimerItem *)item
{
    // Excute to decide remove or not
    BOOL needsRemove = NO;
    if (item.timeInterval <= 0 || ![item execute]) {
        needsRemove = YES;
    }
    
    if (item.repeat == 0) {
        needsRemove = YES;
    }
    
    if (needsRemove) {
        // Remove the item that no need to be executed
        [self removeItem:item];
    }
}

- (void)addTarget:(id)target
              sel:(SEL)selector
            object:(id)object
             time:(NSTimeInterval)time
           repeat:(NSInteger)repeat
{
    @autoreleasepool
    {
        NSString *value = [NSString stringWithFormat:_formartContent, time];
        time = [value doubleValue];
        
        UTimerItem *item = [[UTimerItem alloc]init];
        item.target = target;
        item.selector = selector;
        item.object = object;
        item.timeInterval = time;
        
        if (time >= _timeDuration) {
            item.repeat = repeat;
            item.startTime = [self timeInterval];
            item.excuteTime = item.startTime + time;
            [self addItem:item];
        }
    }
}

- (void)addTarget:(UTimerAction)action time:(NSTimeInterval)time repeat:(NSInteger)repeat
{
    @autoreleasepool
    {
        NSString *value = [NSString stringWithFormat:_formartContent, time];
        time = [value doubleValue];
        
        UTimerItem *item = [[UTimerItem alloc]init];
        item.action = action;
        item.timeInterval = time;
        
        if (time >= _timeDuration) {
            item.repeat = repeat;
            item.startTime = [self timeInterval];
            item.excuteTime = item.startTime + time;
            [self addItem:item];
        }
    }
}

- (void)remove:(id)target sel:(SEL)selector all:(BOOL)removeAll
{
    @autoreleasepool
    {
        NSArray *itemArray = [[NSArray alloc]initWithArray:self.itemArray];
        for (int i = 0; i < itemArray.count; i ++) {
            // Remove the item
            UTimerItem *item = itemArray[i];
            
            if (item.target) {
                if (selector) {
                    if (item.target == target) {
                        // To string
                        NSString *selName = NSStringFromSelector(selector);
                        NSString *_selName = NSStringFromSelector(item.selector);
                        
                        if ([selName isEqualToString:_selName]) {
                            // Remove
                            [self removeItem:item];
                            
                            if (!removeAll) {
                                break;
                            }
                        }
                    }
                } else {
                    if (item.target == target) {
                        // Remove
                        [self removeItem:item];
                    }
                }
            } else {
                // Remove
                [self removeItem:item];
            }
        }
    }
}

- (void)addItem:(UTimerItem *)item
{
    if (![item.target respondsToSelector:item.selector]) {
        return;
    }
    
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:self.itemArray];
    NSInteger count = self.itemArray.count;
    
    if (count == 0) {
        [mArray addObject:item];
    } else {
        // Sort by timeinterval
        for (int i = 0; i < count; i ++) {
            UTimerItem *titem = self.itemArray[i];
            if (item.timeInterval < titem.timeInterval) {
                [mArray insertObject:item atIndex:i];
                break;
            } else if ((i + 1) >= count) {
                [mArray addObject:item];
                break;
            }
        }
    }
    
    self.itemArray = [NSArray arrayWithArray:mArray];
}

- (void)removeItem:(UTimerItem *)item
{
    @autoreleasepool
    {
        NSMutableArray *mArray = [NSMutableArray arrayWithArray:self.itemArray];
        [mArray removeObject:item];
        self.itemArray = [NSArray arrayWithArray:mArray];
    }
}

- (void)stop
{
    @autoreleasepool
    {
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        
        self.itemArray = nil;
    }
}

+ (void)setTimeDuration:(NSTimeInterval)duration
{
    [[UTimerBooster sharedManager]setTimeDuration:duration];
}

+ (void)start
{
    [[UTimerBooster sharedManager]timer];
}

+ (void)addTarget:(id)target sel:(SEL)selector time:(NSTimeInterval)time
{
    [UTimerBooster addTarget:target sel:selector object:nil time:time repeat:1];
}

+ (void)addTarget:(id)target sel:(SEL)selector time:(NSTimeInterval)time repeat:(NSInteger)repeat
{
    [UTimerBooster addTarget:target sel:selector object:nil time:time repeat:repeat];
}

+ (void)addTarget:(id)target sel:(SEL)selector object:(id)object time:(NSTimeInterval)time
{
    [UTimerBooster addTarget:target sel:selector object:object time:time repeat:1];
}

+ (void)addTarget:(id)target
              sel:(SEL)selector
            object:(id)object
             time:(NSTimeInterval)time
           repeat:(NSInteger)repeat
{
    [[self sharedManager]addTarget:target sel:selector object:object time:time repeat:repeat];
}

+ (void)addTarget:(UTimerAction)action time:(NSTimeInterval)time
{
    [UTimerBooster addTarget:action time:time repeat:1];
}

+ (void)addTarget:(UTimerAction)action time:(NSTimeInterval)time repeat:(NSInteger)repeat
{
    [[self sharedManager]addTarget:action time:time repeat:repeat];
}

+ (void)removeTarget:(id)target
{
    [[self sharedManager]remove:target sel:nil all:NO];
}

+ (void)removeTarget:(id)target sel:(SEL)selector
{
    [[self sharedManager]remove:target sel:selector all:NO];
}

+ (void)removeTarget:(id)target sel:(SEL)selector all:(BOOL)removeAll
{
    [[self sharedManager]remove:target sel:selector all:removeAll];
}

+ (void)stop
{
    [self stop];
}

@end

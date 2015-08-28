//
//  LocalNotification.m
//  UniversalApp
//
//  Created by Think on 15/8/4.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "LocalNotification.h"
#import <UFoundation/UDefines.h>

@interface LocalNotificationItem : NSObject

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) id object;

// Create new instance
+ (id)notificationItem;

@end

@implementation LocalNotificationItem

+ (id)notificationItem
{
    @autoreleasepool
    {
        return [[LocalNotificationItem alloc]init];
    }
}

@end

@interface LocalNotification ()

@property (atomic, strong) NSMutableArray *notifications;

@end

@implementation LocalNotification

- (id)init
{
    self = [super init];
    if (self) {
        self.notifications = [NSMutableArray array];
    }
    
    return self;
}

- (void)addNotification:(id)target selector:(SEL)selector name:(NSString *)name
{
    [self addNotification:target selector:selector name:name object:nil];
}

- (void)addNotification:(id)target selector:(SEL)selector name:(NSString *)name object:(id)object
{
    if (!target || !selector || !checkValidNSString(name) || ![target respondsToSelector:selector]) {
        return;
    }

    [NotificationDefaultCenter addObserver:target selector:selector name:name object:object];
    
    LocalNotificationItem *item = [LocalNotificationItem notificationItem];
    item.target = target;
    item.selector = selector;
    item.name = name;
    item.object = object;
    [self.notifications addObject:item];
}

- (void)removeNotification:(id)target name:(NSString *)name
{
    [self removeNotification:target name:name object:nil];
}

- (void)removeNotification:(id)target name:(NSString *)name object:object
{
    if (!target || !checkValidNSString(name)) {
        return;
    }
    
    NSArray *notifications = [NSArray arrayWithArray:self.notifications];
    for (LocalNotificationItem *item in notifications) {
        if (target == item.target && [name isEqualToString:item.name]) {
            // Remove from NSNotificationCenter
            [NotificationDefaultCenter removeObserver:item.target name:item.name object:item.object];
            
            // Remove from list
            [self.notifications removeObject:item];
        }
    }
}

- (void)removeNotification:(id)target
{
    if (!target) {
        return;
    }
    
    NSArray *notifications = [NSArray arrayWithArray:self.notifications];
    for (LocalNotificationItem *item in notifications) {
        if (target == item.target) {
            // Remove from NSNotificationCenter
            [NotificationDefaultCenter removeObserver:item.target name:item.name object:item.object];
            
            // Remove from list
            [self.notifications removeObject:item];
        }
    }
    
    [NotificationDefaultCenter removeObserver:target];
}

@end

//
//  KeyValueObserver.m
//  UniversalApp
//
//  Created by Think on 15/8/4.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "KeyValueObserver.h"
#import <UFoundation/UDefines.h>

@interface KeyValueObserverItem : NSObject

@property (nonatomic, assign) id observer;
@property (nonatomic, assign) id target;
@property (nonatomic, strong) NSString *keyPath;

+ (KeyValueObserverItem *)observerItem;

@end

@implementation KeyValueObserverItem

+ (KeyValueObserverItem *)observerItem
{
    @autoreleasepool
    {
        return [[KeyValueObserverItem alloc]init];
    }
}

@end

@interface KeyValueObserver ()

@property (atomic, strong) NSMutableArray *observers;

@end

@implementation KeyValueObserver

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.observers = [NSMutableArray array];
    }
    
    return self;
}

- (void)addKeyValueObserver:(id)observer target:(id)target keyPath:(NSString *)keyPath
{
    if (!observer || !target || !checkValidNSString(keyPath)) {
        return;
    }
    
    // Add KVO
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [target addObserver:observer forKeyPath:keyPath options:options context:NULL];
    
    KeyValueObserverItem *item = [KeyValueObserverItem observerItem];
    item.observer = observer;
    item.target = target;
    item.keyPath = keyPath;
    [self.observers addObject:item];
}

- (void)removeKeyValueObserver:(id)observer target:(id)target keyPath:(NSString *)keyPath
{
    if (!observer || !target || !checkValidNSString(keyPath)) {
        return;
    }
    
    for (KeyValueObserverItem *item in self.observers) {
        if (item.observer == observer &&
            item.target == target &&
            [item.keyPath isEqualToString:keyPath])
        {
            // Remove KVO
            [target removeObserver:observer forKeyPath:keyPath];
            
            // Remove from list
            [self.observers removeObject:item];
        }
    }
}

- (void)removeKeyValueObserver:(id)observer
{
    if (!observer) {
        return;
    }
    
    for (KeyValueObserverItem *item in self.observers) {
        if (item.observer == observer) {
            // Remove KVO
            [item.target removeObserver:item.observer forKeyPath:item.keyPath];
            
            // Remove from list
            [self.observers removeObject:item];
        }
    }
}

@end

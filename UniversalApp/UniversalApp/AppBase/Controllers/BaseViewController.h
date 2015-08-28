//
//  BaseViewController.h
//  UniversalApp
//
//  Created by Think on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "GlobalManager.h"

@interface BaseViewController : UViewController

@property (nonatomic, weak, readonly) GlobalManager *globalManager;

/*
 * Enable default navigation back button
 */
@property (nonatomic, assign) BOOL enableBackButton;

/*
 * Left button action
 */
- (void)backAction;

/*
 * For NSNotification extension
 * All added NSNotification will be auto removed in dealloc
 */
- (void)addNotification:(NSString *)name selector:(SEL)selector;
- (void)addNotification:(NSString *)name selector:(SEL)selector object:(id)object;
- (void)removeNotification:(NSString *)name;
- (void)removeNotification:(NSString *)name object:object;

/* 
 * For KVO extension
 * keyPath is a property of target
 * All added KVO will be auto removed in dealloc
 */
- (void)addKeyValueObject:(id)object keyPath:(NSString *)keyPath; // Add self as observer
- (void)removeKeyValueObject:(id)object keyPath:(NSString *)keyPath;

/*
 * KVObserver callback, needs super call
 * change[@"new"] to get new value, change[@"old"] to get old value,
 */
- (void)receivedKVObserverValueForKayPath:(NSString *)keyPath
                                 ofObject:(id)object
                                   change:(NSDictionary *)change;

@end

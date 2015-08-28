//
//  LocalNotification.h
//  UniversalApp
//
//  Created by Think on 15/8/4.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalNotification : NSObject

/*
 * Add notification
 */
- (void)addNotification:(id)target selector:(SEL)selector name:(NSString *)name;
- (void)addNotification:(id)target selector:(SEL)selector name:(NSString *)name object:(id)object;

/*
 * Remove notification
 */
- (void)removeNotification:(id)target name:(NSString *)name;
- (void)removeNotification:(id)target name:(NSString *)name object:object;
- (void)removeNotification:(id)target;

@end

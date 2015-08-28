//
//  KeyValueObserver.h
//  UniversalApp
//
//  Created by Think on 15/8/4.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyValueObserver : NSObject

/*
 * Add KVO
 */
- (void)addKeyValueObserver:(id)observer target:(id)target keyPath:(NSString *)keyPath;

/*
 * Remove KVO
 */
- (void)removeKeyValueObserver:(id)observer target:(id)target keyPath:(NSString *)keyPath;
- (void)removeKeyValueObserver:(id)observer; // Remove all KVO

@end

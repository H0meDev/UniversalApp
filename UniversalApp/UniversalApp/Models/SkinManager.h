//
//  SkinManager.h
//  UniversalApp
//
//  Created by Think on 15/8/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkinManager : NSObject

/*
 * Set the path of downloaded skin
 */
- (void)setPathOfSkin:(NSString *)path;

/*
 * Get value for key, NSString
 */
- (NSString *)resourceValueForKey:(NSString *)key;

/*
 * Get image for key
 */
- (UIImage *)imageForKey:(NSString *)key;

/*
 * Get color for key
 */
- (UIColor *)colorForKey:(NSString *)key;

@end

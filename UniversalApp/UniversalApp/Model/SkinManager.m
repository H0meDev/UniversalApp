//
//  SkinManager.m
//  UniversalApp
//
//  Created by Think on 15/8/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "SkinManager.h"

@interface SkinManager ()
{
    NSDictionary *_skinDict;
}

@end

@implementation SkinManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *path = resourcePathWithName(@"default_skin", @"plist");
        _skinDict = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    
    return self;
}

- (void)setPathOfSkin:(NSString *)path
{
    _skinDict = [NSDictionary dictionaryWithContentsOfFile:path];
}

- (NSString *)resourceValueForKey:(NSString *)key
{
    if (_skinDict) {
        return _skinDict[key];
    }
    
    return nil;
}

- (UIImage *)imageForKey:(NSString *)key
{
    if (_skinDict) {
        NSString *path = _skinDict[key];
        return [UIImage imageNamed:path];
    }
    
    return nil;
}

- (UIColor *)colorForKey:(NSString *)key
{
    if (_skinDict) {
        NSString *color = _skinDict[key];
        return [color colorValue];
    }
    
    return nil;
}

@end

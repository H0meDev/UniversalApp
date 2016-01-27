//
//  UHTTPImage.h
//  UFoundation
//
//  Created by Think on 15/12/14.
//  Copyright © 2015年 think. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UHTTPRequest.h"

@interface UHTTPImageItem : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) UIImage *image;

@end

typedef void (^UHTTPImageCallback)(UHTTPImageItem *item);

@interface UHTTPImage : NSObject

+ (void)downloadImageWith:(NSString *)url callback:(UHTTPImageCallback)callback;
+ (void)downloadImageWith:(NSString *)url progress:(UHTTPImageCallback)progress callback:(UHTTPImageCallback)callback;

+ (void)downloadImageWith:(NSString *)url
                cachedKey:(NSString *)key
                 callback:(UHTTPImageCallback)callback;

+ (void)downloadImageWith:(NSString *)url
                cachedKey:(NSString *)key
                 progress:(UHTTPImageCallback)progress
                 callback:(UHTTPImageCallback)callback;

+ (NSInteger)sizeOfCaches;
+ (NSInteger)numberOfCaches;

+ (void)removeAllCaches;

@end

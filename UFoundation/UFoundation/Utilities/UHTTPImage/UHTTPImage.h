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

typedef void (^UHTTPImageProgressCallback)(NSData *data, long long recieved, long long total);
typedef void (^UHTTPImageCompleteCallback)(UHTTPImageItem *item);

@interface UHTTPImage : NSObject

+ (void)downloadImageWith:(NSString *)url callback:(UHTTPImageCompleteCallback)callback;
+ (void)downloadImageWith:(NSString *)url progress:(UHTTPImageProgressCallback)progress callback:(UHTTPImageCompleteCallback)callback;

+ (void)downloadImageWith:(NSString *)url
                cachedKey:(NSString *)key
                 callback:(UHTTPImageCompleteCallback)callback;

+ (void)downloadImageWith:(NSString *)url
                cachedKey:(NSString *)key
                 progress:(UHTTPImageProgressCallback)progress
                 callback:(UHTTPImageCompleteCallback)callback;

+ (NSInteger)sizeOfCaches;
+ (NSInteger)numberOfCaches;

+ (void)removeAllCaches;

@end

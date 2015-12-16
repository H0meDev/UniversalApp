//
//  UHTTPImage.h
//  UFoundation
//
//  Created by Think on 15/12/14.
//  Copyright © 2015年 think. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UHTTPRequest.h"

typedef void (^UHTTPImageCallback)(UIImage *image);

@interface UHTTPImage : NSObject

+ (void)downloadImageWith:(NSString *)url callback:(UHTTPImageCallback)callback;
+ (void)downloadImageWith:(NSString *)url cachedKey:(NSString *)key callback:(UHTTPImageCallback)callback;

+ (NSInteger)sizeOfCaches;
+ (NSInteger)numberOfCaches;

+ (void)removeAllCaches;
+ (void)removeCacheWith:(NSString *)url;
+ (void)removeCacheWithCachedKey:(NSString *)key;

@end

//
//  UHTTPRequest.h
//  UFoundation
//
//  Created by Think on 15/5/23.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UHTTPOperation.h"

@interface UHTTPRequest : NSObject

/*
 * Asynchronous request
 */

// Block style with no cache
+ (void)sendAsynWith:(NSString *)method
                 url:(NSString *)url
               param:(NSDictionary *)param
            callback:(UHTTPCallback)callback;

+ (void)sendAsynWith:(NSString *)method
                 url:(NSString *)url
               param:(NSDictionary *)param
             timeout:(NSInteger)timeout
            callback:(UHTTPCallback)callback;

+ (void)sendAsynWith:(NSString *)method
                 url:(NSString *)url
               param:(NSDictionary *)param
             timeout:(NSInteger)timeout
               retry:(NSUInteger)times
        timeInterval:(NSInteger)timeInterval
            callback:(UHTTPCallback)callback;

// Block style with cache
+ (void)sendAsynCachedWith:(NSString *)method
                       url:(NSString *)url
                     param:(NSDictionary *)param
                  callback:(UHTTPCallback)callback;

+ (void)sendAsynCachedWith:(NSString *)method
                       url:(NSString *)url
                     param:(NSDictionary *)param
                   timeout:(NSInteger)timeout
                  callback:(UHTTPCallback)callback;

+ (void)sendAsynCachedWith:(NSString *)method
                       url:(NSString *)url
                     param:(NSDictionary *)param
                   timeout:(NSInteger)timeout
                     retry:(NSUInteger)times
              timeInterval:(NSInteger)timeInterval
                  callback:(UHTTPCallback)callback;

// Delegate style with no cache
+ (void)sendAsynWith:(NSString *)method
                 url:(NSString *)url
               param:(NSDictionary *)param
            delegate:(id<UHTTPRequestDelegate>)delegate
                 tag:(int)tag;

+ (void)sendAsynWith:(NSString *)method
                 url:(NSString *)url
               param:(NSDictionary *)param
            delegate:(id<UHTTPRequestDelegate>)delegate
             timeout:(NSInteger)timeout
                 tag:(int)tag;

+ (void)sendAsynWith:(NSString *)method
                 url:(NSString *)url
               param:(NSDictionary *)param
            delegate:(id<UHTTPRequestDelegate>)delegate
             timeout:(NSInteger)timeout
               retry:(NSUInteger)times
        timeInterval:(NSInteger)timeInterval
                 tag:(int)tag;

// Delegate style with no cache
+ (void)sendAsynCachedWith:(NSString *)method
                       url:(NSString *)url
                     param:(NSDictionary *)param
                  delegate:(id<UHTTPRequestDelegate>)delegate
                       tag:(int)tag;

+ (void)sendAsynCachedWith:(NSString *)method
                       url:(NSString *)url
                     param:(NSDictionary *)param
                  delegate:(id<UHTTPRequestDelegate>)delegate
                   timeout:(NSInteger)timeout
                       tag:(int)tag;

+ (void)sendAsynCachedWith:(NSString *)method
                       url:(NSString *)url
                     param:(NSDictionary *)param
                  delegate:(id<UHTTPRequestDelegate>)delegate
                   timeout:(NSInteger)timeout
                     retry:(NSUInteger)times
              timeInterval:(NSInteger)timeInterval
                       tag:(int)tag;

/*
 * Synchronous request
 */

+ (NSData *)sendSynWith:(NSString *)method
                    url:(NSString *)url
                  param:(NSDictionary *)param
               response:(NSURLResponse **)response
                  error:(NSError **)error;

@end

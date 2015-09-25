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
+ (void)sendAsynWith:(NSString *)url
              method:(NSString *)method
               param:(NSDictionary *)param
            callback:(UHTTPCallback)callback;

+ (void)sendAsynWith:(NSString *)url
              method:(NSString *)method
               param:(NSDictionary *)param
             timeout:(NSInteger)timeout
            callback:(UHTTPCallback)callback;

+ (void)sendAsynWith:(NSString *)url
              method:(NSString *)method
               param:(NSDictionary *)param
             timeout:(NSInteger)timeout
               retry:(NSUInteger)times
        timeInterval:(NSInteger)timeInterval
            callback:(UHTTPCallback)callback;

// Block style with specified cache
+ (void)sendAsynWith:(NSString *)url
              method:(NSString *)method
               param:(NSDictionary *)param
            callback:(UHTTPCallback)callback
              cached:(BOOL)cached;

+ (void)sendAsynWith:(NSString *)url
              method:(NSString *)method
               param:(NSDictionary *)param
             timeout:(NSInteger)timeout
            callback:(UHTTPCallback)callback
              cached:(BOOL)cached;

+ (void)sendAsynWith:(NSString *)url
              method:(NSString *)method
               param:(NSDictionary *)param
             timeout:(NSInteger)timeout
               retry:(NSUInteger)times
        timeInterval:(NSInteger)timeInterval
            callback:(UHTTPCallback)callback
              cached:(BOOL)cached;

// Delegate style with no cache
+ (void)sendAsynWith:(NSString *)url
              method:(NSString *)method
               param:(NSDictionary *)param
            delegate:(id<UHTTPRequestDelegate>)delegate
                 tag:(int)tag;

+ (void)sendAsynWith:(NSString *)url
              method:(NSString *)method
               param:(NSDictionary *)param
            delegate:(id<UHTTPRequestDelegate>)delegate
             timeout:(NSInteger)timeout
                 tag:(int)tag;

+ (void)sendAsynWith:(NSString *)url
              method:(NSString *)method
               param:(NSDictionary *)param
            delegate:(id<UHTTPRequestDelegate>)delegate
             timeout:(NSInteger)timeout
               retry:(NSUInteger)times
        timeInterval:(NSInteger)timeInterval
                 tag:(int)tag;

// Delegate style with specified cache
+ (void)sendAsynWith:(NSString *)url
              method:(NSString *)method
               param:(NSDictionary *)param
            delegate:(id<UHTTPRequestDelegate>)delegate
                 tag:(int)tag
              cached:(BOOL)cached;

+ (void)sendAsynWith:(NSString *)url
              method:(NSString *)method
               param:(NSDictionary *)param
            delegate:(id<UHTTPRequestDelegate>)delegate
             timeout:(NSInteger)timeout
                 tag:(int)tag
              cached:(BOOL)cached;

+ (void)sendAsynWith:(NSString *)url
              method:(NSString *)method
               param:(NSDictionary *)param
            delegate:(id<UHTTPRequestDelegate>)delegate
             timeout:(NSInteger)timeout
               retry:(NSUInteger)times
        timeInterval:(NSInteger)timeInterval
                 tag:(int)tag
              cached:(BOOL)cached;

/*
 * Synchronous request
 */

+ (NSData *)sendSynWith:(NSString *)url
                 method:(NSString *)method
                  param:(NSDictionary *)param
               response:(NSURLResponse **)response
                  error:(NSError **)error;

@end

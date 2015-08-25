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

// Asynchronous request
// Block style
+ (void)sendAsynWith:(NSString *)verb
                 url:(NSString *)url
               param:(NSDictionary *)param
            callback:(UHTTPCallback)callback;

+ (void)sendAsynWith:(NSString *)verb
                 url:(NSString *)url
               param:(NSDictionary *)param
             timeout:(NSInteger)timeout
            callback:(UHTTPCallback)callback;

+ (void)sendAsynWith:(NSString *)verb
                 url:(NSString *)url
               param:(NSDictionary *)param
             timeout:(NSInteger)timeout
               retry:(NSUInteger)times
        timeInterval:(NSInteger)timeInterval
            callback:(UHTTPCallback)callback;

// Delegate style
+ (void)sendAsynWith:(NSString *)verb
                 url:(NSString *)url
               param:(NSDictionary *)param
            delegate:(id<UHTTPRequestDelegate>)delegate
                 tag:(int)tag;

+ (void)sendAsynWith:(NSString *)verb
                 url:(NSString *)url
               param:(NSDictionary *)param
            delegate:(id<UHTTPRequestDelegate>)delegate
             timeout:(NSInteger)timeout
                 tag:(int)tag;

+ (void)sendAsynWith:(NSString *)verb
                 url:(NSString *)url
               param:(NSDictionary *)param
            delegate:(id<UHTTPRequestDelegate>)delegate
             timeout:(NSInteger)timeout
               retry:(NSUInteger)times
        timeInterval:(NSInteger)timeInterval
                 tag:(int)tag;

// Synchronous request
+ (NSData *)sendSynWith:(NSString *)method
                    url:(NSString *)url
                  param:(NSDictionary *)param
               response:(NSURLResponse **)response
                  error:(NSError **)error;

@end

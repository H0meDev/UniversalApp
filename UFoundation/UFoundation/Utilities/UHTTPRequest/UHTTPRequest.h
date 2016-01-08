//
//  UHTTPRequest.h
//  UFoundation
//
//  Created by Think on 15/5/23.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UHTTPOperation.h"

@interface UHTTPRequestParam : NSObject

@property (nonatomic, strong) NSString *url;        // Server API address
@property (nonatomic, strong) NSString *method;     // Default is GET
@property (nonatomic, strong) NSDictionary *header;
@property (nonatomic, strong) NSDictionary *body;
@property (nonatomic, strong) NSString *cacheKey;    // Key for customized cache
@property (nonatomic, assign) CGFloat timeout;       // Default 30s
@property (nonatomic, assign) CGFloat retry;         // Default 0
@property (nonatomic, assign) CGFloat retryInterval; // Default 0
@property (nonatomic, assign) BOOL json;             // Default is YES, JSON format for POST or other methods
@property (nonatomic, assign) BOOL cached;           // Default is NO, when cached, the request will load data from cached firstly

+ (id)param;

@end

@interface UHTTPRequest : NSObject

/*
 * Asynchronous request
 */

// Block style with no cache
+ (UHTTPOperation *)sendAsynWith:(UHTTPRequestParam *)param
                        callback:(UHTTPCallback)callback;

// Delegate style with no cache
+ (UHTTPOperation *)sendAsynWith:(UHTTPRequestParam *)param
                        delegate:(id<UHTTPRequestDelegate>)delegate
                             tag:(int)tag;

/*
 * Synchronous request
 */

+ (NSData *)sendSyncWith:(UHTTPRequestParam *)param
                response:(NSURLResponse **)response
                   error:(NSError **)error;

@end

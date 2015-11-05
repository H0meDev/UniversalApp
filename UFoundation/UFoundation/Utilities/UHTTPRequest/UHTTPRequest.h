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

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSDictionary *header;
@property (nonatomic, strong) NSDictionary *body;
@property (nonatomic, assign) CGFloat timeout;
@property (nonatomic, assign) CGFloat retry;
@property (nonatomic, assign) CGFloat retryInterval;
@property (nonatomic, assign) BOOL json;
@property (nonatomic, assign) BOOL cached;

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

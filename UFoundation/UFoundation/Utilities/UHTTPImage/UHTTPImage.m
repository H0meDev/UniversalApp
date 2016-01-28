//
//  UHTTPImage.m
//  UFoundation
//
//  Created by Think on 15/12/14.
//  Copyright © 2015年 think. All rights reserved.
//

#import "UHTTPImage.h"
#import "UModel.h"
#import "NSObject+UAExtension.h"
#import "NSDate+UAExtension.h"
#import "NSString+UAExtension.h"
#import "NSArray+UAExtension.h"

#pragma mark - UImageCacheItem class

@interface UImageCacheItem : UModel

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *cachedKey;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSMutableArray *progressArray;
@property (nonatomic, strong) NSMutableArray *callbackArray;

@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) BOOL downloaded;
@property (nonatomic, assign) NSTimeInterval cachedDate;
@property (nonatomic, assign) NSTimeInterval completedDate;

@end

@implementation UImageCacheItem

- (id)init
{
    self = [super init];
    if (self) {
        _size = 0;
        _cachedDate = 0;
        _completedDate = 0;
        _progressArray = [NSMutableArray array];
        _callbackArray = [NSMutableArray array];
    }
    
    return self;
}

@end

#pragma mark - UImageCache class

@interface UImageCache : NSObject
{
    NSString *_cachePath;
    NSMutableArray *_cachedArray;
    NSMutableArray *_memcaches;
}

singletonInterfaceWith(UImageCache, cache);

@end

@implementation UImageCache

singletonImplementationWith(UImageCache, cache);

- (id)init
{
    self = [super init];
    if (self) {
        // Load from local files
        [self loadAllCachedItems];
    }
    
    return self;
}

- (void)loadAllCachedItems
{
    _memcaches = [NSMutableArray array];
    
    _cachePath = cachePathWith(@"Images");
    if (!checkFileExists(_cachePath)) {
        // Check directory
        if (!checkCacheDirectoryExists()) {
            createCacheDirectory();
        }
        
        createCacheDirectoryWith(_cachePath);
    }
    
    NSString *filePath = [_cachePath stringByAppendingString:@"/image_cache"];
    if (!checkFileExists(filePath)) {
        createFile(filePath);
    }
    
    // Load history from file
    NSArray *cachedArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    if (cachedArray) {
        cachedArray = [UModel modelsWithArray:cachedArray];
    }
    
    if (!cachedArray) {
        _cachedArray = [NSMutableArray array];
    } else {
        _cachedArray = [NSMutableArray arrayWithArray:cachedArray];
    }
    
    // Remove all uncompleted items
    cachedArray = [NSArray arrayWithArray:_cachedArray];
    for (UImageCacheItem *item in cachedArray) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", cachePathWith(@"Images"), item.fileName];
        if (!checkFileExists(filePath)) {
            [_cachedArray removeObject:item];
        }
    }
}

- (void)cacheAllItems
{
    NSString *filePath = cachePathWith(@"Images/image_cache");
    if (!checkFileExists(filePath)) {
        createFile(filePath);
    }
    
    NSMutableArray *cachedArray = [NSMutableArray array];
    for (UImageCacheItem *item in _cachedArray) {
        if (item.downloaded) {
            [cachedArray addObject:[item dictionaryWithModelKey]];
        }
    }
    
    [cachedArray writeToFile:filePath atomically:YES];
}

- (BOOL)addImageCacheItemWith:(NSString *)url progress:(UHTTPImageProgressCallback)progress callback:(UHTTPImageCompleteCallback)callback
{
    return [self addImageCacheItemWith:url cachedkey:nil progress:progress callback:callback];
}

- (BOOL)addImageCacheItemWith:(NSString *)url
                    cachedkey:(NSString *)key
                     progress:(UHTTPImageProgressCallback)progress
                     callback:(UHTTPImageCompleteCallback)callback
{
    UImageCacheItem *cacheItem = nil;
    for (UImageCacheItem *item in _cachedArray) {
        if ([item.url isEqualToString:url]) {
            if (checkValidNSString(key)) {
                if ([item.cachedKey isEqualToString:key]) {
                    cacheItem = item;
                    break;
                }
            } else {
                cacheItem = item;
                break;
            }
        }
    }
    
    if (!cacheItem) {
        UImageCacheItem *item = [UImageCacheItem model];
        item.url = url;
        item.cachedKey = key;
        item.cachedDate = [NSDate timeInterval];
        
        // Progress
        if (progress) {
            [item.progressArray addObject:progress];
        }
        
        // Callback
        if (callback) {
            [item.callbackArray addObject:callback];
        }
        
        // Keep item
        [_cachedArray addObject:item];
    } else {
        // Progress
        if (progress && ![cacheItem.progressArray containsItem:progress]) {
            [cacheItem.progressArray addObject:progress];
        }
        
        // Callback
        if (callback && ![cacheItem.callbackArray containsItem:callback]) {
            [cacheItem.callbackArray addObject:callback];
        }
    }
    
    return (cacheItem == nil);
}

- (NSArray *)cacheImageWith:(NSString *)url data:(NSData *)data
{
    return [self cacheImageWith:url cachedkey:nil data:data];
}

- (NSArray *)cacheImageWith:(NSString *)url cachedkey:(NSString *)key data:(NSData *)data
{
    UImageCacheItem *cacheItem = nil;
    for (UImageCacheItem *item in _cachedArray) {
        if ([item.url isEqualToString:url]) {
            if (checkValidNSString(key)) {
                if ([item.cachedKey isEqualToString:key]) {
                    cacheItem = item;
                    break;
                }
            } else {
                key = [url MD5String];
                cacheItem = item;
                break;
            }
        }
    }
    
    // Cached to local file
    NSString *fileName = [url MD5String];
    NSString *filePath = [_cachePath stringByAppendingPathComponent:fileName];
    
    BOOL written = [data writeToFile:filePath atomically:YES];
    if (written) {
        cacheItem.size = data.length;
        cacheItem.downloaded = YES;
        cacheItem.cachedKey = key;
        cacheItem.completedDate = [NSDate timeInterval];
        cacheItem.fileName = fileName;
    }
    
    // All progress
    [cacheItem.progressArray removeAllObjects];
    
    // All callbacks
    NSArray *callbacks = nil;
    if (checkValidNSArray(cacheItem.callbackArray)) {
        callbacks = [NSArray arrayWithArray:cacheItem.callbackArray];
    }
    [cacheItem.callbackArray removeAllObjects];
    
    // Clear all callbacks and cache
    [self cacheAllItems];
    
    return callbacks;
}

- (NSArray *)progressArrayWith:(NSString *)url cachedkey:(NSString *)key
{
    UImageCacheItem *cacheItem = nil;
    for (UImageCacheItem *item in _cachedArray) {
        if ([item.url isEqualToString:url]) {
            if (checkValidNSString(key)) {
                if ([item.cachedKey isEqualToString:key]) {
                    cacheItem = item;
                    break;
                }
            } else {
                key = [url MD5String];
                cacheItem = item;
                break;
            }
        }
    }
    
    return cacheItem.progressArray;
}

- (NSString *)cachedPathWith:(NSString *)url
{
    return [self cachedPathWith:url cachedKey:nil];
}

- (NSString *)cachedPathWith:(NSString *)url cachedKey:(NSString *)key
{
    NSString *filePath = nil;
    if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
        for (UImageCacheItem *item in _cachedArray) {
            if ([item.url isEqualToString:url]) {
                if (checkValidNSString(key)) {
                    if ([item.cachedKey isEqualToString:key]) {
                        filePath = item.fileName;
                        break;
                    }
                } else {
                    filePath = item.fileName;
                    break;
                }
            }
        }
    }
    
    if (filePath) {
        filePath = [NSString stringWithFormat:@"%@/%@", cachePathWith(@"Images"), filePath];
        
        return filePath;
    }
    
    return filePath;
}

- (void)removeCachedItemWith:(NSString *)url
{
    if (checkValidNSArray(_cachedArray)) {
        NSArray *cachedArray = [NSArray arrayWithArray:_cachedArray];
        for (UImageCacheItem *item in cachedArray) {
            if ([item.url isEqualToString:url]) {
                [_cachedArray removeObject:item];
            }
        }
    }
}

- (NSInteger)numberOfCaches
{
    return _cachedArray.count;
}

- (NSInteger)sizeOfCaches
{
    NSInteger size = 0;
    for (UImageCacheItem *item in _cachedArray) {
        size += item.size;
    }
    
    return size;
}

- (void)removeAllCaches
{
    for (UImageCacheItem *item in _cachedArray) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", cachePathWith(@"Images"), item.fileName];
        
        NSError *error = nil;
        removeFileWith(filePath, error);
        
        if (error) {
            NSLog(@"REMOVE CACHE ERROR :\n%@", error.description);
        }
    }
    
    [_cachedArray removeAllObjects];
    [self cacheAllItems];
}

@end

#pragma mark - UHTTPImageItem class

@implementation UHTTPImageItem

+ (id)item
{
    @autoreleasepool
    {
        return [[UHTTPImageItem alloc]init];
    }
}

@end

#pragma mark - UHTTPImage class

@implementation UHTTPImage

+ (void)downloadImageWith:(NSString *)url callback:(UHTTPImageCompleteCallback)callback
{
    [self downloadImageWith:url cachedKey:nil progress:NULL callback:callback];
}

+ (void)downloadImageWith:(NSString *)url progress:(UHTTPImageProgressCallback)progress callback:(UHTTPImageCompleteCallback)callback
{
    [self downloadImageWith:url cachedKey:nil progress:progress callback:callback];
}

+ (void)downloadImageWith:(NSString *)url
                cachedKey:(NSString *)key
                 callback:(UHTTPImageCompleteCallback)callback
{
    [self downloadImageWith:url cachedKey:key progress:NULL callback:callback];
}

+ (void)downloadImageWith:(NSString *)url
                cachedKey:(NSString *)key
                 progress:(UHTTPImageProgressCallback)progress
                 callback:(UHTTPImageCompleteCallback)callback
{
    @autoreleasepool
    {
        NSString *path = [[UImageCache cache]cachedPathWith:url];
        if (!path) {
            // Add to cache
            BOOL needs = [[UImageCache cache]addImageCacheItemWith:url progress:progress callback:callback];
            if (needs) {
                // Download
                UHTTPRequestParam *param = [UHTTPRequestParam param];
                param.url = url;
                
                NSMutableData *mdata = [NSMutableData data];
                [UHTTPRequest sendAsynWith:param
                                  progress:^(id data, long long receivedLength, long long expectedLength) {
                                      @autoreleasepool
                                      {
                                          if (checkValidNSData(data)) {
                                              // Downloading progress
                                              [mdata appendData:data];
                                              
                                              NSArray *progressArray = [[UImageCache cache]progressArrayWith:url cachedkey:key];
                                              for (UHTTPImageProgressCallback progress in progressArray) {
                                                  dispatch_async(main_queue(), ^{
                                                      progress(data, receivedLength, expectedLength);
                                                  });
                                              }
                                          }
                                      }
                                  }
                                  complete:^(UHTTPStatus *status, id data) {
                                      if (UHTTPCodeOK == status.code) {
                                          // Perform callback and cache image
                                          NSArray *callbackArray = [[UImageCache cache]cacheImageWith:url data:data];
                                          for (UHTTPImageCompleteCallback callback in callbackArray) {
                                              UHTTPImageItem *item = [UHTTPImageItem item];
                                              item.key = key;
                                              item.url = url;
                                              item.image = [UIImage imageWithData:data];
                                              
                                              dispatch_async(main_queue(), ^{
                                                  callback(item);
                                              });
                                          }
                                      } else {
                                          [[UImageCache cache]removeCachedItemWith:url];
                                      }
                                  }];
            }
        } else {
            // Load from local
            NSString *path = [[UImageCache cache]cachedPathWith:url];
            if (callback && checkValidNSString(path)) {
                UHTTPImageItem *item = [UHTTPImageItem item];
                item.key = key;
                item.url = url;
                item.image = [UIImage imageWithContentsOfFile:path];
                
                callback(item);
            }
        }
    }
}

+ (NSInteger)sizeOfCaches
{
    return [[UImageCache cache]sizeOfCaches];
}

+ (NSInteger)numberOfCaches
{
    return [[UImageCache cache]numberOfCaches];
}

+ (void)removeAllCaches
{
    [[UImageCache cache]removeAllCaches];
}

@end

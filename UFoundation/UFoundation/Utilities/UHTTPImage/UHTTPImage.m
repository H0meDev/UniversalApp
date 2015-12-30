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
@property (nonatomic, strong) NSMutableArray *callbacks;

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
        _callbacks = [NSMutableArray array];
    }
    
    return self;
}

@end

#pragma mark - UImageCache class

@interface UImageCache : NSObject
{
    NSLock *_cacheLock;
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
    _cacheLock = [[NSLock alloc]init];
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
    
    if (cachedArray.count > 0) {
        [cachedArray writeToFile:filePath atomically:YES];
    }
}

- (BOOL)addImageCacheItemWith:(NSString *)url callback:(UHTTPImageCallback)callback
{
    return [self addImageCacheItemWith:url cachedkey:nil callback:callback];
}

- (BOOL)addImageCacheItemWith:(NSString *)url cachedkey:(NSString *)key callback:(UHTTPImageCallback)callback
{
    [_cacheLock lock];
    
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
        
        if (callback && ![item.callbacks containsItem:callback]) {
            [item.callbacks addObject:callback];
        }
        
        [_cachedArray addObject:item];
    } else {
        if (callback) {
            [cacheItem.callbacks addObject:callback];
        }
    }
    
    [_cacheLock unlock];
    
    return (cacheItem == nil);
}

- (NSArray *)cacheImageWith:(NSString *)url data:(NSData *)data
{
    return [self cacheImageWith:url cachedkey:nil data:data];
}

- (NSArray *)cacheImageWith:(NSString *)url cachedkey:(NSString *)key data:(NSData *)data
{
    [_cacheLock lock];
    
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
    
    // All callbacks
    NSArray *callbacks = nil;
    if (checkValidNSArray(cacheItem.callbacks)) {
        callbacks = [NSArray arrayWithArray:cacheItem.callbacks];
    }
    [cacheItem.callbacks removeAllObjects];
    
    // Clear all callbacks and cache
    [self cacheAllItems];
    
    [_cacheLock unlock];
    
    return callbacks;

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
        NSMutableArray *marray = [NSMutableArray arrayWithArray:_cachedArray];
        for (UImageCacheItem *item in _cachedArray) {
            if ([item.url isEqualToString:url]) {
                [marray removeObject:item];
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
        removeFile(filePath);
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

+ (void)downloadImageWith:(NSString *)url callback:(UHTTPImageCallback)callback
{
    [self downloadImageWith:url cachedKey:nil callback:callback];
}

+ (void)downloadImageWith:(NSString *)url cachedKey:(NSString *)key callback:(UHTTPImageCallback)callback
{
    NSString *path = [[UImageCache cache]cachedPathWith:url];
    if (!path) {
        // Add to cache
        BOOL needs = [[UImageCache cache]addImageCacheItemWith:url callback:callback];
        if (needs) {
            // Download
            UHTTPRequestParam *param = [UHTTPRequestParam param];
            param.url = url;
            
            [UHTTPRequest sendAsynWith:param callback:^(UHTTPStatus *status, id data) {
                if (UHTTPCodeOK == status.code) {
                    // Perform callback and cache image
                    NSArray *callbacks = [[UImageCache cache]cacheImageWith:url data:data];
                    for (UHTTPImageCallback callback in callbacks) {
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

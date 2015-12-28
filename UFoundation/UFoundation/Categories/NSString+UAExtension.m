//
//  NSString+UAExtension.m
//  UFoundation
//
//  Created by Think on 15/6/16.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "NSString+UAExtension.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "NSObject+UAExtension.h"
#import "NSData+UAExtension.h"
#import "UDefines.h"

@implementation NSString (UAExtension)

- (NSInteger)compareVersionWith:(NSString *)version
{
    if (checkValidNSString(version)) {
        NSArray *carray = [self componentsSeparatedByString:@"."];
        if (checkValidNSArray(carray)) {
            NSArray *tarray = [self componentsSeparatedByString:@"."];
            if (checkValidNSArray(tarray)) {
                NSInteger count = carray.count;
                count = (count > tarray.count)?tarray.count:count;
                
                for (int i = 0; i < count; i ++) {
                    NSInteger cvalue = [carray[i] integerValue];
                    NSInteger tvalue = [tarray[i] integerValue];
                    
                    if (cvalue != tvalue) {
                        if (cvalue > tvalue) {
                            return 1;
                        } else {
                            return -1;
                        }
                    }
                }
                
                if (carray.count > tarray.count) {
                    return 1;
                } else if (carray.count < tarray.count) {
                    return -1;
                } else {
                    return 0;
                }
            }
        }
    }
    
    return 2;
}

- (NSString *)URLEncodedString
{
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                    (CFStringRef)self,
                                                                                    NULL,
                                                                                    CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                    kCFStringEncodingUTF8);
}

- (NSString *)URLDecodedString
{
    return (__bridge NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                    (CFStringRef)self,
                                                                                                    CFSTR(""),
                                                                                                    kCFStringEncodingUTF8);
}

- (NSString *)MD5String
{
    @autoreleasepool
    {
        const char *cstring = [self UTF8String];
        u_char result[CC_MD5_DIGEST_LENGTH];
        CC_MD5(cstring, (CC_LONG)strlen(cstring), result);
        NSMutableString *hash = [NSMutableString string];
        
        for (int i = 0; i < 16; i++) {
            [hash appendFormat:@"%02X", result[i]];
        }
        
        return [hash lowercaseString];
    }
}

- (NSString *)stringOfDESWithkey:(NSString *)key encryption:(BOOL)encryption
{
    CCOperation operation = encryption?kCCEncrypt:kCCDecrypt;
    return [self stringOfDESWithkey:key operation:operation];
}

- (NSString *)stringOf3DESWithkey:(NSString *)key vector:(NSString *)vector encryption:(BOOL)encryption
{
    CCOperation operation = encryption?kCCEncrypt:kCCDecrypt;
    return [self stringOf3DESWithkey:key vector:vector operation:operation];
}

- (NSString *)stringOfDESWithkey:(NSString *)key operation:(CCOperation)operation
{
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    memset((void*)buffer,0x0, bufferSize);
    
    size_t numOfBytes = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeDES,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numOfBytes);
    
    __autoreleasing NSString *retString = nil;
    if (cryptStatus == kCCSuccess) {
        if (operation == kCCEncrypt) {
            NSData *retData = [NSData dataWithBytesNoCopy:buffer length:numOfBytes];
            retString = [[retData base64String]URLEncodedString];
        } else {
            NSData *retData = [NSData dataWithBytesNoCopy:buffer length:numOfBytes];
            retString = [[NSString alloc]initWithData:retData encoding:NSUTF8StringEncoding];
        }
    }
    
    free(buffer);
    buffer = NULL;
    
    return retString;
}

- (NSString *)stringOf3DESWithkey:(NSString *)key vector:(NSString *)vector operation:(CCOperation)operation
{
    const void * vplainText;
    size_t plainTextBufferSize;
    
    if (operation== kCCDecrypt) {
        NSData * encryptData = [NSData dataWithBase64String:self];
        plainTextBufferSize = [encryptData length];
        vplainText = [encryptData bytes];
    } else {
        NSData * tempData = [self dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize= [tempData length];
        vplainText = [tempData bytes];
        
    }
    
    CCCryptorStatus ccStatus;
    uint8_t * bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES)&~(kCCBlockSize3DES- 1);
    
    bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
    memset((void*)bufferPtr,0x0, bufferPtrSize);
    
    const void * vkey= (const void *)[key UTF8String];
    const void * vinitVec= (const void *)[vector UTF8String];
    
    uint8_t iv[kCCBlockSize3DES];
    memset((void*) iv,0x0, (size_t)sizeof(iv));
    
    ccStatus = CCCrypt(operation,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,               // 密钥
                       kCCKeySize3DES,
                       vinitVec,           // 初始向量
                       vplainText,         // 明文
                       plainTextBufferSize,
                       (void*)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    __autoreleasing NSString * result = nil;
    if (ccStatus == kCCSuccess) {
        if (operation== kCCDecrypt) {
            NSData * retData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
            result = [[NSString alloc]initWithData:retData encoding:NSUTF8StringEncoding];
        } else {
            NSData * retData =[NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
            result = [retData base64String];
        }
    }
    
    free(bufferPtr);
    bufferPtr = NULL;
    
    return result;
}

- (CGSize)contentSizeWithFont:(UIFont *)font size:(CGSize)size
{
    __autoreleasing NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style.copy};
    
    return [self contentSizeWithAttributes:attributes size:size];
}

- (CGSize)contentSizeWithAttributes:(NSDictionary *)attributes size:(CGSize)size
{
    @autoreleasepool
    {
        CGSize retsize = CGSizeZero;
        if (systemVersionFloat() >= 7.0) {
            retsize = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil].size;
        } else {
            NSParagraphStyle *style = (NSParagraphStyle *)attributes[NSParagraphStyleAttributeName];
            if (!style) {
                style = [NSParagraphStyle defaultParagraphStyle];
            }
            
            retsize = [self sizeWithFont:attributes[NSFontAttributeName]
                       constrainedToSize:size
                           lineBreakMode:style.lineBreakMode];
        }
        
        // Resize
        retsize.height = ceil(retsize.height);
        retsize.width = ceil(retsize.width);
        
        return retsize;
    }
}

- (NSDictionary *)JSONValue
{
    NSDictionary *json = nil;
    NSError *error = nil;
    
    @try
    {
        __weak typeof(self) weakself = self;
        NSString *jsonData = [NSString stringWithFormat:@"%@", weakself];
        NSData *responseData = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
        json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
    }
    @catch (NSException *exception)
    {
        NSLog(@"JSONValue exception:%@", exception.description);
        json = nil;
    }
    @finally
    {
        if (error) {
            NSLog(@"JSONValue error:%@", error.description);
        }
        
        return json;
    }
}

- (NSDate *)dateWithFormat:(NSString *)format
{
    @autoreleasepool
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:format];
        
        return [dateFormatter dateFromString:self];
    }
}

- (UIColor *)colorValue
{
    NSString *hexColor = self;
    if (hexColor.length > 0) {
        if ([hexColor rangeOfString:@"#"].location == 0) {
            hexColor = [hexColor substringFromIndex:1];
        }
        
        int high = 0, low = 0, rvalue = 0, gvalue = 0, bvalue = 0;
        if (hexColor.length >= 6) {
            const char *value = [[hexColor lowercaseString]UTF8String];
            for (int i = 0; i < 6; i ++) {
                char cvalue = value[i];
                if (cvalue > '9') {
                    cvalue = cvalue - 'a' + 10;
                } else {
                    cvalue = cvalue - '0';
                }
                
                if (i % 2 == 0) {
                    high = cvalue;
                } else {
                    low = cvalue;
                }
                
                if (i % 2 == 1) {
                    if (i / 2 == 0) {
                        // red
                        rvalue = high * 16 + low;
                    } else if (i / 2 == 1) {
                        // green
                        gvalue = high * 16 + low;
                    } else if (i / 2 == 2) {
                        // blue
                        bvalue = high * 16 + low;
                    }
                }
            }
        }
        
        return rgbaColor(rvalue, gvalue, bvalue, 1.0);
    }
    
    return nil;
}

- (BOOL)isEmailFormat
{
    if (self && self.length > 3) {
        NSArray *array = [self componentsSeparatedByString:@"."];
        if ([array count]>= 4) {
            return NO;
        }
        
        NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        return [predicate evaluateWithObject:self];
    }
    
    return NO;
}

- (BOOL)isNumberFormat
{
    const char *cvalue = [self UTF8String];
    size_t clen = strlen(cvalue);
    for (size_t i = 0; i < clen; i ++) {
        if (!isdigit(cvalue[i])) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)containsWithString:(NSString *)subString
{
    if ([self rangeOfString:subString].location != NSNotFound) {
        return YES;
    }
    
    return NO;
}

- (NSString *)replaceWithString:(NSString *)string with:(NSString *)replacement
{
    return [self stringByReplacingOccurrencesOfString:string withString:replacement];
}

@end

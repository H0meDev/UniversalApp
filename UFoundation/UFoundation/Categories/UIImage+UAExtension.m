//
//  UIImage+UAExtension.m
//  UFoundation
//
//  Created by Think on 15/8/11.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UIImage+UAExtension.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (UAExtension)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    @autoreleasepool
    {
        CGRect rect = CGRectMake(0, 0, 8, 8);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
}

+ (UIImage *)blurryImage:(UIImage *)image withLevel:(CGFloat)level
{
    @autoreleasepool
    {
        level = (level < 0.)?0:level;
        level = (level > 1.)?1:level;
        
        int sizeOfBox = (int)(level * 100);
        sizeOfBox = sizeOfBox - (sizeOfBox % 2) + 1;
        
        CGImageRef imageRef = image.CGImage;
        CGDataProviderRef provider = CGImageGetDataProvider(imageRef);
        CFDataRef dataRef = CGDataProviderCopyData(provider);
        
        vImage_Buffer inputBuffer;
        inputBuffer.width = CGImageGetWidth(imageRef);
        inputBuffer.height = CGImageGetHeight(imageRef);
        inputBuffer.rowBytes = CGImageGetBytesPerRow(imageRef);
        inputBuffer.data = (void*)CFDataGetBytePtr(dataRef);
        
        void *pixelBuffer = malloc(CGImageGetBytesPerRow(imageRef) * CGImageGetHeight(imageRef));
        if(pixelBuffer == NULL) {
            NSLog(@"No pixelbuffer");
        }
        
        vImage_Buffer outputBuffer;
        outputBuffer.data = pixelBuffer;
        outputBuffer.width = CGImageGetWidth(imageRef);
        outputBuffer.height = CGImageGetHeight(imageRef);
        outputBuffer.rowBytes = CGImageGetBytesPerRow(imageRef);
        
        // Core method
        vImage_Error error = vImageBoxConvolve_ARGB8888(&inputBuffer,
                                                        &outputBuffer,
                                                        NULL,
                                                        0,
                                                        0,
                                                        sizeOfBox,
                                                        sizeOfBox,
                                                        NULL,
                                                        kvImageEdgeExtend);
        
        if (error) {
            NSLog(@"Error from convolution %ld", error);
        }
        
        CGBitmapInfo bitmapInfo;
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
        bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
        bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(outputBuffer.data,
                                                     outputBuffer.width,
                                                     outputBuffer.height,
                                                     8,
                                                     outputBuffer.rowBytes,
                                                     colorSpace,
                                                     bitmapInfo);
        // Blurry image
        UIImage *blurryImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
        
        // Clean up
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        
        free(pixelBuffer);
        CFRelease(dataRef);
        
        CGColorSpaceRelease(colorSpace);
        CGImageRelease(imageRef);
        
        return blurryImage;
    }
}

@end

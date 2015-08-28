//
//  NSData+UAExtension.m
//  UFoundation
//
//  Created by Think on 15/8/2.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "NSData+UAExtension.h"

#define SIZE_OF_BINARY 3
#define SIZE_OF_BASE64 4

static unsigned char encode_table[65] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static unsigned char decode_table[256] = {
    65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
    65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
    65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 62, 65, 65, 65, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 65, 65, 65, 65, 65, 65,
    65,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 65, 65, 65, 65, 65,
    65, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 65, 65, 65, 65, 65,
    65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
    65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
    65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
    65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
    65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
    65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
    65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
    65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
};

/*
 *
 */
void *base64_decode(const char *buffer, size_t length, size_t *output_length)
{
    if (length == -1) {
        length = strlen(buffer);
    }
    
    size_t output_size = ((length + SIZE_OF_BASE64 - 1) / SIZE_OF_BASE64) * SIZE_OF_BINARY;
    unsigned char *output_buffer = (unsigned char *)malloc(output_size);
    
    size_t i = 0;
    size_t j = 0;
    while (i < length) {
        unsigned char accumulated[SIZE_OF_BASE64];
        size_t accumulate_index = 0;
        while (i < length) {
            unsigned char decode = decode_table[buffer[i++]];
            if (decode != 65) {
                accumulated[accumulate_index] = decode;
                accumulate_index++;
                
                if (accumulate_index == SIZE_OF_BASE64) {
                    break;
                }
            }
        }
        
        if(accumulate_index >= 2) {
            output_buffer[j] = (accumulated[0] << 2) | (accumulated[1] >> 4);
        }
        
        if(accumulate_index >= 3) {
            output_buffer[j + 1] = (accumulated[1] << 4) | (accumulated[2] >> 2);
        }
        
        if(accumulate_index >= 4) {
            output_buffer[j + 2] = (accumulated[2] << 6) | accumulated[3];
        }
        
        j += accumulate_index - 1;
    }
    
    if (output_length) {
        *output_length = j;
    }
    
    return output_buffer;
}

/*
 *
 */
char *base64_encode(const void *buffer, size_t length, bool line_count, size_t *output_length)
{
    const unsigned char *ubuffer = (const unsigned char *)buffer;
    size_t output_size = ((length / SIZE_OF_BINARY) + ((length % SIZE_OF_BINARY) ? 1 : 0)) * SIZE_OF_BASE64;
    if (line_count) {
        output_size += (output_size / 64) * 2;
    }
    
    output_size += 1;
    
    char *output_buffer = (char *)malloc(output_size);
    if (!output_buffer) {
        return NULL;
    }
    
    size_t i = 0;
    size_t j = 0;
    const size_t line_length = line_count ? ((64 / SIZE_OF_BASE64) * SIZE_OF_BINARY) : length;
    size_t line_end = line_length;
    
    while (1) {
        if (line_end > length) {
            line_end = length;
        }
        
        for (; i + SIZE_OF_BINARY - 1 < line_end; i += SIZE_OF_BINARY) {
            output_buffer[j++] = encode_table[(ubuffer[i] & 0xFC) >> 2];
            output_buffer[j++] = encode_table[((ubuffer[i] & 0x03) << 4) | ((ubuffer[i + 1] & 0xF0) >> 4)];
            output_buffer[j++] = encode_table[((ubuffer[i + 1] & 0x0F) << 2) | ((ubuffer[i + 2] & 0xC0) >> 6)];
            output_buffer[j++] = encode_table[ubuffer[i + 2] & 0x3F];
        }
        
        if (line_end == length) {
            break;
        }

        output_buffer[j++] = '\r';
        output_buffer[j++] = '\n';
        line_end += line_length;
    }
    
    if (i + 1 < length) {
        output_buffer[j++] = encode_table[(ubuffer[i] & 0xFC) >> 2];
        output_buffer[j++] = encode_table[((ubuffer[i] & 0x03) << 4) | ((ubuffer[i + 1] & 0xF0) >> 4)];
        output_buffer[j++] = encode_table[(ubuffer[i + 1] & 0x0F) << 2];
        output_buffer[j++] =	'=';
    } else if (i < length) {
        output_buffer[j++] = encode_table[(ubuffer[i] & 0xFC) >> 2];
        output_buffer[j++] = encode_table[(ubuffer[i] & 0x03) << 4];
        output_buffer[j++] = '=';
        output_buffer[j++] = '=';
    }
    
    output_buffer[j] = 0;
    
    if (output_length) {
        *output_length = j;
    }
    
    return output_buffer;
}

@implementation NSData (UAExtension)

+ (NSData *)dataWithBase64String:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSASCIIStringEncoding];
    size_t length = 0;
    void *buffer = base64_decode([data bytes], [data length], &length);
    NSData *result = [NSData dataWithBytes:buffer length:length];
    free(buffer);
    
    return result;
}

- (NSString *)base64String
{
    size_t length = 0;
    char *buffer = base64_encode([self bytes], [self length], true, &length);
    __autoreleasing NSString *result = [[NSString alloc]initWithBytes:buffer length:length encoding:NSASCIIStringEncoding];
    free(buffer);
    
    return result;
}

- (NSString *)base64StringWithLineSeparate:(BOOL)separate
{
    size_t length = 0;
    char *buffer = base64_encode([self bytes], [self length], separate, &length);
    __autoreleasing NSString *result = [[NSString alloc]initWithBytes:buffer length:length encoding:NSASCIIStringEncoding];
    free(buffer);
    
    return result;
}

@end

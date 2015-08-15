//
//  ISStegoEncoder.m
//  ISSteganography
//
//  Created by Isaac Stevao Sena on 7/25/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import "ISStegoEncoder.h"
#import "ISStegoUtilities.h"
#import "ISPixelUtilities.h"
#import "ISStegoDefaults.h"

@interface ISStegoEncoder ()

@property (nonatomic, assign) int currentShift;
@property (nonatomic, assign) int currentCharacter;
@property (nonatomic, assign) UInt32 step;
@property (nonatomic, strong) NSString *currentDataToHide;

@end

@implementation ISStegoEncoder

- (UIImage *)stegoImageForImage:(UIImage *)image
                           data:(id)data
                          error:(NSError **)error {
    NSParameterAssert([data isKindOfClass:NSData.class] || [data isKindOfClass:NSString.class]);
    NSParameterAssert(image);
    
    CGImageRef inputCGImage = [image CGImage];
    NSUInteger width = CGImageGetWidth(inputCGImage);
    NSUInteger height = CGImageGetHeight(inputCGImage);
    
    NSUInteger size = height * width;
    
    UInt32 *pixels;
    pixels = (UInt32 *) calloc(size, sizeof(UInt32));
    
    UIImage *processedImage = nil;
    
    if (size >= MinPixels()) {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        CGContextRef context = CGBitmapContextCreate(pixels,
                                                     width,
                                                     height,
                                                     BITS_PER_COMPONENT,
                                                     BYTES_PER_PIXEL * width,
                                                     colorSpace,
                                                     kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), inputCGImage);
        
        BOOL success = [self hideData:data
                             inPixels:pixels
                             withSize:size
                                error:error];
        
        if (success) {
            CGImageRef newCGImage = CGBitmapContextCreateImage(context);
            processedImage = [UIImage imageWithCGImage:newCGImage];
            CGImageRelease(newCGImage);
        }
        
        CGColorSpaceRelease(colorSpace);
        CGContextRelease(context);
    } else {
        if (error != NULL) {
            *error = ErrorForDomainCode(ISStegoErrorDomainCodeImageTooSmall);
        }
    }
    
    free(pixels);
    
    return processedImage;
}

#pragma mark - Pixel operations

- (BOOL)hideData:(id)data
        inPixels:(UInt32 *)pixels
        withSize:(NSUInteger)size
           error:(NSError **)error {
    BOOL success = NO;
    
    NSString *messageToHide = [self messageToHide:data];
    
    UInt32 dataLength = (UInt32)[messageToHide length];
    
    if (dataLength <= INT_MAX
        && dataLength * BITS_PER_COMPONENT < size - SizeOfInfoLength()) {
        [self reset];
        
        NSData *data = [[NSData alloc] initWithBytes:&dataLength
                                              length:BYTES_OF_LENGTH];
        
        NSString *lengthDataInfo = [[NSString alloc] initWithData:data
                                                         encoding:NSASCIIStringEncoding];
        
        UInt32 pixelPosition = 0;
        
        self.currentDataToHide = lengthDataInfo;
        
        while (pixelPosition < SizeOfInfoLength()) {
            pixels[pixelPosition] = [self newPixel:pixels[pixelPosition]];
            pixelPosition++;
        }
        
        [self reset];
        
        NSUInteger pixelsToHide = [messageToHide length] * BITS_PER_COMPONENT;
        
        self.currentDataToHide = messageToHide;
        
        double ratio = (size - pixelPosition)/pixelsToHide;
        
        int salt = ratio;
        
        while (pixelPosition <= size) {
            pixels[pixelPosition] = [self newPixel:pixels[pixelPosition]];
            pixelPosition += salt;
        }
        
        success = YES;
    } else {
        if (error != NULL) {
            *error = ErrorForDomainCode(ISStegoErrorDomainCodeDataTooBig);
        }
    }
    
    return success;
}

- (UInt32)newPixel:(UInt32)pixel {
    UInt32 color = [self newColor:pixel];
    self.step++;
    return color;
}

- (UInt32)newColor:(UInt32)color {
    if ([self.currentDataToHide length] > self.currentCharacter) {
        UInt32 asciiCode = [self.currentDataToHide
                            characterAtIndex:self.currentCharacter];
        
        UInt32 shiftedBits = asciiCode >> self.currentShift;
        
        if (self.currentShift == 0) {
            self.currentShift = INITIAL_SHIFT;
            self.currentCharacter++;
            
        } else {
            self.currentShift--;
        }
        
        return NewPixel(color, shiftedBits, ColorToStep(self.step));
    }
    
    return color;
}

- (void)reset {
    self.currentShift = INITIAL_SHIFT;
    
    self.currentCharacter = 0;
}

#pragma mark - Formatting data to hide

- (NSString *)messageToHide:(id)data {
    NSString *base64 = [self base64FromData:data];
    return [NSString stringWithFormat:@"%@%@%@", DATA_PREFIX, base64, DATA_SUFFIX];
}

- (NSString *)base64FromData:(id)data {
    NSString *base64 = nil;
    
    if ([data isKindOfClass:NSString.class]) {
        NSData *dataOfString = [data dataUsingEncoding:NSUTF8StringEncoding];
        base64 = [dataOfString base64EncodedStringWithOptions:0];
    } else {
        base64 = [data base64EncodedStringWithOptions:0];
    }
    
    return base64;
}

@end

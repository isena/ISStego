//
//  ISStegoDecoder.m
//  ISStego
//
//  Created by Isaac Stevao Sena on 7/25/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import "ISStegoDecoder.h"
#import "ISStegoUtilities.h"
#import "ISPixelUtilities.h"
#import "ISStegoDefaults.h"
#import <CoreGraphics/CoreGraphics.h>

@interface ISStegoDecoder ()

@property (nonatomic, assign) int currentShift;
@property (nonatomic, assign) int bitsCharacter;
@property (nonatomic, strong) NSString *data;
@property (nonatomic, assign) UInt32 step;
@property (nonatomic, assign) UInt32 length;

@end

@implementation ISStegoDecoder

- (NSData *)decodeStegoImage:(id)image
                       error:(NSError **)error {
    NSParameterAssert(image);
    
    NSData *data = nil;
    
    if ([self hasDataInImage:image
                       error:error]) {
        NSString *base64 = Substring(self.data, DATA_PREFIX, DATA_SUFFIX);
        
        data = [[NSData alloc] initWithBase64EncodedString:base64
                                                   options:0];
        
    } else {
        if (error != NULL) {
            *error = ErrorForDomainCode(ISStegoErrorDomainCodeNoDataInImage);
        }
    }
    
    return data;
}

- (BOOL)hasDataInImage:(id)image
                 error:(NSError **)error {
    CGImageRef inputCGImage = [ISStegoUtilities imageRefForImage:image];
    NSUInteger width = CGImageGetWidth(inputCGImage);
    NSUInteger height = CGImageGetHeight(inputCGImage);
    
    NSUInteger size = height * width;
    UInt32 *pixels;
    pixels = (UInt32 *) calloc(size, sizeof(UInt32));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pixels,
                                                 width,
                                                 height,
                                                 BITS_PER_COMPONENT,
                                                 BYTES_PER_PIXEL * width,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), inputCGImage);
    
    [self searchDatainPixels:pixels
                    withSize:size
                       error:error];
    
    free(pixels);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    return [self hasData];
}

#pragma mark - Pixel operations

- (void)searchDatainPixels:(UInt32 *)pixels
                  withSize:(NSUInteger)size
                     error:(NSError **)error {
    [self reset];
    
    UInt32 pixelPosition = 0;
    
    while (pixelPosition < SizeOfInfoLength()) {
        [self getDataWithPixel:pixels[pixelPosition]];
        pixelPosition++;
    }
    
    [self reset];
    
    int pixelsToHide = self.length * BITS_PER_COMPONENT;
    
    double ratio = (size - pixelPosition) / pixelsToHide;
    
    int salt = ratio;
    
    while (pixelPosition <= size) {
        [self getDataWithPixel:pixels[pixelPosition]];
        pixelPosition += salt;
        
        if (Contains(self.data, DATA_SUFFIX)) {
            break;
        }
    }
}

- (void)reset {
    self.currentShift = INITIAL_SHIFT;
    self.bitsCharacter = 0;
}

- (void)getDataWithPixel:(UInt32)pixel {
    [self getDataWithColor:Color(pixel, ColorToStep(self.step))];
}

- (void)getDataWithColor:(UInt32)color {
    if (self.currentShift == 0) {
        UInt32 bit = color & 1;
        self.bitsCharacter = (bit << self.currentShift) | self.bitsCharacter;
        
        if (self.step < SizeOfInfoLength()) {
            [self getLength];
        } else {
            [self getCharacter];
        }
        
        self.currentShift = INITIAL_SHIFT;
    } else {
        UInt32 bit = color & 1;
        self.bitsCharacter = (bit << self.currentShift) | self.bitsCharacter;
        self.currentShift--;
    }
    self.step++;
}

- (void)getLength {
    self.length = AddBits(self.length , self.bitsCharacter, self.step % (BITS_PER_COMPONENT - 1));
    
    self.bitsCharacter = 0;
}

- (void)getCharacter {
    NSString *character = [NSString stringWithFormat:@"%c", (unsigned int)self.bitsCharacter];
    
    self.bitsCharacter = 0;
    
    if (self.data) {
        self.data = [NSString stringWithFormat:@"%@%@", self.data, character];
    } else {
        self.data = character;
    }
}

#pragma mark - Validation

- (BOOL)hasData {
    return ([self.data length] > 0
            && Contains(self.data, DATA_PREFIX)
            && Contains(self.data, DATA_SUFFIX))  ? YES : NO;
}

@end

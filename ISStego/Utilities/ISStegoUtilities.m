//
//  ISStegoUtilities.m
//  ISStego
//
//  Created by Isaac Stevao Sena on 26/01/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import "ISStegoUtilities.h"
#import "ISStegoDefaults.h"
#import <TargetConditionals.h>
#import "ISStegoError.h"
#import <CommonCrypto/CommonCrypto.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

CGContextRef ISCGContextCreate(CGImageRef image, uint32_t *pixels) {
  NSUInteger width = CGImageGetWidth(image);
  NSUInteger height = CGImageGetHeight(image);
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  
  CGContextRef context = CGBitmapContextCreate(pixels,
                                               width,
                                               height,
                                               BITS_PER_COMPONENT,
                                               BYTES_PER_PIXEL * width,
                                               colorSpace,
                                               kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
  
  CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
  
  CGColorSpaceRelease(colorSpace);
  
  return context;
}

uint32_t ISChannelsToEncode(BOOL useRed, BOOL useGreen, BOOL useBlue, BOOL useAlpha) {
  uint32_t channelsToEncode = 0;
  
  if (useRed)
    channelsToEncode = channelsToEncode | ISStegoChannelCodeRed;
  
  if (useGreen)
    channelsToEncode = channelsToEncode | ISStegoChannelCodeGreen;
  
  if (useBlue)
    channelsToEncode = channelsToEncode | ISStegoChannelCodeBlue;
  
  if (useAlpha)
    channelsToEncode = channelsToEncode | ISStegoChannelCodeAlpha;
  
  return channelsToEncode;
}

NSData *ISDataOfObject(id object, NSError **error) {
  if (!object) return nil;
  
  NSData *data;
  if ([object isKindOfClass:NSData.class]) {
    data = object;
  } else if ([object isKindOfClass:NSString.class]) {
    data = [object dataUsingEncoding:NSUTF8StringEncoding];
  } else {
    ISErrorForDomainCode(ISStegoErrorDomainCodeWrongParameterKind, error);
    return nil;
  }
  
  return data;
}

uint32_t ISChannel(uint32_t channels, uint8_t shift) {
  return (channels >> 8 * shift) & 0x1;
}

uint8_t ISNumberOfChannelsUsed(uint32_t channels) {
  uint32_t red   = ISChannel(channels, 0);
  uint32_t green = ISChannel(channels, 1);
  uint32_t blue  = ISChannel(channels, 2);
  uint32_t alpha = ISChannel(channels, 3);
  
  uint8_t numberOfChannelsUsed = 0;
  
  if (alpha) numberOfChannelsUsed++;
  if (red) numberOfChannelsUsed++;
  if (green) numberOfChannelsUsed++;
  if (blue) numberOfChannelsUsed++;
  
  return numberOfChannelsUsed;
}

NSDictionary* ISInfoDictionary(uint32_t totalBits, uint32_t totalBitsToHide, uint32_t channelsToEncode, uint8_t bitPlanes) {
  uint8_t numberOfChannelsUsed = ISNumberOfChannelsUsed(channelsToEncode);
  
  uint32_t bitsAvailableTohide = (numberOfChannelsUsed*totalBits)/SIZE_BITS_OF_CHANNELS;
  
  NSDictionary *imageInfo = @{@"totalPixels" : @(totalBits/(BITS_PER_COMPONENT*BYTES_PER_PIXEL)), @"totalBytes" : @(totalBits/BITS_PER_COMPONENT), @"totalBits" : @(totalBits), @"bitsPerPlane" : @(totalBits/MAX_PLANES)};
  
  double totalBytesToHide = (double)totalBitsToHide/BITS_PER_COMPONENT;
  
  NSDictionary *dataInfo = @{@"totalBytesToHide" : @(totalBytesToHide), @"totalBitsToHide" : @(totalBitsToHide)};
  
  NSDictionary *stegoImage = @{@"channelsUsed" : @(numberOfChannelsUsed), @"bitPlanesUsed" : @(bitPlanes), @"bitsAvailableTohide" : @(bitsAvailableTohide)};
  
  NSDictionary *info = @{@"image" : imageInfo, @"data" : dataInfo, @"stegoImage" : stegoImage};
  
  return [info copy];
}

#pragma mark - Rand Utilities

void ISSRand(NSData *password) {
  uint8_t hash[CC_SHA256_DIGEST_LENGTH];
  
  if (!password) {
    password = [NSData data];
  }
  
  if (CC_SHA256([password bytes], (uint32_t)[password length], hash)) {
    uint32_t seed = 0;
    
    for (int i = 0; i < 4; i++) {
      uint32_t number = 0;
      for (int j = 0; j < 4; j++) {
        number |= hash[(i*4)+j] << 8 * j;
      }
      seed = seed ^ number;
    }

    srand(seed);
  }
}

// unbiased random generator
int	ISRandUniform(uint32_t threshold) {
  int n = threshold + 1;
  int remainder = RAND_MAX % n;
  int x;
  do {
    x = rand();
  } while (x >= RAND_MAX - remainder);
  
  return x % n;
}

#pragma mark - Array Utilities

NSArray *ISShuffledArray(NSArray *array) {
  NSMutableArray *shuffledArray = [array mutableCopy];
  uint32_t arrayCount = (uint32_t)[shuffledArray count];
  
  for (uint32_t i = arrayCount - 1; i > 0; i--) {
    int j = ISRandUniform(i);
    [shuffledArray exchangeObjectAtIndex:i withObjectAtIndex:j];
  }
  return [shuffledArray copy];
}

NSArray *ISShuffledArrayOfBits(uint32_t n, uint32_t channels) {
  NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:n];
  
  uint32_t red   = ISChannel(channels, 0);
  uint32_t green = ISChannel(channels, 1);
  uint32_t blue  = ISChannel(channels, 2);
  uint32_t alpha = ISChannel(channels, 3);
  
  for (int i = 0; i < n; i++) {
    if (   (red   && ((i % 4) == 3))
        || (green && ((i % 4) == 2))
        || (blue  && ((i % 4) == 1))
        || (alpha && ((i % 4) == 0)) ) {
      [mutableArray addObject:@(i)];
    }
  }
  
  if (mutableArray.count > 0) {
    NSArray *finalArray = [NSArray arrayWithArray:mutableArray];
    
    return ISShuffledArray(finalArray);
  } else {
    return nil;
  }
}

NSArray *ISRemoveObjectsOfArray(NSArray *array, NSArray *objects) {
  NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
  
  for (NSObject *object in objects) {
    [mutableArray removeObject:object];
  }
  
  return [mutableArray copy];
}

NSArray *ISRemoveNumbersInRangeFromArray(NSArray *array, NSRange range) {
  NSMutableArray *numbersToRemove = [NSMutableArray arrayWithCapacity:range.length];
  
  for (int i = 0; i < range.length; i++) {
    int number = (int)range.location + i;
    [numbersToRemove addObject:@(number)];
  }
  
  return ISRemoveObjectsOfArray(array, numbersToRemove);
}

#pragma mark - Image Utilities

CGImageRef ISCGImageCreateWithImage(id image) {
  CGImageRef imageRef = nil;
  
#if TARGET_OS_IPHONE
  NSCAssert([image isKindOfClass:UIImage.class], @"image must be kind of UIImage");
  imageRef = (CGImageRef)CFRetain([image CGImage]);
#else
  NSCAssert([image isKindOfClass:NSImage.class], @"image must be kind of NSImage");
  NSData *data = [image TIFFRepresentation];
  CFDataRef dataRef = (CFDataRef)CFBridgingRetain(data);
  CGImageSourceRef source = CGImageSourceCreateWithData(dataRef, NULL);
  imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
  CFRelease(dataRef);
  CFRelease(source);
#endif
  
  return imageRef;
}

id ISImage(CGImageRef imageRef) {
  id image = nil;
#if TARGET_OS_IPHONE
  image = [UIImage imageWithCGImage:imageRef];
#else
  image = [[NSImage alloc] initWithCGImage:imageRef
                                      size:NSZeroSize];
#endif
  return image;
}

NSString *GetBitStringForInt(int value, Byte numberOfBytes) {
  NSString *bits = @"";

  for(int i = 0; i < 8 * numberOfBytes; i ++) {
    int bitwise = (1 << i);

    if (i % 8 == 0) {
      bits = [NSString stringWithFormat:@" %@", bits];
    }

    bits = [NSString stringWithFormat:@"%i%@", value & bitwise ? 1 : 0, bits];
  }

  return bits;
}

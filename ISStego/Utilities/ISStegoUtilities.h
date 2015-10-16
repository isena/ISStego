//
//  ISStegoUtilities.h
//  ISStego
//
//  Created by Isaac Stevao Sena on 26/01/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM(NSInteger, ISStegoChannelCode) {
  ISStegoChannelCodeRed   = 0x1 << 8 * 0,
  ISStegoChannelCodeGreen = 0x1 << 8 * 1,
  ISStegoChannelCodeBlue  = 0x1 << 8 * 2,
  ISStegoChannelCodeAlpha = 0x1 << 8 * 3
};

CGContextRef ISCGContextCreate(CGImageRef image, uint32_t *pixels);

uint32_t ISChannelsToEncode(BOOL useRed, BOOL useGreen, BOOL useBlue, BOOL useAlpha);

NSData *ISDataOfObject(id object, NSError **error);

NSDictionary* ISInfoDictionary(uint32_t totalBits, uint32_t totalBitsToHide, uint32_t channelsToEncode, uint8_t bitPlanes);

#pragma mark - Array Utilities

NSArray *ISShuffledArrayOfBits(uint32_t n, uint32_t channels);

NSArray *ISRemoveNumbersInRangeFromArray(NSArray *array, NSRange range);

#pragma mark - Rand Utilities

void ISSRand(NSData *password);

int	ISRandUniform(uint32_t threshold);

#pragma mark - Image Utilities

CGImageRef ISCGImageCreateWithImage(id image);

id ISImage(CGImageRef imageRef);

NSString *GetBitStringForInt(int value, Byte numberOfBytes);

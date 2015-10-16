//
//  ISStegoEncoder.m
//  ISSteganography
//
//  Created by Isaac Stevao Sena on 7/25/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import "ISStegoEncoder.h"
#import "ISStegoUtilities.h"
#import "ISStegoDefaults.h"
#import "ISStegoError.h"
#import <CoreGraphics/CoreGraphics.h>

@interface ISStegoEncoder ()

@end

@implementation ISStegoEncoder

- (id)hideData:(id)data image:(id)image password:(id)password channels:(NSInteger)channels error:(NSError **)error {
  if (!image || !data) {
    ISErrorForDomainCode(ISStegoErrorDomainCodeNullParameter, error);
    return nil;
  }
  
  NSData *passwordData = ISDataOfObject(password, error);
  if (*error) return nil;
  
  NSData *dataFromInput = ISDataOfObject(data, error);
  if (*error) return nil;
  
  CGImageRef inputCGImage = ISCGImageCreateWithImage(image);
  
  uint32_t size = (uint32_t)(CGImageGetWidth(inputCGImage) * CGImageGetHeight(inputCGImage));
  
  uint32_t *pixels = (uint32_t *)calloc(size, sizeof(uint32_t));
  
  CGContextRef context = ISCGContextCreate(inputCGImage, pixels);
  
  CGImageRelease(inputCGImage);
  
  ISSRand(passwordData);
  
  NSData *dataToEncode = [self dataToEncode:dataFromInput];
  
  [self encodeData:dataToEncode pixels:pixels size:size channels:(uint32_t)channels error:error];
  
  if (*error) {
    CGContextRelease(context);
    free(pixels);
    
    return nil;
  }
  
  CGImageRef newCGImage = CGBitmapContextCreateImage(context);
  id processedImage = ISImage(newCGImage);
  CGImageRelease(newCGImage);
  
  CGContextRelease(context);
  free(pixels);
  
  return processedImage;
}

#pragma mark - Pixel operations

- (void)encodeData:(NSData *)data pixels:(uint32_t *)pixels size:(uint32_t)size channels:(uint32_t)channels error:(NSError **)error {
  uint32_t dataLength = (uint32_t)[data length];
  uint32_t bitsPerPlan = size * BYTES_PER_PIXEL;
  uint32_t bytesInImage = size * BYTES_PER_PIXEL;
  uint32_t totalBits = bytesInImage * BITS_PER_COMPONENT;
  uint32_t bitsToHide = dataLength * BITS_PER_COMPONENT;
  uint32_t totalBitsToHide = (uint32_t)(bitsToHide + SIZE_BITS_OF_CHANNELS);
  uint32_t pixelPositionToARGB = ISRandUniform(size - 1);
  
  uint32_t pixelToARGB = pixels[pixelPositionToARGB];

  uint32_t bitChanges = 0;
  
  for (int i = 0; i < BYTES_PER_PIXEL; i++) {
    uint32_t bitInPixel = (pixelToARGB & (0x01 << 8 * i));
    uint32_t color = (channels & (0x01 << 8 * i));
    
    if (bitInPixel != color) {
      bitChanges++;
    }
    
    pixelToARGB &= ~(0x1 << 8 * i);
  }
  
  pixelToARGB |= channels;
  
  pixels[pixelPositionToARGB] = pixelToARGB;
  
  NSArray *arrayOfPositions = ISShuffledArrayOfBits(bitsPerPlan, channels);
  
  NSArray *arrayOfPositionsPlane1 = ISRemoveNumbersInRangeFromArray(arrayOfPositions, NSMakeRange(pixelPositionToARGB * BYTES_PER_PIXEL, BYTES_PER_PIXEL));
  
  int residualBitsOfPlane1 = bitsToHide - (int)arrayOfPositionsPlane1.count;
  
  uint8_t bitPlanes = 1;
  int remainder = 0;
  
  if (residualBitsOfPlane1 > 0) {
    bitPlanes += (residualBitsOfPlane1 / arrayOfPositions.count);
    remainder = residualBitsOfPlane1 % arrayOfPositions.count;
    if (remainder > 0) bitPlanes++;
  }
  
  _info = ISInfoDictionary(totalBits, totalBitsToHide, channels, bitPlanes);
  
  if (totalBitsToHide > totalBits) {
    ISErrorForDomainCode(ISStegoErrorDomainCodeImageTooSmall, error);
    return;
  }
  
  if (bitPlanes > MAX_PLANES) {
    ISErrorForDomainCode(ISStegoErrorDomainCodeNumberOfChannelsTooSmall, error);
    return;
  }
  
  NSArray *arrayOfAllPositions = nil;
  
  if (bitPlanes > 1) {
    NSMutableArray *mutablearray = [NSMutableArray arrayWithArray:arrayOfPositionsPlane1];
    
    for (int i = 2; i <= bitPlanes; i++) {
      [mutablearray addObjectsFromArray:arrayOfPositions];
    }
    
    if (remainder > 0) {
      NSArray *arrayOfRemainderBits = [arrayOfPositions subarrayWithRange:NSMakeRange(0, remainder)];
      [mutablearray addObjectsFromArray:arrayOfRemainderBits];
    }
    
    arrayOfAllPositions = [mutablearray copy];
  } else {
    arrayOfAllPositions = [arrayOfPositionsPlane1 subarrayWithRange:NSMakeRange(0, bitsToHide)];
  }
  
  int arrayPosition = 0;
  
  uint8_t currentBitPlane = 1;

  NSMutableArray *changesPerBitPlane = [[NSMutableArray alloc] initWithCapacity:bitPlanes];
  
  uint8_t *bytesData = (uint8_t *)malloc(dataLength);
  const void *bytes = [data bytes];
  memcpy(bytesData, bytes, dataLength);
  
  for (int byteIterator = 0; byteIterator < dataLength; byteIterator++) {
    uint8_t byteData = bytesData[byteIterator];
    
    for (int bitIterator = 0; bitIterator < 8; bitIterator++) {
      NSNumber *positionNumber = arrayOfAllPositions[arrayPosition];
      
      int count = (byteIterator * BITS_PER_COMPONENT) + bitIterator;
      int thresholdOfCurrentLSB = (int)(arrayOfPositionsPlane1.count + ((currentBitPlane - 1) * arrayOfPositions.count));
      if (count == thresholdOfCurrentLSB){
        NSDictionary *dictionaryForBitChanges = [self dictionaryForBitChanges:bitChanges bitPlane:currentBitPlane bitsPerPlan:bitsPerPlan];
        [changesPerBitPlane addObject:dictionaryForBitChanges];
        currentBitPlane++;
        bitChanges = 0;
      }
      
      int position = [positionNumber intValue];
      
      int color = position % BYTES_PER_PIXEL;
      
      uint32_t bit;
      
      uint32_t bitToOperation = 0x01000000;
      
      if (byteData & 0x80) {
        bit = bitToOperation;
        bit >>= 8 * color;
        bit <<= (currentBitPlane - 1);
      } else {
        bit = 0;
      }
      
      int pixelNumber = position / BYTES_PER_PIXEL;
      
      uint32_t pixel = pixels[pixelNumber];
      uint32_t colorAndNotInLSB =  (pixel & ~((bitToOperation << (currentBitPlane - 1)) >> 8 * color));
      
      uint32_t bitInPixel = (pixel & ((bitToOperation << (currentBitPlane - 1)) >> 8 * color));

      if (bitInPixel != bit) {
        bitChanges++;
      }
      
      uint32_t newPixel = colorAndNotInLSB | bit;

      pixels[pixelNumber] = newPixel;
      
      arrayPosition++;
      count++;
      byteData *= 2; // = << 2
    }
  }
  
  if (bitChanges != 0) {
    NSDictionary *dictionaryForBitChanges = [self dictionaryForBitChanges:bitChanges bitPlane:currentBitPlane bitsPerPlan:bitsPerPlan];
    [changesPerBitPlane addObject:dictionaryForBitChanges];
  }
  
  NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:_info];
  
  [info setObject:changesPerBitPlane forKeyedSubscript:@"changesPerBitPlane"];
  
  _info = [info copy];
  
  free(bytesData);
}

- (NSDictionary *)dictionaryForBitChanges:(uint32_t)bitChanges
                                 bitPlane:(uint8_t)bitPlane
                              bitsPerPlan:(uint32_t)bitsPerPlan  {
  double bitsChangedPercent = ((double)(bitChanges*100)/bitsPerPlan);
  NSString *description = [NSString stringWithFormat:@"plane %d: %d bits updated (%.2f%%)", bitPlane, bitChanges, ((double)(bitChanges*100)/bitsPerPlan)];
  NSDictionary *dictionary = @{@"bitPlane" : @(bitPlane), @"bitsChanged" : @(bitChanges), @"bitsChangedPercent" : @(bitsChangedPercent), @"description" : description};
  return dictionary;
}

#pragma mark - Data+Header

- (NSData *)dataToEncode:(NSData *)data {
  uint8_t header[SizeOfHeader()];
  header[0] = ISSTEGO_ALGORITHM_VERSION;
  
  uint32_t length = (uint32_t)[data length];
  
  for (int i = (int)SIZE_BYTES_OF_LENGTH - 1; i >= 0; i--) {
    header[i+1] = (length >> 8 * i) & 0xFF;
  }
  
  NSData *dataOfHeader = [[NSData alloc] initWithBytes:&header
                                                length:SizeOfHeader()];
  
  NSMutableData *dataToEncode = [[NSMutableData alloc] init];
  [dataToEncode appendData:dataOfHeader];
  [dataToEncode appendData:data];
  
  return [dataToEncode copy];
}

@end

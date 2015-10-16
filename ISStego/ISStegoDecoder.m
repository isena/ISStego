//
//  ISStegoDecoder.m
//  ISStego
//
//  Created by Isaac Stevao Sena on 7/25/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import "ISStegoDecoder.h"
#import "ISStegoUtilities.h"
#import "ISStegoDefaults.h"
#import "ISStegoError.h"
#import <CoreGraphics/CoreGraphics.h>

@interface ISStegoDecoder ()

@end

@implementation ISStegoDecoder

- (NSData *)decodeStegoImage:(id)image
                    password:(id)password
                       error:(NSError **)error {
  if (!image) {
    ISErrorForDomainCode(ISStegoErrorDomainCodeNullParameter, error);
    return nil;
  }
  
  NSData *passwordData = ISDataOfObject(password, error);
  if (*error) return nil;
  
  CGImageRef inputCGImage = ISCGImageCreateWithImage(image);
  
  uint32_t size = (uint32_t)(CGImageGetWidth(inputCGImage) * CGImageGetHeight(inputCGImage));
  
  uint32_t *pixels = (uint32_t *)calloc(size, sizeof(uint32_t));
  
  CGContextRef context = ISCGContextCreate(inputCGImage, pixels);
  
  CGImageRelease(inputCGImage);
  
  ISSRand(passwordData);
  
  NSData *data = [self searchDatainPixels:pixels
                                 withSize:size
                                    error:error];
  
  free(pixels);
  
  CGContextRelease(context);
  
  return data;
}

#pragma mark - Pixel operations

- (NSData *)searchDatainPixels:(uint32_t *)pixels
                      withSize:(uint32_t)size
                         error:(NSError **)error {
  uint32_t pixelPositionToARGB = ISRandUniform(size - 1);
  uint32_t pixelToARGB = pixels[pixelPositionToARGB];

  uint32_t channelsToEncode = 0;
  
  for (int i = 0; i < SIZE_BITS_OF_CHANNELS; i++) {
    channelsToEncode |= (((pixelToARGB >> 8 * i) & 0x1) << 8 * i);
  }
  
  if (channelsToEncode == 0) {
    ISErrorForDomainCode(ISStegoErrorDomainCodeNoDataInImage, error);
    return nil;
  }
  
  NSArray *arrayOfPositions = ISShuffledArrayOfBits(size * BYTES_PER_PIXEL, channelsToEncode);
  
  NSArray *arrayOfPositionsPlane1 = ISRemoveNumbersInRangeFromArray(arrayOfPositions, NSMakeRange(pixelPositionToARGB * BYTES_PER_PIXEL, BYTES_PER_PIXEL));
  
  NSArray *array;
  
  if (arrayOfPositionsPlane1.count < (SizeOfHeader() * BITS_PER_COMPONENT) + SIZE_BITS_OF_CHANNELS) {
    NSMutableArray *mutablearray = [NSMutableArray arrayWithArray:arrayOfPositionsPlane1];
    
    for (int i = 2; i <= 8; i++) {
      [mutablearray addObjectsFromArray:arrayOfPositions];
    }
    
    array = [mutablearray copy];
  } else {
    array = [arrayOfPositionsPlane1 copy];
  }
  
  uint8_t byte = 0;
  uint8_t header[SizeOfHeader()];
  uint8_t *dataBytes = NULL;
  uint32_t bitsHidden = (uint32_t)array.count * 8;
  size_t dataSize = 0;
  uint8_t currentBitPlane = 1;
  
  for (int bitIterator = 0; bitIterator < bitsHidden; bitIterator++) {
    NSNumber *number = array[bitIterator];
    
    int thresholdOfCurrentLSB = (int)(arrayOfPositionsPlane1.count + (currentBitPlane - 1) * (arrayOfPositions.count));

    if (bitIterator == thresholdOfCurrentLSB) {
      currentBitPlane++;
    }
    
    uint32_t position = [number intValue];
    uint32_t pixelNumber = position / BYTES_PER_PIXEL;
    uint32_t pixel = pixels[pixelNumber];
    uint32_t color = position % BYTES_PER_PIXEL;
    uint32_t bitToOperation = (0x01000000 >> (8 * color)) << (currentBitPlane - 1);
    uint32_t andOperation = pixel & bitToOperation;
    byte <<= 1;
    
    if (andOperation) byte = byte | 1;
    
    if ((bitIterator + 1) % BITS_PER_COMPONENT == 0) { // dealing with header
      uint32_t bytePosition = (bitIterator / BITS_PER_COMPONENT);
      
      if (bitIterator <= SizeOfHeader() * BITS_PER_COMPONENT) {
        header[bytePosition] = byte;
        
        if (header[0] != ISSTEGO_ALGORITHM_VERSION) {
          ISErrorForDomainCode(ISStegoErrorDomainCodeNoDataInImage, error);
          return nil;
        }
        
        if (bytePosition == SizeOfHeader() - 1) {
          uint32_t decodedInteger = 0;
          
          for (int i = 0; i  < SIZE_BYTES_OF_LENGTH; i++) {
            decodedInteger |= (header[SIZE_ALGORITHM_VERSION+i] << 8 * i);
          }
          
          bitsHidden = (uint32_t)(decodedInteger + SizeOfHeader()) * BITS_PER_COMPONENT;
          
          int residualBitsOfPlane1 = (int)(bitsHidden - arrayOfPositionsPlane1.count);
          
          uint8_t bitPlanes = 1;
          int remainder = 0;
          
          if (residualBitsOfPlane1 > 0) {
            bitPlanes += (residualBitsOfPlane1 / arrayOfPositions.count);
            remainder = residualBitsOfPlane1 % arrayOfPositions.count;
            if (remainder > 0) bitPlanes++;
          }
          
          if (bitPlanes > 1) {
            NSMutableArray *mutablearray = [NSMutableArray arrayWithArray:arrayOfPositionsPlane1];
            
            for (int i = 2; i <= bitPlanes; i++) {
              [mutablearray addObjectsFromArray:arrayOfPositions];
            }
            
            if (remainder > 0) {
              NSArray *arrayOfRemainderBits = [arrayOfPositions subarrayWithRange:NSMakeRange(0, remainder)];
              [mutablearray addObjectsFromArray:arrayOfRemainderBits];
            }
            
            array = [mutablearray copy];
          }
        }
      } else { // dealing with data
        if (!dataBytes) {
          dataSize = sizeof(uint8_t) * ((bitsHidden / BITS_PER_COMPONENT) - SizeOfHeader());
          dataBytes = malloc(dataSize);
          if (!dataBytes) {
            ISErrorForDomainCode(ISStegoErrorDomainCodeNullMemoryNotAllocated, error);
            break;
          }
          
          memset(dataBytes, 0, sizeof(dataSize));
        }
        
        uint32_t dataPosition = bytePosition - (uint32_t)SizeOfHeader();
        dataBytes[dataPosition] = byte;
        byte = 0;
      }
    }
  }
  
  NSData *data = nil;
  
  if (dataBytes) {
    data = [NSData dataWithBytes:dataBytes
                          length:dataSize];
    
    free(dataBytes);
  }
  
  return data;
}

@end

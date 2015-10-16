//
//  ISStegoDefaults.m
//  ISSteganography
//
//  Created by Isaac Stevao Sena on 8/2/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import "ISStegoDefaults.h"

int const BYTES_PER_PIXEL = 4;
int const BITS_PER_COMPONENT = 8;

size_t const SIZE_BYTES_OF_LENGTH = 4;

size_t const SIZE_BITS_OF_CHANNELS = 4;

Byte const ISSTEGO_ALGORITHM_VERSION = 1;
size_t const SIZE_ALGORITHM_VERSION = 1;

uint8_t const MAX_PLANES = 8;

size_t SizeOfHeader() {
  return SIZE_ALGORITHM_VERSION + SIZE_BYTES_OF_LENGTH;
}

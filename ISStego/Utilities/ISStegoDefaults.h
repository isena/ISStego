//
//  ISStegoDefaults.h
//  ISSteganography
//
//  Created by Isaac Stevao Sena on 8/2/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import <Foundation/Foundation.h>

extern int const BYTES_PER_PIXEL;
extern int const BITS_PER_COMPONENT;

extern size_t const SIZE_BYTES_OF_LENGTH;

extern size_t const SIZE_BITS_OF_CHANNELS;

extern Byte const ISSTEGO_ALGORITHM_VERSION;
extern size_t const SIZE_ALGORITHM_VERSION;

extern uint8_t const MAX_PLANES;

size_t SizeOfHeader();

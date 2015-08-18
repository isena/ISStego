//
//  ISStegoDefaults.h
//  ISSteganography
//
//  Created by Isaac Stevao Sena on 8/2/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import <Foundation/Foundation.h>

extern int const INITIAL_SHIFT;

extern int const BYTES_PER_PIXEL;
extern int const BITS_PER_COMPONENT;

extern int const BYTES_OF_LENGTH;

extern NSString *const DATA_PREFIX;
extern NSString *const DATA_SUFFIX;

int SizeOfInfoLength();

int MinPixels();

//
//  ISStegoDefaults.m
//  ISSteganography
//
//  Created by Isaac Stevao Sena on 8/2/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import "ISStegoDefaults.h"

int const INITIAL_SHIFT = 7;

int const BYTES_PER_PIXEL = 4;
int const BITS_PER_COMPONENT = 8;

int const BYTES_OF_LENGTH = 4;

NSString *const DATA_PREFIX = @"<m>";
NSString *const DATA_SUFFIX = @"</m>";

int SizeOfInfoLength() {
    return BYTES_OF_LENGTH * BITS_PER_COMPONENT;
}

int MinPixelsToMessage() {
    return (int)([DATA_PREFIX length] + [DATA_SUFFIX length]) * BITS_PER_COMPONENT;
}

int MinPixels() {
    return SizeOfInfoLength() + MinPixelsToMessage();
}

//
//  ISPixelUtilities.m
//  ISStego
//
//  Created by Isaac Stevao Sena on 8/2/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import "ISPixelUtilities.h"

@implementation ISPixelUtilities

UInt32 mask8(UInt32 x) {
    return x & 0xFF;
}

UInt32 color(UInt32 x, int shift) {
    return mask8(x >> 8 * shift);
}

UInt32 addBits(UInt32 number1, UInt32 number2, int shift) {
    return (number1 | mask8(number2) << 8 * shift);
}

UInt32 newPixel(UInt32 pixel, UInt32 shiftedBits, int shift) {
    UInt32 bit = (shiftedBits & 1) << 8 * shift;
    UInt32 colorAndNot =  (pixel & ~(1 << 8 * shift));
    return colorAndNot | bit;
}

ISPixelColor colorToStep(UInt32 step) {
    if (step % 3 == 0) {
        return ISPixelColorBlue;
    } else if (step % 2 == 0) {
        return ISPixelColorGreen;
    } else {
        return ISPixelColorRed;
    }
}

@end

//
//  ISPixelUtilities.m
//  ISStego
//
//  Created by Isaac Stevao Sena on 8/2/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import "ISPixelUtilities.h"

UInt32 Mask8(UInt32 x) {
    return x & 0xFF;
}

UInt32 Color(UInt32 x, int shift) {
    return Mask8(x >> 8 * shift);
}

UInt32 AddBits(UInt32 number1, UInt32 number2, int shift) {
    return (number1 | Mask8(number2) << 8 * shift);
}

UInt32 NewPixel(UInt32 pixel, UInt32 shiftedBits, int shift) {
    UInt32 bit = (shiftedBits & 1) << 8 * shift;
    UInt32 colorAndNot =  (pixel & ~(1 << 8 * shift));
    return colorAndNot | bit;
}

ISPixelColor ColorToStep(UInt32 step) {
    if (step % 3 == 0) {
        return ISPixelColorBlue;
    } else if (step % 2 == 0) {
        return ISPixelColorGreen;
    } else {
        return ISPixelColorRed;
    }
}

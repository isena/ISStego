//
//  ISPixelUtilities.h
//  ISStego
//
//  Created by Isaac Stevao Sena on 8/2/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ISPixelColor) {
    ISPixelColorRed,
    ISPixelColorGreen,
    ISPixelColorBlue
};

@interface ISPixelUtilities : NSObject

UInt32 color(UInt32 x, int shift);

UInt32 newPixel(UInt32 pixel, UInt32 shiftedBits, int shift);

UInt32 addBits(UInt32 number1, UInt32 number2, int shift);

ISPixelColor colorToStep(UInt32 pixel);

@end

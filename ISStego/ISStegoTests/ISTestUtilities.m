//
//  ISTestUtilities.m
//  ISSteganography
//
//  Created by Isaac Stevao Sena on 7/25/15.
//  Copyright (c) 2015 Black Bean. All rights reserved.
//

#import "ISTestUtilities.h"

double const TIME_EXPECTATION = 100.0;
NSString *const ORIGINAL_IMAGE_NAME = @"image";
NSString *const SMALL_IMAGE_NAME = @"image_8x8";
NSString *const BIG_IMAGE_NAME = @"image_100x100";
NSString *const STEGO_IMAGE_NAME = @"stegoImage";
NSString *const STEGO_IMAGE_TO_SAVE_NAME = @"imageToSave";
NSString *const TYPE_PNG = @"png";
NSString *const TYPE_JPG = @"jpg";
NSString *const TEXT_TO_HIDE = @"text to hide";

NSString *type() {
    return TYPE_PNG;
}

@implementation ISTestUtilities

+ (UIImage *)imageNamed:(NSString *)name {
    return [self imageNamed:name
                     ofType:type()];
}

+ (UIImage *)imageNamed:(NSString *)name
                 ofType:(NSString *)type {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    NSString *imagePath = [bundle pathForResource:name
                                           ofType:type];
    
    return [UIImage imageWithContentsOfFile:imagePath];
}

+ (NSString *)filePathToFilename:(NSString *)filename
                            type:(NSString *)type {
    NSString *file = [NSString stringWithFormat:@"%@.%@", filename, type];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:file];
}
@end

NSString *const BIG_TEXT_TO_HIDE = @"biiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiig text to hide";

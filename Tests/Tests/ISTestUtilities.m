//
//  ISTestUtilities.m
//  ISSteganography
//
//  Created by Isaac Stevao Sena on 7/25/15.
//  Copyright (c) 2015 Black Bean. All rights reserved.
//

#import "ISTestUtilities.h"

#if TARGET_OS_IPHONE
    #import <UIKit/UIKit.h>
#else
    #import <AppKit/AppKit.h>
#endif

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

+ (id)imageNamed:(NSString *)name {
    return [self imageNamed:name
                     ofType:type()];
}

+ (id)imageNamed:(NSString *)name
          ofType:(NSString *)type {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    NSString *filepath = [bundle pathForResource:name
                                          ofType:type];
    
    return [self imageToFilepath:filepath];
}

+ (id)imageToFilepath:(NSString *)filepath {
#if TARGET_OS_IPHONE
    return [UIImage imageWithContentsOfFile:filepath];
#else
    return [[NSImage alloc] initWithContentsOfFile:filepath];
#endif
}

+ (BOOL)saveImage:(id)image
             file:(NSString *)path {
#if TARGET_OS_IPHONE
    return [UIImagePNGRepresentation(image) writeToFile:path
                                             atomically:YES];
#else
    CGImageRef cgRef = [image CGImageForProposedRect:NULL
                                             context:nil
                                               hints:nil];
    
    NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
    
    [newRep setSize:[image size]];
    
    NSData *pngData = [newRep representationUsingType:NSPNGFileType
                                           properties:nil];
    
    return [pngData writeToFile:path atomically:YES];
#endif
}

+ (NSString *)filePathToFilename:(NSString *)filename
                            type:(NSString *)type {
    NSString *file = [NSString stringWithFormat:@"%@.%@", filename, type];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:file];
}

@end

NSString *const BIG_TEXT_TO_HIDE = @"biiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiig text to hide";

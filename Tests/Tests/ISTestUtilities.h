//
//  ISTestUtilities.h
//  ISSteganography
//
//  Created by Isaac Stevao Sena on 7/25/15.
//  Copyright (c) 2015 Black Bean. All rights reserved.
//

#import <Foundation/Foundation.h>

extern double const TIME_EXPECTATION;
extern NSString *const IMAGE_NAME;
extern NSString *const SMALL_IMAGE_NAME;
extern NSString *const BIG_IMAGE_NAME;
extern NSString *const STEGO_IMAGE_NAME;
extern NSString *const STEGO_IMAGE_TO_SAVE_NAME;
extern NSString *const TYPE_PNG;
extern NSString *const TYPE_JPG;
extern NSString *const TEXT_TO_HIDE;
extern NSString *const BIG_TEXT_TO_HIDE;
extern NSString *const PASSWORD;

NSString *type();

@interface ISTestUtilities : NSObject

+ (id)imageNamed:(NSString *)name;

+ (id)imageToFilepath:(NSString *)filepath;

+ (NSString *)filePathToFilename:(NSString *)filename
                            type:(NSString *)type;

+ (BOOL)saveImage:(id)image
             file:(NSString *)path;

@end

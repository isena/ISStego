//
//  ISSteganographer.h
//  ISStego
//
//  Created by Isaac Stevao Sena on 7/26/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Objective-C library for Steganography
 *
 */
@interface ISSteganographer : NSObject

typedef void(^ISStegoEncoderCompletionBlock)(id image, NSDictionary *info, NSError *error);

typedef void(^ISStegoDecoderCompletionBlock)(NSData *data, NSError *error);

/**
 * Encode data into an image.
 *
 * @param data The data to be encoded/hidden.
 * @param image The image used to hide the data.
 * @param password The password used to spread the data pseudo-randomly.
 * @param channels The channels (ARGB) used to encode the data.
 * @param completionBlock A block object to be executed when operation finishes. This block has no return value and takes two arguments:
 * If successful, it will return an stego-object (an image with the hidden data) and the error object returned will be nil.
 * If failed, the error object will be populated with the error that caused the encode to fail.
 */
+ (void)hideData:(id)data
           image:(id)image
        password:(id)password
        channels:(NSInteger)channels
 completionBlock:(ISStegoEncoderCompletionBlock)completionBlock;

/**
 * Decode data from an image.
 *
 * @param image The image with the data encoded.
 * @param password The password used to get the spread data pseudo-randomly.
 * @param completionBlock A block object to be executed when operation finishes. This block has no return value and takes two arguments:
 * If successful, it will return the hidden data and the error object returned will be nil.
 * If failed, the error object will be populated with the error that caused the decode to fail.
 */
+ (void)dataFromImage:(id)image
             password:(id)password
      completionBlock:(ISStegoDecoderCompletionBlock)completionBlock;

+ (NSInteger)channelsRed:(BOOL)red
                   green:(BOOL)green
                    blue:(BOOL)blue
                   alpha:(BOOL)alpha;

@end

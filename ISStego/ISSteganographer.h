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

typedef void(^ISStegoEncoderCompletionBlock)(id image, NSError *error);

typedef void(^ISStegoDecoderCompletionBlock)(NSData *data, NSError *error);

/**
 * Encode data into an image.
 *
 * @param data The data to be encoded/hidden.
 * @param image The image used to hide the data.
 * @param completionBlock A block object to be executed when operation finishes. This block has no return value and takes two arguments:
 * If successful, it will return an stego-object (an image with the hidden data) and the error object returned will be nil.
 * If failed, the error object will be populated with the error that caused the encode to fail.
 */
+ (void)hideData:(id)data
       withImage:(id)image
 completionBlock:(ISStegoEncoderCompletionBlock)completionBlock;

/**
 * Decode data from an image.
 *
 * @param image The image with the data encoded.
 * @param completionBlock A block object to be executed when operation finishes. This block has no return value and takes two arguments:
 * If successful, it will return the hidden data and the error object returned will be nil.
 * If failed, the error object will be populated with the error that caused the decode to fail.
 */
+ (void)dataFromImage:(id)image
      completionBlock:(ISStegoDecoderCompletionBlock)completionBlock;

@end

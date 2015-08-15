//
//  ISSteganographer.m
//  ISStego
//
//  Created by Isaac Stevao Sena on 7/26/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import "ISSteganographer.h"
#import "ISStegoEncoder.h"
#import "ISStegoDecoder.h"

@implementation ISSteganographer

+ (void)hideData:(id)data
       withImage:(id)image
 completionBlock:(ISStegoEncoderCompletionBlock)completionBlock {
    dispatch_queue_t queue = dispatch_queue_create("steganography.encode.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        @autoreleasepool {
            ISStegoEncoder *encoder = [[ISStegoEncoder alloc] init];
            
            NSError *error = nil;
            
            id stegoImage = [encoder stegoImageForImage:image
                                                   data:data
                                                  error:&error];
            
            completionBlock(stegoImage, error);
            
            encoder = nil;
        }
    });
}

+ (void)dataFromImage:(id)image
      completionBlock:(ISStegoDecoderCompletionBlock)completionBlock {
    dispatch_queue_t queue = dispatch_queue_create("steganography.decode.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        @autoreleasepool {
            NSError *error = nil;
            
            ISStegoDecoder *decoder = [[ISStegoDecoder alloc] init];
            
            NSData *data = [decoder decodeStegoImage:image
                                               error:&error];
            
            completionBlock(data, error);
            
            decoder = nil;
        }
    });
}

@end

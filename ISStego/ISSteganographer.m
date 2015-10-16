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
#import "ISStegoUtilities.h"

@implementation ISSteganographer

+ (void)hideData:(id)data
           image:(id)image
        password:(id)password
        channels:(NSInteger)channels
 completionBlock:(ISStegoEncoderCompletionBlock)completionBlock {
  dispatch_queue_t queue = dispatch_queue_create("steganography.encode.queue", DISPATCH_QUEUE_CONCURRENT);
  
  dispatch_async(queue, ^{
    @autoreleasepool {
      ISStegoEncoder *encoder = [[ISStegoEncoder alloc] init];
      
      NSError *error = nil;
      
      id stegoImage = [encoder hideData:data
                                  image:image
                               password:password
                               channels:channels
                                  error:&error];
      
      completionBlock(stegoImage, encoder.info, error);
      
      encoder = nil;
    }
  });
}

+ (void)dataFromImage:(id)image
             password:(id)password
      completionBlock:(ISStegoDecoderCompletionBlock)completionBlock {
  dispatch_queue_t queue = dispatch_queue_create("steganography.decode.queue", DISPATCH_QUEUE_CONCURRENT);
  
  dispatch_async(queue, ^{
    @autoreleasepool {
      NSError *error = nil;
      
      ISStegoDecoder *decoder = [[ISStegoDecoder alloc] init];
      
      NSData *data = [decoder decodeStegoImage:image
                                      password:password
                                         error:&error];
      
      completionBlock(data, error);
      
      decoder = nil;
    }
  });
}

+ (NSInteger)channelsRed:(BOOL)red
                   green:(BOOL)green
                    blue:(BOOL)blue
                   alpha:(BOOL)alpha {
  return ISChannelsToEncode(red, green, blue, alpha);
}

@end

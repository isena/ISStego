//
//  ISSteganographer.h
//  ISStego
//
//  Created by Isaac Stevao Sena on 7/26/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISSteganographer : NSObject

typedef void(^ISStegoEncoderCompletionBlock)(id image, NSError *error);

typedef void(^ISStegoDecoderCompletionBlock)(NSData *data, NSError *error);

+ (void)hideData:(id)data
       withImage:(id)image
 completionBlock:(ISStegoEncoderCompletionBlock)completionBlock;

+ (void)dataFromImage:(id)image
      completionBlock:(ISStegoDecoderCompletionBlock)completionBlock;

@end

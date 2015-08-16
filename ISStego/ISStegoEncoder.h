//
//  ISStegoEncoder.h
//  ISSteganography
//
//  Created by Isaac Stevao Sena on 7/25/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISStegoEncoder : NSObject

- (id)stegoImageForImage:(id)image
                    data:(id)data
                   error:(NSError **)error;

@end

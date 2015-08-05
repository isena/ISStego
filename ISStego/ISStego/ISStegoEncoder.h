//
//  ISStegoEncoder.h
//  ISSteganography
//
//  Created by Isaac Stevao Sena on 7/25/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ISStegoEncoder : NSObject

- (UIImage *)stegoImageForImage:(UIImage *)image
                           data:(id)data
                          error:(NSError **)error;

@end

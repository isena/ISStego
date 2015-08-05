//
//  ISStegoDecoder.h
//  ISStego
//
//  Created by Isaac Stevao Sena on 7/25/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ISStegoDecoder : NSObject

- (NSData *)decodeStegoImage:(UIImage *)image
                       error:(NSError **)error;

@end

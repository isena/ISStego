//
//  ISStegoDecoder.h
//  ISStego
//
//  Created by Isaac Stevao Sena on 7/25/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISStegoDecoder : NSObject

- (NSData *)decodeStegoImage:(id)image
                       error:(NSError **)error;

@end

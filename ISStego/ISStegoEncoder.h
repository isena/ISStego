//
//  ISStegoEncoder.h
//  ISSteganography
//
//  Created by Isaac Stevao Sena on 7/25/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISStegoEncoder : NSObject

@property (readonly, copy) NSDictionary *info;

- (id)hideData:(id)data image:(id)image password:(id)password channels:(NSInteger)channels error:(NSError **)error;

@end

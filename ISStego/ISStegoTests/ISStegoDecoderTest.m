//
//  ISStegoDecoderTest.m
//  ISSteganography
//
//  Created by Isaac Stevao Sena on 7/25/15.
//  Copyright (c) 2015 Black Bean. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ISStegoDecoder.h"
#import "ISTestUtilities.h"

@interface ISStegoDecoderTest : XCTestCase

@end

@implementation ISStegoDecoderTest

- (void)testDecodeStegoImage {
    UIImage *image  = [ISTestUtilities imageNamed:STEGO_IMAGE_NAME
                                           ofType:type()];
    
    XCTAssertNotNil(image, @"image is nil");
    
    ISStegoDecoder *decoder = [[ISStegoDecoder alloc] init];
    
    NSError *error = nil;
    
    NSData *data = [decoder decodeStegoImage:image
                                       error:&error];
    
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    
    XCTAssertTrue([string isEqual:TEXT_TO_HIDE], @"%@ is not equal to %@", string, TEXT_TO_HIDE);
}

#pragma mark - Exception

- (void)testNilImage {
    ISStegoDecoder *decoder = [[ISStegoDecoder alloc] init];
    
    NSError *error = nil;
    
    XCTAssertThrows([decoder decodeStegoImage:nil
                                        error:&error]);
}

@end

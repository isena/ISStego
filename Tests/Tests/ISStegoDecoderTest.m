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
  NSString *imageName = STEGO_IMAGE_NAME;
  NSString *password = PASSWORD;
  id initialImage  = [ISTestUtilities imageNamed:imageName];
  XCTAssertNotNil(initialImage, @"image is nil");
  
  ISStegoDecoder *decoder = [[ISStegoDecoder alloc] init];
  
  NSError *error = nil;
  
  NSData *data = [decoder decodeStegoImage:initialImage
                                  password:password
                                     error:&error];
  
  NSString *string = [[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];
  
  XCTAssertTrue([string isEqual:TEXT_TO_HIDE], @"%@ is not equal to %@", string, TEXT_TO_HIDE);
  
  decoder = nil;
}

#pragma mark - Error

- (void)testNilImage {
  NSString *password = PASSWORD;
  id initialImage = nil;
  
  ISStegoDecoder *decoder = [[ISStegoDecoder alloc] init];
  
  NSError *error = nil;
  
  NSData *data = [decoder decodeStegoImage:initialImage
                                  password:password
                                     error:&error];
  
  XCTAssertNil(data, @"data is not nil");
  
  XCTAssertNotNil(error);
}

@end

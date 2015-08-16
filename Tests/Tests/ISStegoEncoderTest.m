//
//  ISStegoEncoderTest.m
//  ISSteganography
//
//  Created by Isaac Stevao Sena on 7/25/15.
//  Copyright (c) 2015 Black Bean. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ISStegoEncoder.h"
#import "ISTestUtilities.h"

@interface ISStegoEncoderTest : XCTestCase

@end

@implementation ISStegoEncoderTest

- (void)testStegoImageEncode {
    id image  = [ISTestUtilities imageNamed:ORIGINAL_IMAGE_NAME];
    
    XCTAssertNotNil(image, @"image is nil");
    
    ISStegoEncoder *encoder = [[ISStegoEncoder alloc] init];
    
    NSError *error = nil;
    
    id stegoImage = [encoder stegoImageForImage:image
                                           data:TEXT_TO_HIDE
                                          error:&error];
    
    XCTAssertNotNil(stegoImage, @"stegoImage is nil");
    
    XCTAssertNil(error, @"error isn't nil");
    
    encoder = nil;
}

- (void)testStegoBigImageEncode {
    id image  = [ISTestUtilities imageNamed:BIG_IMAGE_NAME];
    
    XCTAssertNotNil(image, @"image is nil");
    
    ISStegoEncoder *encoder = [[ISStegoEncoder alloc] init];
    
    NSError *error = nil;
    
    id stegoImage = [encoder stegoImageForImage:image
                                           data:BIG_TEXT_TO_HIDE
                                          error:&error];
    
    XCTAssertNotNil(stegoImage, @"stegoImage is nil");
    
    XCTAssertNil(error, @"error isn't nil");
    
    encoder = nil;
}

- (void)testStegoImageEncodeError {
    id image  = [ISTestUtilities imageNamed:ORIGINAL_IMAGE_NAME];
    
    XCTAssertNotNil(image, @"image is nil");
    
    ISStegoEncoder *encoder = [[ISStegoEncoder alloc] init];
    
    NSError *error = nil;
    
    id stegoImage = [encoder stegoImageForImage:image
                                           data:BIG_TEXT_TO_HIDE
                                          error:&error];
    
    XCTAssertNil(stegoImage, @"stegoImage is nil");
    
    XCTAssertNotNil(error, @"error isn't nil");
    
    encoder = nil;
}

#pragma mark - Exception

- (void)testNilImage {
    ISStegoEncoder *encoder = [[ISStegoEncoder alloc] init];
    
    NSError *error = nil;
    
    XCTAssertThrows([encoder stegoImageForImage:nil
                                           data:TEXT_TO_HIDE
                                          error:&error]);
    
    encoder = nil;
}

- (void)testImageTooSmall {
    id image  = [ISTestUtilities imageNamed:SMALL_IMAGE_NAME];
    
    XCTAssertNotNil(image, @"image is nil");
    
    ISStegoEncoder *encoder = [[ISStegoEncoder alloc] init];
    
    NSError *error = nil;
    
    [encoder stegoImageForImage:image
                           data:TEXT_TO_HIDE
                          error:&error];
    
    XCTAssertNotNil(error);
    
    encoder = nil;
}

- (void)testNilData {
    id image  = [ISTestUtilities imageNamed:ORIGINAL_IMAGE_NAME];
    
    XCTAssertNotNil(image, @"image is nil");
    
    ISStegoEncoder *encoder = [[ISStegoEncoder alloc] init];
    
    NSError *error = nil;
    
    XCTAssertThrows([encoder stegoImageForImage:image
                                           data:nil
                                          error:&error]);
    
    encoder = nil;
}

@end

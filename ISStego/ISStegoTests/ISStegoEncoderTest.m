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
    UIImage *image  = [ISTestUtilities imageNamed:ORIGINAL_IMAGE_NAME
                                           ofType:type()];
    
    XCTAssertNotNil(image, @"image is nil");
    
    ISStegoEncoder *encoder = [[ISStegoEncoder alloc] init];
    
    NSError *error = nil;
    
    UIImage *stegoImage = [encoder stegoImageForImage:image
                                                 data:TEXT_TO_HIDE
                                                error:&error];
    
    XCTAssertNotNil(stegoImage, @"stegoImage is nil");
    
    XCTAssertNil(error, @"error isn't nil");
}

- (void)testStegoBigImageEncode {
    UIImage *image  = [ISTestUtilities imageNamed:BIG_IMAGE_NAME
                                           ofType:type()];
    
    XCTAssertNotNil(image, @"image is nil");
    
    ISStegoEncoder *encoder = [[ISStegoEncoder alloc] init];
    
    NSError *error = nil;
    
    UIImage *stegoImage = [encoder stegoImageForImage:image
                                                 data:BIG_TEXT_TO_HIDE
                                                error:&error];
    
    XCTAssertNotNil(stegoImage, @"stegoImage is nil");
    
    XCTAssertNil(error, @"error isn't nil");
}

- (void)testStegoImageEncodeError {
    UIImage *image  = [ISTestUtilities imageNamed:ORIGINAL_IMAGE_NAME
                                     ofType:type()];
    
    XCTAssertNotNil(image, @"image is nil");
    
    ISStegoEncoder *encoder = [[ISStegoEncoder alloc] init];
    
    NSError *error = nil;
    
    UIImage *stegoImage = [encoder stegoImageForImage:image
                                                 data:BIG_TEXT_TO_HIDE
                                                error:&error];
    
    XCTAssertNil(stegoImage, @"stegoImage is nil");
    
    XCTAssertNotNil(error, @"error isn't nil");
}

#pragma mark - Exception

- (void)testNilImage {
    ISStegoEncoder *encoder = [[ISStegoEncoder alloc] init];
    
    NSError *error = nil;
    
    XCTAssertThrows([encoder stegoImageForImage:nil
                                           data:TEXT_TO_HIDE
                                          error:&error]);
}

- (void)testImageTooSmall {
    UIImage *image  = [ISTestUtilities imageNamed:SMALL_IMAGE_NAME
                                           ofType:type()];
    
    XCTAssertNotNil(image, @"image is nil");
    
    ISStegoEncoder *encoder = [[ISStegoEncoder alloc] init];
    
    NSError *error = nil;
    
    [encoder stegoImageForImage:image
                           data:TEXT_TO_HIDE
                          error:&error];
    
    XCTAssertNotNil(error);
}

- (void)testNilData {
    UIImage *image  = [ISTestUtilities imageNamed:ORIGINAL_IMAGE_NAME
                                           ofType:type()];
    
    XCTAssertNotNil(image, @"image is nil");
    
    ISStegoEncoder *encoder = [[ISStegoEncoder alloc] init];
    
    NSError *error = nil;
    
    XCTAssertThrows([encoder stegoImageForImage:image
                                           data:nil
                                          error:&error]);
}

@end

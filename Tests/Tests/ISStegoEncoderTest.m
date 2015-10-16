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
#import "ISStegoUtilities.h"

@interface ISStegoEncoderTest : XCTestCase

@end

@implementation ISStegoEncoderTest

- (void)testStegoImageEncode {
  NSString *imageName = IMAGE_NAME;
  NSString *password = PASSWORD;
  NSString *textToHide = TEXT_TO_HIDE;
  NSInteger channelsToEncode = ISChannelsToEncode(YES, YES, YES, NO);
  id initialImage = [ISTestUtilities imageNamed:imageName];
  
  XCTAssertNotNil(initialImage, @"image is nil");
  
  ISStegoEncoder *encoder = [[ISStegoEncoder alloc] init];
  
  NSError *error = nil;
  
  id stegoImage = [encoder hideData:textToHide
                              image:initialImage
                           password:password
                           channels:channelsToEncode
                              error:&error];
  
  XCTAssertNotNil(stegoImage, @"stegoImage is nil");
  
  XCTAssertNil(error, @"%@", error);
  
  encoder = nil;
}

- (void)testStegoBigImageEncode {
  NSString *imageName = BIG_IMAGE_NAME;
  NSString *password = PASSWORD;
  NSString *textToHide = TEXT_TO_HIDE;
  NSInteger channelsToEncode = ISChannelsToEncode(YES, YES, YES, NO);
  id initialImage = [ISTestUtilities imageNamed:imageName];
  
  XCTAssertNotNil(initialImage, @"image is nil");
  
  ISStegoEncoder *encoder = [[ISStegoEncoder alloc] init];
  
  NSError *error = nil;
  
  id stegoImage = [encoder hideData:textToHide
                              image:initialImage
                           password:password
                           channels:channelsToEncode
                              error:&error];
  
  XCTAssertNotNil(stegoImage, @"stegoImage is nil");
  
  XCTAssertNil(error, @"%@", error);
  
  encoder = nil;
}

#pragma mark - Errors

- (void)testStegoImageEncodeError {
  NSString *imageName = SMALL_IMAGE_NAME;
  NSString *password = PASSWORD;
  NSString *textToHide = BIG_TEXT_TO_HIDE;
  NSInteger channelsToEncode = ISChannelsToEncode(YES, YES, YES, NO);
  id initialImage = [ISTestUtilities imageNamed:imageName];
  
  XCTAssertNotNil(initialImage, @"image is nil");
  
  ISStegoEncoder *encoder = [[ISStegoEncoder alloc] init];
  
  NSError *error = nil;
  
  id stegoImage = [encoder hideData:textToHide
                              image:initialImage
                           password:password
                           channels:channelsToEncode
                              error:&error];
  
  XCTAssertNil(stegoImage, @"stegoImage isn't nil");
  
  XCTAssertNotNil(error, @"error is nil");
  
  encoder = nil;
}

- (void)testNilImage {
  NSString *password = PASSWORD;
  NSString *textToHide = BIG_TEXT_TO_HIDE;
  NSInteger channelsToEncode = ISChannelsToEncode(YES, YES, YES, NO);
  id initialImage = nil;
  
  ISStegoEncoder *encoder = [[ISStegoEncoder alloc] init];
  
  NSError *error = nil;
  
  id stegoImage = [encoder hideData:textToHide
                              image:initialImage
                           password:password
                           channels:channelsToEncode
                              error:&error];
  
  XCTAssertNil(stegoImage, @"stegoImage isn't nil");
  
  XCTAssertNotNil(error, @"error is nil");
  
  encoder = nil;
}

- (void)testImageTooSmall {
  NSString *imageName = SMALL_IMAGE_NAME;
  NSString *password = PASSWORD;
  NSString *textToHide = TEXT_TO_HIDE;
  NSInteger channelsToEncode = ISChannelsToEncode(YES, YES, YES, NO);
  id initialImage = [ISTestUtilities imageNamed:imageName];
  
  XCTAssertNotNil(initialImage, @"image is nil");
  
  ISStegoEncoder *encoder = [[ISStegoEncoder alloc] init];
  
  NSError *error = nil;
  
  id stegoImage = [encoder hideData:textToHide
                              image:initialImage
                           password:password
                           channels:channelsToEncode
                              error:&error];
  
  
  XCTAssertNil(stegoImage, @"image is not nil");
  XCTAssertNotNil(error);
  
  encoder = nil;
}

- (void)testNilData {
  NSString *imageName = IMAGE_NAME;
  NSString *password = PASSWORD;
  NSString *textToHide = nil;
  NSInteger channelsToEncode = ISChannelsToEncode(YES, YES, YES, NO);
  id initialImage = [ISTestUtilities imageNamed:imageName];
  
  ISStegoEncoder *encoder = [[ISStegoEncoder alloc] init];
  
  NSError *error = nil;
  
  id stegoImage = [encoder hideData:textToHide
                              image:initialImage
                           password:password
                           channels:channelsToEncode
                              error:&error];
  
  
  XCTAssertNil(stegoImage, @"image is not nil");
  XCTAssertNotNil(error);
  
  encoder = nil;
}

@end

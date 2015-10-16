//
//  ISSteganographer.m
//  ISStego
//
//  Created by Isaac Stevao Sena on 7/27/15.
//  Copyright (c) 2015 Black Bean. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ISTestUtilities.h"
#import "ISSteganographer.h"
#import "ISStegoDecoder.h"
#import "ISStegoUtilities.h"

@interface ISSteganographerTest : XCTestCase

@end

@implementation ISSteganographerTest

#pragma mark - Decode

- (void)testDecodeImage {
  NSString *imageName = STEGO_IMAGE_NAME;
  NSString *password = PASSWORD;
  id initialImage  = [ISTestUtilities imageNamed:imageName];
  NSString *textToHide = TEXT_TO_HIDE;
  XCTAssertNotNil(initialImage);
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"testDecodeImage Expectation"];
  
  [ISSteganographer dataFromImage:initialImage
                         password:password
                  completionBlock:^(NSData *data, NSError *error) {
                    XCTAssertNil(error, @"%@", error);
                    
                    XCTAssertNotNil(data);
                    
                    NSString *string = [[NSString alloc] initWithData:data
                                                             encoding:NSUTF8StringEncoding];
                    
                    XCTAssertTrue([string isEqual:textToHide], @"%@ is not equal to %@", string, textToHide);
                    
                    [expectation fulfill];
                  }];
  
  [self waitForExpectationsWithTimeout:TIME_EXPECTATION
                               handler:^(NSError *error) {
                                 if (error) {
                                   NSLog(@"Timeout Error: %@", error);
                                 }
                               }];
}

#pragma mark - Encode

- (void)testEncode {
  NSString *imageName = IMAGE_NAME;
  NSString *password = PASSWORD;
  id initialImage  = [ISTestUtilities imageNamed:imageName];
  XCTAssertNotNil(initialImage);
  NSString *textToHide = TEXT_TO_HIDE;
  NSInteger channelsToEncode = [ISSteganographer channelsRed:YES
                                                       green:YES
                                                        blue:YES
                                                       alpha:NO];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"testEncode Expectation"];
  
  [ISSteganographer hideData:textToHide
                       image:initialImage
                    password:password
                    channels:channelsToEncode
             completionBlock:^(id image, NSDictionary *info, NSError *error) {
               XCTAssertNil(error, @"%@", error);
               
               XCTAssertNotNil(image);
               
               [expectation fulfill];
             }];
  
  [self waitForExpectationsWithTimeout:TIME_EXPECTATION
                               handler:^(NSError *error) {
                                 if (error) {
                                   NSLog(@"Timeout Error: %@", error);
                                 }
                               }];
}

- (void)testEncodeError {
  NSString *imageName = SMALL_IMAGE_NAME;
  NSString *password = PASSWORD;
  id initialImage  = [ISTestUtilities imageNamed:imageName];
  XCTAssertNotNil(initialImage);
  NSString *textToHide = BIG_TEXT_TO_HIDE;
  NSInteger channelsToEncode = [ISSteganographer channelsRed:YES
                                                       green:YES
                                                        blue:YES
                                                       alpha:NO];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"EncodeData Expectation"];
  
  [ISSteganographer hideData:textToHide
                       image:initialImage
                    password:password
                    channels:channelsToEncode
             completionBlock:^(id image, NSDictionary *info, NSError *error) {
               XCTAssertNotNil(error);
               
               XCTAssertNil(image);
               
               [expectation fulfill];
             }];
  
  [self waitForExpectationsWithTimeout:TIME_EXPECTATION
                               handler:^(NSError *error) {
                                 if (error) {
                                   NSLog(@"Timeout Error: %@", error);
                                 }
                               }];
}

#pragma mark - Encode/Decode

- (void)testEncodeDecode {
  NSString *imageName = IMAGE_NAME;
  NSString *password = PASSWORD;
  id initialImage  = [ISTestUtilities imageNamed:imageName];
  XCTAssertNotNil(initialImage);
  NSString *textToHide = TEXT_TO_HIDE;
  NSInteger channelsToEncode = [ISSteganographer channelsRed:YES
                                                       green:YES
                                                        blue:YES
                                                       alpha:NO];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"testEncodeDecode Expectation"];
  
  [ISSteganographer hideData:textToHide
                       image:initialImage
                    password:password
                    channels:channelsToEncode
             completionBlock:^(id image, NSDictionary *info, NSError *error) {
               XCTAssertNil(error, @"%@", error);
               
               XCTAssertNotNil(info);
               
               XCTAssertNotNil(image);
               
               if (error) {
                 [expectation fulfill];
               } else {
                 [ISSteganographer dataFromImage:image
                                        password:password
                                 completionBlock:^(NSData *data, NSError *error) {
                                   XCTAssertNil(error, @"%@", error);
                                   
                                   XCTAssertNotNil(data);
                                   
                                   NSString *string = [[NSString alloc] initWithData:data
                                                                            encoding:NSUTF8StringEncoding];
                                   
                                   XCTAssertTrue([string isEqual:textToHide], @"%@ is not equal to %@", string, textToHide);
                                   
                                   [expectation fulfill];
                                 }];
               }
             }];
  
  [self waitForExpectationsWithTimeout:TIME_EXPECTATION
                               handler:^(NSError *error) {
                                 if (error) {
                                   NSLog(@"Timeout Error: %@", error);
                                 }
                               }];
}

- (void)testAEncodeSaveDecode {
  NSString *imageName = IMAGE_NAME;
  NSString *password = PASSWORD;
  NSString *textToHide = TEXT_TO_HIDE;
  id initialImage  = [ISTestUtilities imageNamed:imageName];
  XCTAssertNotNil(initialImage);
  NSInteger channelsToEncode = [ISSteganographer channelsRed:YES
                                                       green:YES
                                                        blue:YES
                                                       alpha:NO];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"testEncodeDecode Expectation"];
  
  [ISSteganographer hideData:textToHide
                       image:initialImage
                    password:password
                    channels:channelsToEncode
             completionBlock:^(id image, NSDictionary *info, NSError *error) {
               XCTAssertNil(error, @"%@", error);
               
               XCTAssertNotNil(image);
               
               // saving image
               NSString *filePath = [ISTestUtilities filePathToFilename:STEGO_IMAGE_TO_SAVE_NAME
                                                                   type:type()];
               
               XCTAssertTrue([ISTestUtilities saveImage:image
                                                   file:filePath]);
               
               // getting same image from disk
               id stegoImage = [ISTestUtilities imageToFilepath:filePath];
               
               XCTAssertNotNil(stegoImage);
               
               [ISSteganographer dataFromImage:stegoImage
                                      password:password
                               completionBlock:^(NSData *data, NSError *error) {
                                 XCTAssertNil(error, @"%@", error);
                                 
                                 XCTAssertNotNil(data);
                                 
                                 NSString *string = [[NSString alloc] initWithData:data
                                                                          encoding:NSUTF8StringEncoding];
                                 
                                 XCTAssertTrue([string isEqual:textToHide], @"%@ is not equal to %@", string, textToHide);
                                 
                                 [expectation fulfill];
                               }];
             }];
  
  [self waitForExpectationsWithTimeout:TIME_EXPECTATION
                               handler:^(NSError *error) {
                                 if (error) {
                                   NSLog(@"Timeout Error: %@", error);
                                 }
                               }];
}

@end

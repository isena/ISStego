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

@interface ISSteganographerTest : XCTestCase

@end

@implementation ISSteganographerTest

#pragma mark - Decode

- (void)testDecodeImage {
    UIImage *image  = [ISTestUtilities imageNamed:STEGO_IMAGE_NAME
                                           ofType:type()];
    
    XCTAssertNotNil(image);
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testDecodeImage Expectation"];
    
    [ISSteganographer dataFromImage:image
                    completionBlock:^(NSData *data, NSError *error) {
                        XCTAssertNil(error);
                        
                        XCTAssertNotNil(data);
                        
                        NSString *string = [[NSString alloc] initWithData:data
                                                                 encoding:NSUTF8StringEncoding];
                        
                        XCTAssertTrue([string isEqual:TEXT_TO_HIDE], @"%@ is not equal to %@", string, TEXT_TO_HIDE);
                        
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
    UIImage *image  = [ISTestUtilities imageNamed:ORIGINAL_IMAGE_NAME
                                           ofType:type()];
    
    XCTAssertNotNil(image);
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testEncode Expectation"];
    
    [ISSteganographer hideData:TEXT_TO_HIDE
                     withImage:image
               completionBlock:^(UIImage *image, NSError *error) {
                   XCTAssertNil(error);
                   
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
    UIImage *image  = [ISTestUtilities imageNamed:ORIGINAL_IMAGE_NAME
                                           ofType:type()];
    
    XCTAssertNotNil(image);
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"EncodeData Expectation"];
    
    [ISSteganographer hideData:BIG_TEXT_TO_HIDE
                     withImage:image
               completionBlock:^(UIImage *image, NSError *error) {
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
    UIImage *originalImage  = [ISTestUtilities imageNamed:ORIGINAL_IMAGE_NAME
                                                   ofType:type()];
    
    XCTAssertNotNil(originalImage);
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testEncodeDecode Expectation"];
    
    [ISSteganographer hideData:TEXT_TO_HIDE
                     withImage:originalImage
               completionBlock:^(UIImage *image, NSError *error) {
                   XCTAssertNil(error);
                   
                   XCTAssertNotNil(image);
                   
                   [ISSteganographer dataFromImage:image
                                   completionBlock:^(NSData *data, NSError *error) {
                                       XCTAssertNil(error);
                                       
                                       XCTAssertNotNil(data);
                                       
                                       NSString *string = [[NSString alloc] initWithData:data
                                                                                encoding:NSUTF8StringEncoding];
                                       
                                       XCTAssertTrue([string isEqual:TEXT_TO_HIDE], @"%@ is not equal to %@", string, TEXT_TO_HIDE);
                                       
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

- (void)testAEncodeSaveDecode {
    UIImage *originalImage  = [ISTestUtilities imageNamed:ORIGINAL_IMAGE_NAME
                                                   ofType:type()];
    
    XCTAssertNotNil(originalImage);
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testEncodeDecode Expectation"];
    
    [ISSteganographer hideData:TEXT_TO_HIDE
                     withImage:originalImage
               completionBlock:^(UIImage *image, NSError *error) {
                   XCTAssertNil(error);
                   
                   XCTAssertNotNil(image);
                   
                   // saving image
                   NSString *filePath = [ISTestUtilities filePathToFilename:STEGO_IMAGE_TO_SAVE_NAME
                                                                       type:type()];
                   
                   XCTAssertTrue([UIImagePNGRepresentation(image) writeToFile:filePath
                                                                   atomically:YES]);
                   
                   // getting same image from disk
                   UIImage *stegoImage = [UIImage imageWithContentsOfFile:filePath];
                   
                   XCTAssertNotNil(stegoImage);
                   
                   [ISSteganographer dataFromImage:stegoImage
                                   completionBlock:^(NSData *data, NSError *error) {
                                       XCTAssertNil(error);
                                       
                                       XCTAssertNotNil(data);
                                       
                                       NSString *string = [[NSString alloc] initWithData:data
                                                                                encoding:NSUTF8StringEncoding];
                                       
                                       XCTAssertTrue([string isEqual:TEXT_TO_HIDE], @"%@ is not equal to %@", string, TEXT_TO_HIDE);
                                       
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

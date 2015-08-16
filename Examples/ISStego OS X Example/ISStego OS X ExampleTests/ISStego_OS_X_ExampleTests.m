//
//  ISStego_OS_X_ExampleTests.m
//  ISStego OS X ExampleTests
//
//  Created by Isaac Stevao Sena on 16/08/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

@interface ISStego_OS_X_ExampleTests : XCTestCase

@end

@implementation ISStego_OS_X_ExampleTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

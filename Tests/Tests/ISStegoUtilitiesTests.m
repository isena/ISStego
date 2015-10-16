//
//  ISStegoUtilitiesTests.m
//  ISStego Tests
//
//  Created by Isaac Stevao Sena on 26/09/15.
//
//

#import <XCTest/XCTest.h>
#import "ISStegoUtilities.h"
#import <CommonCrypto/CommonCrypto.h>

static NSArray *_arrayFull;
static NSArray *_arrayAlpha;
static NSArray *_arrayRed;
static NSArray *_arrayGreen;
static NSArray *_arrayBlue;

@interface ISStegoUtilitiesTests : XCTestCase

@end

@implementation ISStegoUtilitiesTests

- (void)setUp {
  //                    0     1     2     3     4     5     6     7     8     9     10     11
  //                    A     B     G     R     A     B     G     R     A     B     G     R
  _arrayFull       = @[@(0), @(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8), @(9), @(10), @(11)];
  _arrayRed        = @[_arrayFull[3], _arrayFull[7], _arrayFull[11]];
  _arrayGreen      = @[_arrayFull[2], _arrayFull[6], _arrayFull[10]];
  _arrayBlue       = @[_arrayFull[1], _arrayFull[5], _arrayFull[9]];
  _arrayAlpha      = @[_arrayFull[0], _arrayFull[4], _arrayFull[8]];
}

#pragma mark - ChannelsToEncode tests

- (void)testUniqueChannelsToEncode {
  uint32_t code = ISChannelsToEncode(NO, NO, NO, NO);
  
  XCTAssertTrue(code == 0x0);
  
  code = ISChannelsToEncode(YES, NO, NO, NO);
  
  XCTAssertTrue(code == ISStegoChannelCodeRed);
  
  code = ISChannelsToEncode(NO, YES, NO, NO);
  
  XCTAssertTrue(code == ISStegoChannelCodeGreen);
  
  code = ISChannelsToEncode(NO, NO, YES, NO);
  
  XCTAssertTrue(code == ISStegoChannelCodeBlue);
  
  code = ISChannelsToEncode(NO, NO, NO, YES);
  
  XCTAssertTrue(code == ISStegoChannelCodeAlpha);
}

- (void)testCombinationChannelsToEncode {
  uint32_t code = 0x0;
  
  code = ISChannelsToEncode(YES, YES, YES, YES);
  
  /// one NO
  
  XCTAssertTrue(code == (ISStegoChannelCodeRed | ISStegoChannelCodeGreen | ISStegoChannelCodeBlue | ISStegoChannelCodeAlpha));
  
  code = ISChannelsToEncode(YES, YES, YES, NO);
  
  XCTAssertTrue(code == (ISStegoChannelCodeRed | ISStegoChannelCodeGreen | ISStegoChannelCodeBlue));
  
  code = ISChannelsToEncode(YES, YES, NO, YES);
  
  XCTAssertTrue(code == (ISStegoChannelCodeRed | ISStegoChannelCodeGreen | ISStegoChannelCodeAlpha));
  
  code = ISChannelsToEncode(YES, NO, YES, YES);
  
  XCTAssertTrue(code == (ISStegoChannelCodeRed | ISStegoChannelCodeBlue | ISStegoChannelCodeAlpha));
  
  code = ISChannelsToEncode(NO, YES, YES, YES);
  
  XCTAssertTrue(code == (ISStegoChannelCodeGreen | ISStegoChannelCodeBlue | ISStegoChannelCodeAlpha));
  
  /// two NO
  
  code = ISChannelsToEncode(NO, NO, YES, YES);
  
  XCTAssertTrue(code == (ISStegoChannelCodeBlue | ISStegoChannelCodeAlpha));
  
  code = ISChannelsToEncode(NO, YES, NO, YES);
  
  XCTAssertTrue(code == (ISStegoChannelCodeGreen | ISStegoChannelCodeAlpha));
  
  code = ISChannelsToEncode(NO, YES, YES, NO);
  
  XCTAssertTrue(code == (ISStegoChannelCodeGreen | ISStegoChannelCodeBlue));
  
  code = ISChannelsToEncode(YES, NO, NO, YES);
  
  XCTAssertTrue(code == (ISStegoChannelCodeRed | ISStegoChannelCodeAlpha));
  
  code = ISChannelsToEncode(YES, NO, YES, NO);
  
  XCTAssertTrue(code == (ISStegoChannelCodeRed | ISStegoChannelCodeBlue));
  
  code = ISChannelsToEncode(NO, YES, NO, YES);
  
  XCTAssertTrue(code == (ISStegoChannelCodeGreen | ISStegoChannelCodeAlpha));
}

#pragma mark - ShuffledArray tests

- (void)testShuffledArrayOfBitsWithChannelAlpha {
  uint32_t code = ISChannelsToEncode(NO, NO, NO, YES);
  
  NSArray *arrayResult = ISShuffledArrayOfBits((uint32_t)_arrayFull.count, code);
  
  XCTAssertTrue(arrayResult.count == _arrayAlpha.count);
  
  for (NSNumber *number in _arrayRed) {
    XCTAssertFalse([arrayResult containsObject:number]);
  }
  
  for (NSNumber *number in _arrayGreen) {
    XCTAssertFalse([arrayResult containsObject:number]);
  }
  
  for (NSNumber *number in _arrayBlue) {
    XCTAssertFalse([arrayResult containsObject:number]);
  }
  
  for (NSNumber *number in _arrayAlpha) {
    XCTAssertTrue([arrayResult containsObject:number]);
  }
}

- (void)testShuffledArrayOfBitsWithChannelRed {
  uint32_t code = ISChannelsToEncode(YES, NO, NO, NO);
  
  NSArray *arrayResult = ISShuffledArrayOfBits((uint32_t)_arrayFull.count, code);
  
  XCTAssertTrue(arrayResult.count == _arrayRed.count);
  
  for (NSNumber *number in _arrayRed) {
    XCTAssertTrue([arrayResult containsObject:number]);
  }
  
  for (NSNumber *number in _arrayGreen) {
    XCTAssertFalse([arrayResult containsObject:number]);
  }
  
  for (NSNumber *number in _arrayBlue) {
    XCTAssertFalse([arrayResult containsObject:number]);
  }
  
  for (NSNumber *number in _arrayAlpha) {
    XCTAssertFalse([arrayResult containsObject:number]);
  }
}

- (void)testShuffledArrayOfBitsWithChannelGreen {
  uint32_t code = ISChannelsToEncode(NO, YES, NO, NO);
  
  NSArray *arrayResult = ISShuffledArrayOfBits((uint32_t)_arrayFull.count, code);
  
  XCTAssertTrue(arrayResult.count == _arrayGreen.count);
  
  for (NSNumber *number in _arrayRed) {
    XCTAssertFalse([arrayResult containsObject:number]);
  }
  
  for (NSNumber *number in _arrayGreen) {
    XCTAssertTrue([arrayResult containsObject:number]);
  }
  
  for (NSNumber *number in _arrayBlue) {
    XCTAssertFalse([arrayResult containsObject:number]);
  }
  
  for (NSNumber *number in _arrayAlpha) {
    XCTAssertFalse([arrayResult containsObject:number]);
  }
}

- (void)testShuffledArrayOfBitsWithChannelBlue {
  uint32_t code = ISChannelsToEncode(NO, NO, YES, NO);
  
  NSArray *arrayResult = ISShuffledArrayOfBits((uint32_t)_arrayFull.count, code);
  
  XCTAssertTrue(arrayResult.count == _arrayBlue.count);
  
  for (NSNumber *number in _arrayRed) {
    XCTAssertFalse([arrayResult containsObject:number]);
  }
  
  for (NSNumber *number in _arrayGreen) {
    XCTAssertFalse([arrayResult containsObject:number]);
  }
  
  for (NSNumber *number in _arrayBlue) {
    XCTAssertTrue([arrayResult containsObject:number]);
  }
  
  for (NSNumber *number in _arrayAlpha) {
    XCTAssertFalse([arrayResult containsObject:number]);
  }
}

- (void)testShuffledArrayOfBitsWithChannelsRedBlue {
  uint32_t code = ISChannelsToEncode(YES, NO, YES, NO);
  
  NSArray *arrayResult = ISShuffledArrayOfBits((uint32_t)_arrayFull.count, code);
  
  XCTAssertTrue(arrayResult.count == (_arrayRed.count + _arrayBlue.count));
  
  for (NSNumber *number in _arrayRed) {
    XCTAssertTrue([arrayResult containsObject:number]);
  }
  
  for (NSNumber *number in _arrayGreen) {
    XCTAssertFalse([arrayResult containsObject:number]);
  }
  
  for (NSNumber *number in _arrayBlue) {
    XCTAssertTrue([arrayResult containsObject:number]);
  }
  
  for (NSNumber *number in _arrayAlpha) {
    XCTAssertFalse([arrayResult containsObject:number]);
  }
}

- (void)testShuffledArrayOfBitsWithChannelsRGB {
  uint32_t code = ISChannelsToEncode(YES, YES, YES, NO);
  
  NSArray *arrayResult = ISShuffledArrayOfBits((uint32_t)_arrayFull.count, code);
  
  XCTAssertTrue(arrayResult.count == (_arrayRed.count + _arrayGreen.count + _arrayBlue.count));
  
  for (NSNumber *number in _arrayRed) {
    XCTAssertTrue([arrayResult containsObject:number]);
  }
  
  for (NSNumber *number in _arrayGreen) {
    XCTAssertTrue([arrayResult containsObject:number]);
  }
  
  for (NSNumber *number in _arrayBlue) {
    XCTAssertTrue([arrayResult containsObject:number]);
  }
  
  for (NSNumber *number in _arrayAlpha) {
    XCTAssertFalse([arrayResult containsObject:number]);
  }
}

- (void)testShuffledArrayOfBitsWithAllChannels {
  uint32_t code = ISChannelsToEncode(YES, YES, YES, YES);
  
  NSArray *arrayResult = ISShuffledArrayOfBits((uint32_t)_arrayFull.count, code);
  
  XCTAssertTrue(arrayResult.count == (_arrayAlpha.count + _arrayRed.count + _arrayGreen.count + _arrayBlue.count));
  
  for (NSNumber *number in _arrayRed) {
    XCTAssertTrue([arrayResult containsObject:number]);
  }
  
  for (NSNumber *number in _arrayGreen) {
    XCTAssertTrue([arrayResult containsObject:number]);
  }
  
  for (NSNumber *number in _arrayBlue) {
    XCTAssertTrue([arrayResult containsObject:number]);
  }
  
  for (NSNumber *number in _arrayAlpha) {
    XCTAssertTrue([arrayResult containsObject:number]);
  }
}

@end

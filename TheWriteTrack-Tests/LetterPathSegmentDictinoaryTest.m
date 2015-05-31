//
//  LetterPathSegmentDictionaryTest.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/31/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LetterPathSegmentDictionary.h"
#import <XCTest/XCTest.h>

@interface LetterPathSegmentDictinoaryTest : XCTestCase {
    NSMutableArray *upperCaseKeys;
}

@end

@implementation LetterPathSegmentDictinoaryTest

- (void)setUp {
    upperCaseKeys = [LetterPathSegmentDictionary initializeUpperCaseKeys];
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)assertArrayWithKey:(id)key hasObjectCount:(NSUInteger)count {
    NSArray *array = [[LetterPathSegmentDictionary dictionaryWithUpperCasePathSegments] objectForKey:key];
    XCTAssertNotNil(array);
    XCTAssertEqual(array.count, count);
}

- (void)testUpperCaseKeyArrayContainsAllUpperCaseLettersFromAtoZInclusive {
    NSArray *expectedKeys = [NSArray arrayWithObjects:
                             @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I",
                             @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R",
                             @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    
    XCTAssertTrue([upperCaseKeys isEqualToArray:expectedKeys]);
}

- (void)testTheLetter_A_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"A" hasObjectCount:8];
}

- (void)testTheLetter_B_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"B" hasObjectCount:11];
}

- (void)testTheLetter_C_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"C" hasObjectCount:4];
}

- (void)testTheLetter_D_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"D" hasObjectCount:8];
}

@end

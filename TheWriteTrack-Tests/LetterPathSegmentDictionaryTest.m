//
//      .m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/31/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LetterPathSegmentDictionary.h"
#import <XCTest/XCTest.h>

@interface LetterPathSegmentDictionaryTest : XCTestCase {
    NSMutableArray *upperCaseKeys;
}

@end

@implementation LetterPathSegmentDictionaryTest

- (void)setUp {
    upperCaseKeys = [LetterPathSegmentDictionary initializeUpperCaseKeys];
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)assertArrayWithKey:(id)key hasObjectCount:(NSUInteger)count andSubSegmentCount:(NSUInteger)expectedSegmentEnds {
    NSArray *array = [[LetterPathSegmentDictionary dictionaryWithUpperCasePathSegments] objectForKey:key];
    XCTAssertNotNil(array);
    
    NSUInteger nonControlIndexCount = [[array indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [obj integerValue] > 0; }] count];
    XCTAssertEqual(nonControlIndexCount, count);
    
    NSUInteger segmentEndCount = [[array indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [obj isEqual:SE]; }] count];
    XCTAssertEqual(segmentEndCount, expectedSegmentEnds);
}

- (void)testUpperCaseKeyArrayContainsAllUpperCaseLettersFromAtoZInclusive {
    NSArray *expectedKeys = [NSArray arrayWithObjects:
                             @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I",
                             @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R",
                             @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    
    XCTAssertTrue([upperCaseKeys isEqualToArray:expectedKeys]);
}

- (void)testTheLetter_A_HasANonNilSegmentArrayWithTheCorrectNumberOfSubSegments {
    [self assertArrayWithKey:@"A" hasObjectCount:10 andSubSegmentCount:3];
}

- (void)testTheLetter_B_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"B" hasObjectCount:12 andSubSegmentCount:2];
}

- (void)testTheLetter_C_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"C" hasObjectCount:4 andSubSegmentCount:1];
}

- (void)testTheLetter_D_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"D" hasObjectCount:8 andSubSegmentCount:2];
}

- (void)testTheLetter_E_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"E" hasObjectCount:12 andSubSegmentCount:4];
}

- (void)testTheLetter_F_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"F" hasObjectCount:9 andSubSegmentCount:3];
}

- (void)testTheLetter_G_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"G" hasObjectCount:6 andSubSegmentCount:1];
}

@end

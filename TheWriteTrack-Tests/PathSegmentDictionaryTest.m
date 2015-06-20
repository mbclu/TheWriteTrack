//
//  PathSegmentDictionaryTest.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/31/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "PathSegmentDictionary.h"
#import <XCTest/XCTest.h>

@interface PathSegmentDictionaryTest : XCTestCase {
    NSArray *upperCaseKeys;
}

@end

@implementation PathSegmentDictionaryTest

- (void)setUp {
    upperCaseKeys = [PathSegmentDictionary initializeUpperCaseKeys];
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)assertArrayWithKey:(id)key hasObjectCount:(NSUInteger)count andSubSegmentCount:(NSUInteger)expectedSegmentEnds {
    NSArray *array = [[PathSegmentDictionary dictionaryWithUpperCasePathSegments] objectForKey:key];
    XCTAssertNotNil(array);
    
    NSUInteger nonControlIndexCount = [[array indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [obj integerValue] >= 0; }] count];
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

- (void)testTheLetter_H_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"H" hasObjectCount:11 andSubSegmentCount:3];
}

- (void)testTheLetter_I_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"I" hasObjectCount:8 andSubSegmentCount:3];
}

- (void)testTheLetter_J_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"J" hasObjectCount:5 andSubSegmentCount:1];
}

- (void)testTheLetter_K_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"K" hasObjectCount:8 andSubSegmentCount:2];
}

- (void)testTheLetter_L_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"L" hasObjectCount:6 andSubSegmentCount:2];
}

- (void)testTheLetter_M_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"M" hasObjectCount:12 andSubSegmentCount:2];
}

- (void)testTheLetter_N_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"N" hasObjectCount:12 andSubSegmentCount:2];
}

- (void)testTheLetter_O_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"O" hasObjectCount:4 andSubSegmentCount:1];
}

- (void)testTheLetter_P_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"P" hasObjectCount:8 andSubSegmentCount:2];
}

- (void)testTheLetter_Q_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"Q" hasObjectCount:6 andSubSegmentCount:2];
}

- (void)testTheLetter_R_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"R" hasObjectCount:11 andSubSegmentCount:3];
}

- (void)testTheLetter_S_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"S" hasObjectCount:6 andSubSegmentCount:1];
}

- (void)testTheLetter_T_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"T" hasObjectCount:8 andSubSegmentCount:2];
}

- (void)testTheLetter_U_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"U" hasObjectCount:6 andSubSegmentCount:1];
}

- (void)testTheLetter_V_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"V" hasObjectCount:8 andSubSegmentCount:1];
}

- (void)testTheLetter_W_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"W" hasObjectCount:12 andSubSegmentCount:1];
}

- (void)testTheLetter_X_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"X" hasObjectCount:8 andSubSegmentCount:2];
}

- (void)testTheLetter_Y_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"Y" hasObjectCount:6 andSubSegmentCount:2];
}

- (void)testTheLetter_Z_HasANonNilSegmentArrayWithTheCorrectNumberOfSegments {
    [self assertArrayWithKey:@"Z" hasObjectCount:12 andSubSegmentCount:1];
}
@end

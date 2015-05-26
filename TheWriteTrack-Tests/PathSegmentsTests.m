//
//  PathSegmentsTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/26/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "PathSegments.h"

#import "CGMatchers.h"
#import <XCTest/XCTest.h>

const CGFloat segmentMultiplier = 0.25;

@interface PathSegmentsTests : XCTestCase {
    PathSegments *pathSegments;
    CGFloat rowSegmentHeight;
    CGFloat columnSegmentWidth;
    NSArray *pathSegmentArray;
}

@end

@implementation PathSegmentsTests

- (void)setUp {
    [super setUp];
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeLeft]
                                forKey:@"orientation"];
    pathSegments = [[PathSegments alloc] init];
    rowSegmentHeight = pathSegments.segmentBounds.size.height * segmentMultiplier;
    columnSegmentWidth = pathSegments.segmentBounds.size.width * segmentMultiplier;
}

- (void)tearDown {
    [super tearDown];
}

- (void)testSegmentsObjectHasAAnOriginOfZero {
    XCTAssertEqualPoints(pathSegments.segmentBounds.origin, CGPointZero);
}

- (void)testSegmentsObjectHasAHeightOfNinetyFivePrecentThatOfTheSreenHeight {
    XCTAssertEqualWithAccuracy(pathSegments.segmentBounds.size.height, [UIScreen mainScreen].bounds.size.height * 0.75, 0.1);
}

- (void)testSegmentsObjectHasAWidthOfThirtyFivePrecentThatOfTheSreenWidth {
    XCTAssertEqualWithAccuracy(pathSegments.segmentBounds.size.width, [UIScreen mainScreen].bounds.size.width * 0.35, 0.1);
}

- (void)testSegmentOneOfRowOneFromBottomToTop {
    CGPathRef path = (__bridge CGPathRef)([pathSegments.segments objectAtIndex:0]);
    XCTAssertTrue(CGPathContainsPoint(path, nil, CGPointMake(0, rowSegmentHeight * 0), NO));
    XCTAssertTrue(CGPathContainsPoint(path, nil, CGPointMake(0, rowSegmentHeight * 1), NO));
}

- (void)testSegmentOneOfRowTwoFromBottomToTop {
    CGPathRef path = (__bridge CGPathRef)([pathSegments.segments objectAtIndex:1]);
    XCTAssertTrue(CGPathContainsPoint(path, nil, CGPointMake(0, rowSegmentHeight * 1), NO));
    XCTAssertTrue(CGPathContainsPoint(path, nil, CGPointMake(0, rowSegmentHeight * 2), NO));
}

- (void)testSegmentOneOfRowThreeFromBottomToTop {
    CGPathRef path = (__bridge CGPathRef)([pathSegments.segments objectAtIndex:2]);
    XCTAssertTrue(CGPathContainsPoint(path, nil, CGPointMake(0, rowSegmentHeight * 2), NO));
    XCTAssertTrue(CGPathContainsPoint(path, nil, CGPointMake(0, rowSegmentHeight * 3), NO));
}

- (void)testSegmentOneOfRowFourFromBottomToTop {
    CGPathRef path = (__bridge CGPathRef)([pathSegments.segments objectAtIndex:3]);
    XCTAssertTrue(CGPathContainsPoint(path, nil, CGPointMake(0, rowSegmentHeight * 3), NO));
    XCTAssertTrue(CGPathContainsPoint(path, nil, CGPointMake(0, rowSegmentHeight * 4), NO));
}

- (void)testSegmentTwoOfRowOneFromBottomToTop {
    CGPathRef path = (__bridge CGPathRef)([pathSegments.segments objectAtIndex:4]);
    XCTAssertTrue(CGPathContainsPoint(path, nil, CGPointMake(columnSegmentWidth, rowSegmentHeight * 0), NO));
    XCTAssertTrue(CGPathContainsPoint(path, nil, CGPointMake(columnSegmentWidth, rowSegmentHeight * 1), NO));
}

- (void)testSegmentTwoOfRowTwoFromBottomToTop {
    CGPathRef path = (__bridge CGPathRef)([pathSegments.segments objectAtIndex:5]);
    XCTAssertTrue(CGPathContainsPoint(path, nil, CGPointMake(columnSegmentWidth, rowSegmentHeight * 1), NO));
    XCTAssertTrue(CGPathContainsPoint(path, nil, CGPointMake(columnSegmentWidth, rowSegmentHeight * 2), NO));
}

- (void)testSegmentTwoOfRowThreeFromBottomToTop {
    CGPathRef path = (__bridge CGPathRef)([pathSegments.segments objectAtIndex:6]);
    XCTAssertTrue(CGPathContainsPoint(path, nil, CGPointMake(columnSegmentWidth, rowSegmentHeight * 2), NO));
    XCTAssertTrue(CGPathContainsPoint(path, nil, CGPointMake(columnSegmentWidth, rowSegmentHeight * 3), NO));
}

- (void)testSegmentTwoOfRowFourFromBottomToTop {
    CGPathRef path = (__bridge CGPathRef)([pathSegments.segments objectAtIndex:7]);
    XCTAssertTrue(CGPathContainsPoint(path, nil, CGPointMake(columnSegmentWidth, rowSegmentHeight * 3), NO));
    XCTAssertTrue(CGPathContainsPoint(path, nil, CGPointMake(columnSegmentWidth, rowSegmentHeight * 4), NO));
}

@end

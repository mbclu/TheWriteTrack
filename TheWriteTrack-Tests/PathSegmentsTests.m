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

@interface PathSegmentsTests : XCTestCase {
    PathSegments *pathSegments;
}

@end

@implementation PathSegmentsTests

- (void)setUp {
    [super setUp];
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeLeft]
                                forKey:@"orientation"];
    pathSegments = [[PathSegments alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testSegmentsObjectHasAAnOriginOfZero {
    XCTAssertEqualPoints(pathSegments.segmentBounds.origin, CGPointZero);
}

- (void)testSegmentsObjectHasAHeightOfNinetyFivePrecentThatOfTheSreenHeight {
    XCTAssertEqualWithAccuracy(pathSegments.segmentBounds.size.height, [UIScreen mainScreen].bounds.size.height * 0.95, 0.1);
}

- (void)testSegmentsObjectHasAWidthOfThirtyFivePrecentThatOfTheSreenWidth {
    XCTAssertEqualWithAccuracy(pathSegments.segmentBounds.size.width, [UIScreen mainScreen].bounds.size.width * 0.35, 0.1);
}

- (void)testTheLeftEdgeIsComprisedOfFourEqualSegments {
    CGFloat segmentLength = pathSegments.segmentBounds.size.width * 0.25;
    NSArray *array = [pathSegments segments];
    CGPathRef path = (__bridge CGPathRef)([array objectAtIndex:0]);
    XCTAssertTrue(CGPathContainsPoint(path, nil, CGPointMake(0, segmentLength), NO));
}

@end

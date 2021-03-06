//
//  PathInfoTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/9/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "PathInfo.h"
#import "CGMatchers.h"
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface PathInfoTests : XCTestCase {
    CGMutablePathRef thePath;
    PathInfo *thePathInfo;
}

@end

@implementation PathInfoTests

- (void)setUp {
    thePath = CGPathCreateMutable();
    thePathInfo = [[PathInfo alloc] init];
    [super setUp];
}

- (void)tearDown {
    CGPathRelease(thePath);
    [super tearDown];
}

- (CGPoint)setupMoveToPointX:(NSUInteger)x Y:(NSUInteger)y {
    CGPoint expectedPoint = CGPointMake(x, y);
    CGPathMoveToPoint(thePath, nil, expectedPoint.x, expectedPoint.y);
    XCTAssertFalse(CGPathIsEmpty(thePath));
    return expectedPoint;
}

- (CGPoint)setupMoveToPointZero {
    return [self setupMoveToPointX:0 Y:0];
}

- (CGPoint)setupAddLineToPointX:(NSUInteger)x Y:(NSUInteger)y {
    CGPoint expectedPoint = CGPointMake(20, 35);
    CGPathAddLineToPoint(thePath, nil, expectedPoint.x, expectedPoint.y);
    XCTAssertFalse(CGPathIsEmpty(thePath));
    return expectedPoint;
}

- (NSMutableArray *)verifyArrayCount:(NSUInteger)count {
    NSMutableArray *array = [thePathInfo TransformPathToArray:thePath];
    XCTAssertEqual(array.count, 1);
    return array;
}

- (void)assertForArray:(NSMutableArray *)array ThereExistsPoint:(CGPoint)expectedPoint AtIndex:(NSUInteger)index {
    NSUInteger expectedCount = index + 1;
    XCTAssertGreaterThanOrEqual(array.count, expectedCount);
    
    NSValue *point = (NSValue *)[array objectAtIndex:index];
    XCTAssertEqualPoints([point CGPointValue], expectedPoint);
}

- (void)testAnEmptyPathReturnsAnEmptyArray {
    XCTAssertTrue(CGPathIsEmpty(thePath));
    XCTAssertEqual([thePathInfo TransformPathToArray:thePath].count, 0);
}

- (void)testOnePointIsAddedForMoveToPointType {
    CGPoint expectedPoint = [self setupMoveToPointX:10 Y:20];

    NSMutableArray *array = [thePathInfo TransformPathToArray:thePath];
    [self assertForArray:array ThereExistsPoint:expectedPoint AtIndex:0];
}

- (void)testOnePointIsAddedForAddLineToPointType {
    [self setupMoveToPointZero];
    CGPoint expectedPoint = [self setupAddLineToPointX:20 Y:35];

    NSMutableArray *array = [thePathInfo TransformPathToArray:thePath];
    [self assertForArray:array ThereExistsPoint:expectedPoint AtIndex:1];
}

- (void)testTwoPointsAreAddedForAddQuadCurveToPointType {
    [self setupMoveToPointZero];
    CGPoint expectedPoint1 = CGPointMake(1, 2);
    CGPoint expectedPoint2 = CGPointMake(3, 4);
    CGPathAddQuadCurveToPoint(thePath, nil,
                              expectedPoint1.x, expectedPoint1.y,
                              expectedPoint2.x, expectedPoint2.y);

    NSMutableArray *array = [thePathInfo TransformPathToArray:thePath];
    [self assertForArray:array ThereExistsPoint:expectedPoint1 AtIndex:1];
    [self assertForArray:array ThereExistsPoint:expectedPoint2 AtIndex:2];
}

- (void)testThreePointsAreAddedForAddCurveToPointType {
    [self setupMoveToPointZero];
    CGPoint expectedPoint1 = CGPointMake(1, 1);
    CGPoint expectedPoint2 = CGPointMake(2, 2);
    CGPoint expectedPoint3 = CGPointMake(3, 3);
    CGPathAddCurveToPoint(thePath, nil,
                          expectedPoint1.x, expectedPoint1.y,
                          expectedPoint2.x, expectedPoint2.y,
                          expectedPoint3.x, expectedPoint3.y);
    
    NSMutableArray *array = [thePathInfo TransformPathToArray:thePath];
    [self assertForArray:array ThereExistsPoint:expectedPoint1 AtIndex:1];
    [self assertForArray:array ThereExistsPoint:expectedPoint2 AtIndex:2];
    [self assertForArray:array ThereExistsPoint:expectedPoint3 AtIndex:3];
}

- (void)testZeroPointsAreAddedForCloseSubpathElements {
    [self setupMoveToPointZero];
    NSMutableArray *array = [thePathInfo TransformPathToArray:thePath];
    XCTAssertEqual(array.count, 1);
    CGPathCloseSubpath(thePath);
    array = [thePathInfo TransformPathToArray:thePath];
    XCTAssertEqual(array.count, 1);
}

- (void)testPathWithMultipleElementTypes {
    [self setupMoveToPointZero];
    CGPoint expectedPoint1 = [self setupAddLineToPointX:10 Y:10];
    CGPoint expectedPoint2 = CGPointMake(10, 10);
    CGPoint expectedPoint3 = CGPointMake(10, 20);
    CGPathAddQuadCurveToPoint(thePath, nil,
                              expectedPoint2.x, expectedPoint2.y,
                              expectedPoint3.x, expectedPoint3.y);
    NSMutableArray *array = [thePathInfo TransformPathToArray:thePath];
    [self assertForArray:array ThereExistsPoint:expectedPoint1 AtIndex:1];
    [self assertForArray:array ThereExistsPoint:expectedPoint2 AtIndex:2];
    [self assertForArray:array ThereExistsPoint:expectedPoint3 AtIndex:3];
}

@end

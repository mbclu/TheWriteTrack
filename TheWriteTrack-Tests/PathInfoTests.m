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
    [super tearDown];
}

- (CGPoint)setupMoveToPoint {
    CGPoint expectedPoint = CGPointMake(10, 20);
    CGPathMoveToPoint(thePath, nil, expectedPoint.x, expectedPoint.y);
    return expectedPoint;
}

- (NSMutableArray *)verifyArrayCount:(NSUInteger)count {
    NSMutableArray *array = [thePathInfo TransformPathToArray:thePath];
    XCTAssertEqual(array.count, 1);
    return array;
    
}

- (void)assertThereExistsPoint:(CGPoint)expectedPoint AtIndex:(NSUInteger)index {
    NSMutableArray *array = [thePathInfo TransformPathToArray:thePath];
    NSUInteger expetedCount = index + 1;
    XCTAssertEqual(array.count, expetedCount);
    NSValue *point = (NSValue *)[array objectAtIndex:index];
    XCTAssertEqualPoints([point CGPointValue], expectedPoint);
}

- (void)testAnEmptyPathReturnsAnEmptyArray {
    XCTAssertTrue(CGPathIsEmpty(thePath));
    XCTAssertEqual([thePathInfo TransformPathToArray:thePath].count, 0);
}

- (void)testOnePointIsAddedForMoveToPointType {
    CGPoint expectedPoint = [self setupMoveToPoint];
    XCTAssertFalse(CGPathIsEmpty(thePath));
    [self assertThereExistsPoint:expectedPoint AtIndex:0];
}

- (void)testOnePointIsAddedForAddLineToPointType {
    [self setupMoveToPoint];
    CGPoint expectedPoint = CGPointMake(20, 35);
    CGPathAddLineToPoint(thePath, nil, expectedPoint.x, expectedPoint.y);
    [self assertThereExistsPoint:expectedPoint AtIndex:1];
}

@end

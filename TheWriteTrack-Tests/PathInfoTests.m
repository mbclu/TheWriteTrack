//
//  PathInfoTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/9/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "PathInfo.h"
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface PathInfoTests : XCTestCase

@end

@implementation PathInfoTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

-(void)testAnEmptyPathReturnsAnEmptyArray {
    CGMutablePathRef path = CGPathCreateMutable();
    XCTAssertTrue(CGPathIsEmpty(path));
    PathInfo *pathInfo = [[PathInfo alloc] init];
    XCTAssertEqual([pathInfo TransformPathToArray:path].count, 0);
}

- (void)testOnePointIsAddedForMoveToPointType {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 10, 20);
    XCTAssertFalse(CGPathIsEmpty(path));
    PathInfo *pathInfo = [[PathInfo alloc] init];
    NSMutableArray *array = [pathInfo TransformPathToArray:path];
    XCTAssertEqual(array.count, 1);
    NSValue *point = (NSValue *)[array objectAtIndex:0];
    XCTAssertEqual([point CGPointValue].x, 10);
}

@end

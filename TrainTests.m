//
//  TrainTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/20/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Train.h"

@interface TrainTests : XCTestCase

@end

@implementation TrainTests {
    Train* theTrain;
}

- (void)setUp {
    [super setUp];
    theTrain = [[Train alloc] initWithImageNamed:@"_BaseTrain"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThatTheTrainCanBeInitializedWithAnImage {
    XCTAssertNoThrow([[Train alloc] initWithImageNamed:@"_BaseTrain"], @"Initializing the train with an image should not throw an exception");
}

- (void)testThatWhenInitializedWithAnImageNameTheVelocityIs80PointsPerSecond {
    NSInteger expectedSpeed = 80;
    NSInteger actualSpeed = [theTrain pointsPerSecond];
    XCTAssertEqual(actualSpeed, expectedSpeed, @"The train is moving at speed :%ld points per second, when it should be moving at %ld points per second", actualSpeed, expectedSpeed);
}

- (void)testThatTheTrainStartsWithZeroWayPoints {
    XCTAssertEqual([theTrain wayPoints].count, 0);
}

- (void)testThatAPointCanBeAddedToTheMove {
    CGPoint expectedPoint = CGPointMake(2.9, 1.4);
    [theTrain addPointToMove:expectedPoint];
    NSMutableArray* waypoints = [theTrain wayPoints];
    XCTAssertEqual([waypoints count], 1);
    NSValue* point = [waypoints objectAtIndex:0];
    CGPoint actualPoint = [point CGPointValue];
    XCTAssertEqual(expectedPoint.x, (actualPoint).x);
    XCTAssertEqual(expectedPoint.y, (actualPoint).y);
}

@end

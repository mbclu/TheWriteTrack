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

@implementation TrainTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThatTheTrainMovesAt80PointsPerSecond {
    NSInteger expectedSpeed = 80;
    Train* theTrain = [[Train alloc] init];
    NSInteger actualSpeed = [theTrain pointsPerSecond];
    XCTAssertEqual(actualSpeed, expectedSpeed, @"The train is moving at speed :%ld points per second, when it should be moving at %ld points per second", actualSpeed, expectedSpeed);
}

- (void)testThatTheTrainCanBeInitializedWithAnImage {
    XCTAssertNoThrow([[Train alloc] initWithImageNamed:@"_BaseTrain"], @"Initializing the train with an image should not throw an exception");
}

- (void)testThatWhenInitializedWithAnImageNameTheVelocityIsStill80PointsPerSecond {
    NSInteger expectedSpeed = 80;
    Train* theTrain = [[Train alloc] initWithImageNamed:@"_BaseTrain"];
    NSInteger actualSpeed = [theTrain pointsPerSecond];
    XCTAssertEqual(actualSpeed, expectedSpeed, @"The train is moving at speed :%ld points per second, when it should be moving at %ld points per second", actualSpeed, expectedSpeed);
}

@end

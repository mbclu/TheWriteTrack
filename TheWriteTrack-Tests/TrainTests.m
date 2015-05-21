//
//  TrainTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/19/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "Train.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "CGMatchers.h"

@interface TrainTests : XCTestCase {
    Train *theTrain;
}

@end

@implementation TrainTests

- (void)setUp {
    [super setUp];
    theTrain = [[Train alloc] initWithAttributedStringPath:nil];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testTrainNodeForMagicTrainTexture {
    XCTAssertTrue([theTrain.description containsString:@"MagicTrain"]);
}

- (void)testTrainNodeHasNameTrain {
    XCTAssertEqualObjects(theTrain.name, @"Train");
}

- (void)testWhenNoAttributedStringPathIsProvidedItIsNil {
    XCTAssertNil(theTrain.letterPath);
}

- (void)testWhenAnAttributedStringPathIsProvidedThenThatStringPathIsUsedAsTheTrainsLetterPath {
    AttributedStringPath *letterPath = [[AttributedStringPath alloc] initWithString:@"M"];
    Train *aTrain = [[Train alloc] initWithAttributedStringPath:letterPath];
    XCTAssertNotNil(aTrain.letterPath);
    XCTAssertEqualObjects(aTrain.letterPath, letterPath);
}

- (void)testTrainHasASetOfPointsToFollowWithAtLeastOnePointInIt {
    XCTAssertNotNil(theTrain.waypoints);
}

- (void)testWhenTheTrainHasBeenSetAtTheStartThenTheTrainPositionIsTheSameAsTheFirstWaypoint {
    CGPoint expectedPoint = CGPointMake(10, 15);
    [theTrain setWaypoints:[NSArray arrayWithObject:[NSValue valueWithCGPoint:expectedPoint]]];
    [theTrain positionTrainAtStartPoint];
    XCTAssertEqualPoints(theTrain.position, expectedPoint);
}

@end

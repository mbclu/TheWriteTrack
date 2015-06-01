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

const uint pathWidth = 10;
const uint pathHeight = 10;

@interface TrainTests : XCTestCase {
    CGPathRef thePath;
    Train *theTrain;
}

@end

@implementation TrainTests

- (void)setUp {
    [super setUp];
    thePath = CGPathCreateWithRect(CGRectMake(0, 0, pathWidth, pathHeight), nil);
    theTrain = [[Train alloc] initWithPath:thePath];
}

- (void)tearDown {
    [super tearDown];
}

- (CGPoint)simulateTrainMoveWithXYOffsetFromPoint:(CGPoint)initial x:(uint)x y:(uint)y {
    CGPoint touchPosition = CGPointMake(initial.x + x, initial.y + y);
    [theTrain setIsMoving:YES];
    [theTrain evaluateTouchesMovedAtPoint:touchPosition];
    return touchPosition;
}

- (void)testTrainNodeForMagicTrainTexture {
    XCTAssertTrue([theTrain.description containsString:@"MagicTrain"]);
}

- (void)testTrainNodeHasNameTrain {
    XCTAssertEqualObjects(theTrain.name, @"Train");
}

- (void)testWhenAPathIsProvidedThenThatPathIsTheTrainsPath {
    AttributedStringPath *letterPath = [[AttributedStringPath alloc] initWithString:@"M"];
    Train *aTrain = [[Train alloc] initWithPath:letterPath.letterPath];
    XCTAssertFalse(CGPathIsEmpty(aTrain.letterPath));
    XCTAssertTrue(CGPathEqualToPath(aTrain.letterPath, letterPath.letterPath));
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

- (void)testTheTrainIsPositionedOffScreenWhenPathIsEmpty {
    Train *emptyPathTrain = [[Train alloc] initWithPath:CGPathCreateMutable()];
    XCTAssertEqualPoints(emptyPathTrain.position, CGPointMake(-100, -100));
}

- (void)testTheTrainIsInitiallyStill {
    XCTAssertFalse(theTrain.isMoving);
}

- (void)testGivenTouchesBeginWhenTouchesAreNotOnTheTrainThenTheTrainIsConsideredToBeStill {
    [theTrain evaluateTouchesBeganAtPoint:CGPointMake(theTrain.position.x + theTrain.size.width + 1,
                                                      theTrain.position.y + theTrain.size.height)];
    XCTAssertFalse(theTrain.isMoving);
}

- (void)testGivenTouchesBeginWhenTouchesAreOnTheTrainThenTheTrainIsConsideredToBeMoving {
    [theTrain evaluateTouchesBeganAtPoint:CGPointMake(theTrain.position.x, theTrain.position.y)];
    XCTAssertTrue(theTrain.isMoving);
}

- (void)testGivenTheTrainIsStillWhenTouchesMovedThenTheTrainRemainsStill {
    CGPoint initialTrainPosition = theTrain.position;
    [theTrain setIsMoving:NO];
    [theTrain evaluateTouchesMovedAtPoint:CGPointMake(initialTrainPosition.x, initialTrainPosition.y)];
    XCTAssertFalse(theTrain.isMoving);
    XCTAssertEqualPoints(theTrain.position, initialTrainPosition);
}

- (void)testGivenTheTrainIsMovingWhenTouchesMovedThenTheTrainPositionWillUpdateToTheTouchPosition {
    CGPoint initialTrainPosition = theTrain.position;
    CGPoint touchPoint = [self simulateTrainMoveWithXYOffsetFromPoint:initialTrainPosition x:(pathWidth / 2) y:(pathHeight / 2)];
    XCTAssertEqualPoints(theTrain.position, touchPoint);
    XCTAssertTrue(theTrain.isMoving);
}

- (void)testGivenTouchesEndedThenTheTrainIsConsideredToBeStill {
    [theTrain evaluateTouchesBeganAtPoint:CGPointMake(theTrain.position.x, theTrain.position.y)];
    XCTAssertTrue(theTrain.isMoving);
}

- (void)testUserInteractionIsEnabled {
    XCTAssertTrue(theTrain.isUserInteractionEnabled);
}

- (void)testWhenATouchIsMovedOutsideThePathThenTheTrainDoesNotMoveAndIsConsideredStill {
    CGPoint initialTrainPosition = theTrain.position;

    [self simulateTrainMoveWithXYOffsetFromPoint:initialTrainPosition x:(pathWidth * 2) y:(pathHeight * 2)];
    
    XCTAssertFalse(theTrain.isMoving);
    XCTAssertEqualPoints(theTrain.position, initialTrainPosition);
}

@end

//
//  TrainTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/19/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "Train.h"
#import "LetterPathSegmentDictionary.h"

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "CGMatchers.h"
#import "PathInfo.h"

const uint pathWidth = 8;
const uint pathHeight = 8;
const CGFloat xCenterOffset = 1.0;
const CGFloat yCenterOffset = 3.0;
const CGFloat xOriginShift = 2.0;
const CGFloat yOriginShift = 4.0;
const NSString *RKEY = @"RectangleKey";

@interface TrainTests : XCTestCase {
    Train *theTrain;
    PathSegments *thePathSegments;
    CGPoint pathSegmentOffset;
    CGPoint initialTrainPosition;
}

@end

@implementation TrainTests

- (void)setUp {
    [super setUp];
    thePathSegments = [[PathSegments alloc] initWithRect:CGRectMake(0, 0, pathWidth, pathHeight)];
    [thePathSegments setLetterSegmentDictionary:[NSDictionary dictionaryWithObject:
                                                 [NSArray arrayWithObjects:
                                                  v0, v1, v2, v3,
                                                  h36, h37, h38, h39,
                                                  v19, v18, v17, v16,
                                                  h23, h22, h21, h20,
                                                  SE, nil] forKey:RKEY]];
    [thePathSegments generateCombinedPathForLetter:RKEY];
    [thePathSegments generateObjectsWithType:WaypointObjectType forLetter:RKEY];
    [thePathSegments setZeroingPoint:CGPointMake(xOriginShift, yOriginShift)];
    
    theTrain = [[Train alloc] initWithPathSegments:thePathSegments];
    initialTrainPosition = theTrain.position;
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

- (void)testTheTrainIsAssignedANonEmptyTouchablePath {
    XCTAssertFalse(CGPathIsEmpty(theTrain.touchablePath));
}

- (void)testGivenThePathSegmentsHaveWaypointsWhenTheTrainIsInitializedThenWaypointsAreSetFromThePathSegments {
    CGPoint expectedPoint = CGPointMake(1, 1);
    id mockSegments = OCMClassMock([PathSegments class]);
    NSArray *stubWaypoints = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:expectedPoint], nil];
    OCMStub([mockSegments generatedWaypoints]).andReturn(stubWaypoints);
    Train *thisTrain = [[Train alloc] initWithPathSegments:mockSegments];
    XCTAssertEqualPoints([thisTrain.waypoints[0] CGPointValue], expectedPoint);
}

- (void)testWhenTheTrainHasBeenSetAtTheStartThenTheTrainPositionIsEqualToTheFirstWaypoint {
    CGPoint firstWaypoint = CGPointMake(10, 15);
    [theTrain setWaypoints:[NSMutableArray arrayWithObject:[NSValue valueWithCGPoint:firstWaypoint]]];
    [theTrain positionTrainAtStartPoint];
    XCTAssertEqualPoints(theTrain.position, firstWaypoint);
}

- (void)testTheTrainIsPositionedOffScreenWhenPathSegmentsIsNull {
    Train *emptyPathTrain = [[Train alloc] initWithPathSegments:nil];
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
    [theTrain setIsMoving:NO];
    [theTrain evaluateTouchesMovedAtPoint:CGPointMake(initialTrainPosition.x, initialTrainPosition.y)];
    XCTAssertFalse(theTrain.isMoving);
    XCTAssertEqualPoints(theTrain.position, initialTrainPosition);
}

- (void)testGivenTheTrainIsMovingAndTouchesAreOnThePathWhenTouchesMovedThenTheTrainPositionWillUpdateToTheTouchPosition {
    CGPoint touchPoint = [self simulateTrainMoveWithXYOffsetFromPoint:initialTrainPosition x:0 y:2];
    XCTAssertFalse(CGPathIsEmpty(thePathSegments.generatedSegmentPath));
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
    [self simulateTrainMoveWithXYOffsetFromPoint:initialTrainPosition x:(pathWidth * 10) y:(pathHeight * 10)];
    
    XCTAssertFalse(theTrain.isMoving);
    XCTAssertEqualPoints(theTrain.position, initialTrainPosition);
}

@end

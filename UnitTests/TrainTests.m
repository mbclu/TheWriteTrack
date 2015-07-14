//
//  TrainTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/19/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "Train.h"
#import "PathSegmentDictionary.h"

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "CGMatchers.h"
#import "PathInfo.h"

const uint pathWidth = 16;
const uint pathHeight = 16;
const CGFloat xCenterOffset = 1.0;
const CGFloat yCenterOffset = 3.0;
const CGFloat xOriginShift = 2.0;
const CGFloat yOriginShift = 4.0;

@interface TrainTests : XCTestCase {
    Train *theTrain;
    PathSegments *thePathSegments;
    CGPoint pathSegmentOffset;
    CGPoint initialTrainPosition;
    NSString *RKEY;
}

@end

@implementation TrainTests

- (void)setUp {
    [super setUp];
    thePathSegments = [[PathSegments alloc] initWithRect:CGRectMake(0, 0, pathWidth, pathHeight)];
    RKEY = @"RectangleKey";
    [thePathSegments setLetterSegmentDictionary:[NSDictionary dictionaryWithObject:
                                                 [NSArray arrayWithObjects:
                                                  v0, v1, v2, v3,
                                                  h36, h37, h38, h39,
                                                  v19, v18, v17, v16,
                                                  h23, h22, h21, h20,
                                                  SE, nil] forKey:RKEY]];
    [thePathSegments generateCombinedPathAndWaypointsForLetter:RKEY];
    [thePathSegments generateObjectsWithType:WaypointObjectType forLetter:RKEY];
    
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

- (void)testTheTrainIsAssignedANonEmptyTouchablePathWithTheCorrectProperties {
    XCTAssertFalse(CGPathIsEmpty(theTrain.touchablePath));
    CGPathRef expectedTouchablePath = CGPathCreateCopyByStrokingPath(thePathSegments.generatedSegmentPath, nil, 30.0, kCGLineCapRound, kCGLineJoinRound, 1.0);
    XCTAssertTrue(CGPathEqualToPath(theTrain.touchablePath, expectedTouchablePath));
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

- (void)testWhenATouchIsMovedOutsideThePathThenTheTrainDoesNotMove {
    [self simulateTrainMoveWithXYOffsetFromPoint:initialTrainPosition x:(pathWidth * 10) y:(pathHeight * 10)];
    
    XCTAssertEqualPoints(theTrain.position, initialTrainPosition);
}

- (void)testTheTrainNotifiesItsParentWhenTouchesEnded {
    SKNode *parent = [SKNode node];
    [parent addChild:theTrain];
    
    id mockParent = OCMPartialMock(parent);
    [theTrain touchesEnded:[NSSet set] withEvent:[[UIEvent alloc] init]];
    
    OCMVerify([mockParent touchesEnded:OCMOCK_ANY withEvent:OCMOCK_ANY]);
}

- (void)testTheGeneratedPathSegmentsGetStoredAsATrainProperty {
    XCTAssertEqual(theTrain.pathSegments, thePathSegments);
}

- (void)testWhenThePathSegmentsAreUpdatedThenTheTouchablePathIsUpdatedWithTheCorrectProperties {
    thePathSegments = thePathSegments = [[PathSegments alloc] initWithRect:CGRectMake(1, 1, pathWidth, pathHeight)];
    [theTrain setPathSegments:thePathSegments];
    CGPathRef expectedTouchablePath = CGPathCreateCopyByStrokingPath(thePathSegments.generatedSegmentPath, nil, 30.0, kCGLineCapRound, kCGLineJoinRound, 1.0);
    XCTAssertTrue(CGPathEqualToPath(theTrain.touchablePath, expectedTouchablePath));
}

- (void)testWhenTouchesMovedAtANewPositionThenTheTrainIsNotMovedUnlessThePointIsWithin5PixelsOfTheLastTrainPosition {
    [self simulateTrainMoveWithXYOffsetFromPoint:initialTrainPosition x:(pathWidth) y:(pathHeight)]; // move to a good position
    [self simulateTrainMoveWithXYOffsetFromPoint:theTrain.position x:(pathWidth) y:(0)]; // move to a BAD position, train should NOT go here
    
    XCTAssertEqualPoints(theTrain.position, CGPointMake(pathWidth, pathHeight));
}

@end

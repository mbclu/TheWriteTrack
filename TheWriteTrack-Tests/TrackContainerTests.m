//
//  TrackContainerTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 6/12/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "TrackContainer.h"
#import "PathSegmentsIndeces.h"
#import "Train.h"

#import "CGMatchers.h"

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

NSString *const CrossbarName = @"Crossbar";
NSString *const WaypointName = @"Waypoint";
NSString *const OutlineNodeName = @"LetterOutlineNode";
NSString *const TrainNodeName = @"Train";

@interface TrackContainerTests : XCTestCase {
    TrackContainer *theTrackContainer;
    NSUInteger initialChildCount;
    NSDictionary *thePathDictionary;
    PathSegments *thePathSegments;
    Train *theTrain;
    SKShapeNode *theLetterTrack;
    NSString *theLetterKey;
}

@end

@implementation TrackContainerTests

- (void)setUp {
    [super setUp];
    theLetterKey = @"RECT_KEY";
    theTrackContainer = [self createTrackContainerWithTestSegmentDictionary];
    theLetterTrack = (SKShapeNode *)[theTrackContainer childNodeWithName:@"LetterOutlineNode"];
    theTrain = (Train *)[theTrackContainer childNodeWithName:TrainNodeName];
}

- (void)tearDown {
    [super tearDown];
}

- (TrackContainer *)createTrackContainerWithTestSegmentDictionary {
    thePathSegments = [[PathSegments alloc] init];
    
    thePathDictionary = [NSDictionary dictionaryWithObject:
                         [NSArray arrayWithObjects:
                          v0, v1, v2, v3,
                          h36, h37, h38, h39,
                          v19, v18, v17, v16,
                          h23, h22, h21, h20,
                          SE, nil] forKey:theLetterKey];
    
    [thePathSegments setLetterSegmentDictionary:thePathDictionary];
    
    return [[TrackContainer alloc] initWithLetterKey:theLetterKey andPathSegments:thePathSegments];
}

- (CGPoint)simulateTrainMoveWithXYOffsetFromPoint:(CGPoint)initial x:(uint)x y:(uint)y {
    CGPoint touchPosition = CGPointMake(initial.x + x, initial.y + y);
    [theTrain setIsMoving:YES];
    [theTrain evaluateTouchesMovedAtPoint:touchPosition];
    return touchPosition;
}

- (void)testAnOutlineShapeNodeIsAddedForTheLetterTrack {
    XCTAssertNotNil(theLetterTrack);
    XCTAssertTrue([theLetterTrack isKindOfClass:[SKShapeNode class]]);
    // Test color?
    // Test strokeWidth?
}

- (void)testTheNumberOfCrossbarsAddedIsEqualToTheNumberOfCrossbarsOnTheTrainPath {
    CGPathRef object = CGPathCreateWithRect(CGRectMake(0, 0, 1, 1), nil);
    
    NSArray *objectArray = [NSArray arrayWithObjects:(__bridge id)(object), object, object, object, object, nil];
    
    id mockPathSegments = OCMClassMock([PathSegments class]);
    
    OCMStub([mockPathSegments generateObjectsWithType:CrossbarObjectType forLetter:theLetterKey]).andReturn(objectArray);
    TrackContainer *container = [[TrackContainer alloc] initWithLetterKey:theLetterKey andPathSegments:mockPathSegments];
    
    NSArray *filteredChildren = [[container children] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@", CrossbarName]];
    
    XCTAssertEqual(filteredChildren.count, objectArray.count);
}

- (void)testTheWaypointsAreAddedToTheLetterTrackAsNodes {
    CGPoint object = CGPointMake(0, 10);
    
    NSArray *objectArray = [NSArray arrayWithObjects:
                            [NSValue valueWithCGPoint:object],
                            [NSValue valueWithCGPoint:object],
                            [NSValue valueWithCGPoint:object],
                            nil];
    
    id mockPathSegments = OCMClassMock([PathSegments class]);
    
    OCMStub([mockPathSegments generateObjectsWithType:WaypointObjectType forLetter:theLetterKey]).andReturn(objectArray);
    TrackContainer *container = [[TrackContainer alloc] initWithLetterKey:theLetterKey andPathSegments:mockPathSegments];
    
    NSArray *filteredChildren = [[container children] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@", WaypointName]];

    XCTAssertEqual(filteredChildren.count, objectArray.count);
}

- (void)testTheTrackOutlineIsDrawnBeforeTheCrossbars {
    NSArray *containerChildren = [theTrackContainer children];
    
    XCTAssertNotNil([theTrackContainer childNodeWithName:CrossbarName]);
    
    [containerChildren enumerateObjectsWithOptions:NSEnumerationConcurrent
                                        usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                            SKNode *crossbarNode = (SKNode *)obj;
                                            if ([crossbarNode.name isEqualToString:CrossbarName]) {
                                                XCTAssertLessThan(theLetterTrack.zPosition, crossbarNode.zPosition);
                                            }
                                        }];
}

- (void)testTheTheCrossbarsAreDrawnBeforeTheWaypoints {
    SKNode *aCrossbar = (SKNode *)[theTrackContainer childNodeWithName:CrossbarName];
    NSArray *containerChildren = [theTrackContainer children];
    
    XCTAssertNotNil([theTrackContainer childNodeWithName:WaypointName]);
    
    [containerChildren enumerateObjectsWithOptions:NSEnumerationConcurrent
                                        usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                            SKNode *waypointNode = (SKNode *)obj;
                                            if ([waypointNode.name isEqualToString:WaypointName]) {
                                                XCTAssertLessThan(aCrossbar.zPosition, waypointNode.zPosition);
                                            }
                                        }];
}

- (void)testTheWaypointsAreDrawnBeforeTheTrain {
    SKNode *aWaypoint = (SKNode *)[theTrackContainer childNodeWithName:WaypointName];
    XCTAssertLessThan(aWaypoint.zPosition, theTrain.zPosition);
}

- (void)testGivenThePathSegmentsHaveWaypointsWhenTheContainerIsInitializedThenWaypointsAreSetFromThePathSegments {
    CGPoint expectedPoint = CGPointMake(1, 1);
    id mockSegments = OCMClassMock([PathSegments class]);
    NSArray *stubWaypoints = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:expectedPoint], nil];
    OCMStub([mockSegments generateObjectsWithType:WaypointObjectType forLetter:theLetterKey]).andReturn(stubWaypoints);

    TrackContainer *container = [[TrackContainer alloc] initWithLetterKey:theLetterKey andPathSegments:mockSegments];

    XCTAssertEqualPoints([container.waypoints[0] CGPointValue], expectedPoint);
}

- (void)testWhenTheTrainHasBeenSetAtTheStartThenTheTrainPositionIsEqualToTheFirstWaypoint {
    CGPoint firstWaypoint = CGPointMake(10, 15);
    [theTrackContainer setWaypoints:[NSMutableArray arrayWithObject:[NSValue valueWithCGPoint:firstWaypoint]]];
    [theTrackContainer positionTrainAtStartPoint:theTrain];
    XCTAssertEqualPoints(theTrain.position, firstWaypoint);
}

- (void)testTheTrainIsPositionedOffScreenWhenPathSegmentsIsNull {
    TrackContainer *containerWithNoWaypoints = [[TrackContainer alloc] initWithLetterKey:nil andPathSegments:nil];
    XCTAssertEqualPoints([containerWithNoWaypoints childNodeWithName:TrainNodeName].position, CGPointMake(-100, -100));
}

- (void)testWhenATrainMovesOverAWayPointThenTheWaypointIsRemoved {
//    NSArray *segmentArray = [thePathSegments.letterSegmentDictionary valueForKey:RKEY];
//    XCTAssertEqual(segmentArray.count, 17);
//    
//    [theTrain simulateTrainMoveWithXYOffsetFromPoint:initialTrainPosition
//                                                   x:[theTrain.waypoints[1] CGPointValue].x
//                                                   y:[theTrain.waypoints[1] CGPointValue].y];
//    
//    XCTAssertEqual(segmentArray.count, 16);
//    XCTAssertEqual([segmentArray indexOfObjectIdenticalTo:v0], NSNotFound);
}

@end

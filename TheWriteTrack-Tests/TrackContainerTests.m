//
//  TrackContainerTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 6/12/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "TrackContainer.h"
#import "Constants.h"
#import "PathSegmentsIndeces.h"
#import "Train.h"

#import "CGMatchers.h"

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

@interface TrackContainerTests : XCTestCase {
    TrackContainer *theTrackContainer;
    NSUInteger initialChildCount;
    NSDictionary *thePathDictionary;
    PathSegments *thePathSegments;
    Train *theTrain;
    SKShapeNode *theLetterTrack;
    NSString *theLetterKey;
    CGRect containerBounds;
}

@end

@implementation TrackContainerTests

- (void)setUp {
    [super setUp];
    containerBounds = CGRectMake(0, 0, 8, 8);
    theLetterKey = @"RECT_KEY";
    theTrackContainer = [self createTrackContainerWithTestSegmentDictionary];
    theLetterTrack = (SKShapeNode *)[theTrackContainer childNodeWithName:LetterOutlineName];
    theTrain = (Train *)[theTrackContainer childNodeWithName:TrainNodeName];
}

- (void)tearDown {
    [super tearDown];
}

- (TrackContainer *)createTrackContainerWithTestSegmentDictionary {
    thePathSegments = [[PathSegments alloc] initWithRect:containerBounds];
    
    thePathDictionary = [NSDictionary dictionaryWithObject:
                         [NSArray arrayWithObjects:
                          v0, v1, v2, v3, SE,
                          h36, h37, h38, h39, SE,
                          v19, v18, v17, v16, SE,
                          h23, h22, h21, h20, SE,
                          nil] forKey:theLetterKey];
    
    [thePathSegments setLetterSegmentDictionary:thePathDictionary];
    
    return [[TrackContainer alloc] initWithLetterKey:theLetterKey andPathSegments:thePathSegments];
}

- (NSArray *)get:(SKNode *)node nodesChildrenFilteredByName:(NSString *)name {
    return [[node children] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@", name]];
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
    
    NSArray *filteredChildren = [self get:container nodesChildrenFilteredByName:CrossbarNodeName];
    
    XCTAssertEqual(filteredChildren.count, objectArray.count);
}

- (void)testTheFirstSetOfWaypointsAreAddedToTheLetterTrackAsNodes {
    XCTAssertEqual(theTrackContainer.waypoints.count, 5);
}

- (void)testTheTrackOutlineIsDrawnBeforeTheCrossbars {
    NSArray *containerChildren = [theTrackContainer children];
    
    XCTAssertNotNil([theTrackContainer childNodeWithName:CrossbarNodeName]);
    
    [containerChildren enumerateObjectsWithOptions:NSEnumerationConcurrent
                                        usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                            SKNode *crossbarNode = (SKNode *)obj;
                                            if ([crossbarNode.name isEqualToString:CrossbarNodeName]) {
                                                XCTAssertLessThan(theLetterTrack.zPosition, crossbarNode.zPosition);
                                            }
                                        }];
}

- (void)testTheTheCrossbarsAreDrawnBeforeTheWaypoints {
    SKNode *aCrossbar = (SKNode *)[theTrackContainer childNodeWithName:CrossbarNodeName];
    NSArray *containerChildren = [theTrackContainer children];
    
    XCTAssertNotNil([theTrackContainer childNodeWithName:WaypointNodeName]);
    
    [containerChildren enumerateObjectsWithOptions:NSEnumerationConcurrent
                                        usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                            SKNode *waypointNode = (SKNode *)obj;
                                            if ([waypointNode.name isEqualToString:WaypointNodeName]) {
                                                XCTAssertLessThan(aCrossbar.zPosition, waypointNode.zPosition);
                                            }
                                        }];
}

- (void)testTheWaypointsAreDrawnBeforeTheTrain {
    SKNode *aWaypoint = (SKNode *)[theTrackContainer childNodeWithName:WaypointNodeName];
    XCTAssertLessThan(aWaypoint.zPosition, theTrain.zPosition);
}

- (void)testTheFirstSetOfWaypointsAreAddedIntoTheWaypointArray {
    XCTAssertNotNil(theTrackContainer.waypoints);
    [thePathSegments generateCombinedPathAndWaypointsForLetter:theLetterKey];
    XCTAssertGreaterThan(thePathSegments.generatedWaypoints.count, 0);
    XCTAssertGreaterThan([thePathSegments.generatedWaypoints[0] count], 0);
    XCTAssertEqual(theTrackContainer.waypoints.count, [thePathSegments.generatedWaypoints[0] count]);
}

- (void)testWhenTheTrainHasBeenSetAtTheStartThenTheTrainPositionIsEqualToTheFirstWaypoint {
    SKSpriteNode *firstWaypoint = [[SKSpriteNode alloc] init];
    firstWaypoint.position = CGPointMake(10, 15);
    [theTrackContainer setWaypoints:[NSMutableArray arrayWithObject:firstWaypoint]];
    [theTrackContainer positionTrainAtStartPoint:theTrain];
    XCTAssertEqualPoints(theTrain.position, firstWaypoint.position);
}

- (void)testTheTrainIsPositionedOffScreenWhenPathSegmentsIsNull {
    TrackContainer *containerWithNoWaypoints = [[TrackContainer alloc] initWithLetterKey:nil andPathSegments:nil];
    XCTAssertEqualPoints([containerWithNoWaypoints childNodeWithName:TrainNodeName].position, CGPointMake(-100, -100));
}

- (void)testTheTrainIsConfiguredAsATrainCollisionObject {
    XCTAssertEqual(theTrain.physicsBody.categoryBitMask, TRAIN_CATEGORY);
}

- (void)testTheWaypointIsConfiguredAsAWaypointCollisionObject {
    SKSpriteNode *aWaypoint = (SKSpriteNode *)[theTrackContainer childNodeWithName:WaypointNodeName];
    XCTAssertEqual(aWaypoint.physicsBody.categoryBitMask, WAYPOINT_CATEGORY);
}

- (void)testTheTrainAndWaypointsTestForContactWithEachOther {
    SKSpriteNode *aWaypoint = (SKSpriteNode *)[theTrackContainer childNodeWithName:WaypointNodeName];
    XCTAssertEqual(aWaypoint.physicsBody.contactTestBitMask, TRAIN_CATEGORY);
    XCTAssertEqual(theTrain.physicsBody.contactTestBitMask, WAYPOINT_CATEGORY);
}

- (void)testTheTrainAndWaypointsTestForCollisionsWithNothing {
    SKSpriteNode *aWaypoint = (SKSpriteNode *)[theTrackContainer childNodeWithName:WaypointNodeName];
    XCTAssertEqual(aWaypoint.physicsBody.collisionBitMask, 0);
    XCTAssertEqual(theTrain.physicsBody.collisionBitMask, 0);
}

- (void)simulateContactForPoints:(NSArray *)contactWaypoints {
    for (SKSpriteNode *contactedWaypoint in contactWaypoints) {
        [theTrackContainer evaluateContactForTrainBody:theTrain.physicsBody waypointBody:contactedWaypoint.physicsBody];
    }
}

- (void)testWhenATrainMovesOverAWayPointThenTheWaypointIsRemoved {
    NSArray *waypointNodesBefore = [self get:theTrackContainer nodesChildrenFilteredByName:WaypointNodeName];
    
    XCTAssertEqual(waypointNodesBefore.count, 5);

    [self simulateContactForPoints:[NSArray arrayWithObject:waypointNodesBefore[1]]];

    NSArray *waypointNodesAfter = [self get:theTrackContainer nodesChildrenFilteredByName:WaypointNodeName];
    
    XCTAssertEqual(waypointNodesAfter.count, 4);
}

- (void)testOnceAllOfTheFirstSetOfWaypointsHaveBeenRemovedThenTheNextSetOfWaypointsAreAdded {
    NSArray *waypointNodesBefore = [self get:theTrackContainer nodesChildrenFilteredByName:WaypointNodeName];
    
    XCTAssertEqual(waypointNodesBefore.count, 5);
    
    [self simulateContactForPoints:waypointNodesBefore];
    
    NSArray *waypointNodesAfter = [self get:theTrackContainer nodesChildrenFilteredByName:WaypointNodeName];
    
    XCTAssertEqual(waypointNodesAfter.count, 5);
    XCTAssertEqual([[waypointNodesAfter objectAtIndex:0] position].y, 8);
    XCTAssertEqual([[waypointNodesAfter objectAtIndex:1] position].y, 8);
}

@end

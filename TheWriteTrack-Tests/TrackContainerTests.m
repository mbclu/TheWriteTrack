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
    CGRect containerBounds;
}

@end

@implementation TrackContainerTests

- (void)setUp {
    [super setUp];
    containerBounds = CGRectMake(0, 0, 8, 8);
    theLetterKey = @"RECT_KEY";
    theTrackContainer = [self createTrackContainerWithTestSegmentDictionary];
    theLetterTrack = (SKShapeNode *)[theTrackContainer childNodeWithName:OutlineNodeName];
    theTrain = (Train *)[theTrackContainer childNodeWithName:TrainNodeName];
}

- (void)tearDown {
    [super tearDown];
}

- (TrackContainer *)createTrackContainerWithTestSegmentDictionary {
    thePathSegments = [[PathSegments alloc] initWithRect:containerBounds];
    
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
    
    NSArray *filteredChildren = [self get:container nodesChildrenFilteredByName:CrossbarName];
    
    XCTAssertEqual(filteredChildren.count, objectArray.count);
}

- (void)testTheWaypointsAreAddedToTheLetterTrackAsNodes {
    NSArray *objectArray = [NSArray arrayWithObjects:
                            [NSValue valueWithCGPoint:CGPointMake(0, 10)],
                            [NSValue valueWithCGPoint:CGPointMake(0, 20)],
                            [NSValue valueWithCGPoint:CGPointMake(10, 30)],
                            nil];
    
    id mockPathSegments = OCMClassMock([PathSegments class]);
    
    OCMStub([mockPathSegments generateObjectsWithType:WaypointObjectType forLetter:theLetterKey]).andReturn(objectArray);
    TrackContainer *container = [[TrackContainer alloc] initWithLetterKey:theLetterKey andPathSegments:mockPathSegments];
    
    NSArray *filteredChildren = [self get:container nodesChildrenFilteredByName:WaypointName];
    
    XCTAssertEqual(filteredChildren.count, 3);
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

- (void)testTheWaypointsAreAddedIntoTheWaypointArray {
    XCTAssertNotNil(theTrackContainer.waypoints);
    NSArray *generatedWaypoints = [thePathSegments generateObjectsWithType:WaypointObjectType forLetter:theLetterKey];
    XCTAssertGreaterThan(generatedWaypoints.count, 0);
    XCTAssertEqual(theTrackContainer.waypoints.count, generatedWaypoints.count);
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
    SKSpriteNode *aWaypoint = (SKSpriteNode *)[theTrackContainer childNodeWithName:WaypointName];
    XCTAssertEqual(aWaypoint.physicsBody.categoryBitMask, WAYPOINT_CATEGORY);
}

- (void)testTheTrainAndWaypointsTestForContactWithEachOther {
    SKSpriteNode *aWaypoint = (SKSpriteNode *)[theTrackContainer childNodeWithName:WaypointName];
    XCTAssertEqual(aWaypoint.physicsBody.contactTestBitMask, TRAIN_CATEGORY);
    XCTAssertEqual(theTrain.physicsBody.contactTestBitMask, WAYPOINT_CATEGORY);
}

- (void)testTheTrainAndWaypointsTestForCollisionsWithNothing {
    SKSpriteNode *aWaypoint = (SKSpriteNode *)[theTrackContainer childNodeWithName:WaypointName];
    XCTAssertEqual(aWaypoint.physicsBody.collisionBitMask, 0);
    XCTAssertEqual(theTrain.physicsBody.collisionBitMask, 0);
}

- (void)testWhenATrainMovesOverAWayPointThenTheWaypointIsRemoved {
    NSArray *waypointNodesBefore = [self get:theTrackContainer nodesChildrenFilteredByName:WaypointName];
    
    XCTAssertEqual(waypointNodesBefore.count, 16);  // 2 x 16 straight segments

    SKPhysicsBody *contactedWaypoint = [[waypointNodesBefore objectAtIndex:1] physicsBody];
    
    [theTrackContainer evaluateContactForTrainBody:theTrain.physicsBody waypointBody:contactedWaypoint];

    NSArray *waypointNodesAfter = [self get:theTrackContainer nodesChildrenFilteredByName:WaypointName];
    
    XCTAssertEqual(waypointNodesAfter.count, 15);
}

@end

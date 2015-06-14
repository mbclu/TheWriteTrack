//
//  TrackContainer.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 6/12/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "TrackContainer.h"
#import "Constants.h"
#import "LayoutMath.h"
#import "Train.h"

@implementation TrackContainer

- (instancetype)initWithLetterKey:(NSString *)letterKey andPathSegments:(PathSegments *)pathSegments {
    self = [super init];
    
    _pathSegments = pathSegments;
    if (_pathSegments == nil) {
        _pathSegments = [[PathSegments alloc] init];
    }
    
    _letterKey = letterKey;
    
    self.name = LetterSceneTrackContainerNodeName;
    
    [self addChild:[SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:_pathSegments.segmentBounds.size]];

    SKShapeNode *trackOutline = [self createTrackOutlineNode:[_pathSegments generateCombinedPathForLetter:_letterKey]];
    [self addChild:trackOutline];
    
    [self addCrossbarsAndWaypointsToTrackContainer];
    
    [self assignCenteringPointUsingShapeNode:trackOutline];
    
    [self addChild:[self createTrainNodeWithPathSegments:_pathSegments]];
    
    self.position = _centeringPoint;
    
    return self;
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *trainBody = contact.bodyA;
    SKPhysicsBody *waypointBody = contact.bodyB;
    
    if (contact.bodyA.categoryBitMask == WAYPOINT_CATEGORY)
    {
        waypointBody = contact.bodyA;
        trainBody = contact.bodyB;
    }
    
    [self evaluateContactForTrainBody:trainBody waypointBody:waypointBody];
}

- (void)evaluateContactForTrainBody:(SKPhysicsBody *)trainBody waypointBody:(SKPhysicsBody *)waypointBody {
    if ((trainBody.categoryBitMask & TRAIN_CATEGORY) != 0 &&
        (waypointBody.categoryBitMask & WAYPOINT_CATEGORY) != 0)
    {
        [waypointBody.node removeFromParent];
    }
}

- (void)positionTrainAtStartPoint:(Train *)train {
    if (_waypoints.count > 0) {
        train.position = [(SKSpriteNode *)[_waypoints objectAtIndex:0] position];
    }
    else {
        train.position = CGPointMake(-100, -100);
    }
}

- (SKShapeNode *)createTrackOutlineNode:(CGPathRef)combinedPath {
    SKShapeNode *outlineNode = [SKShapeNode shapeNodeWithPath:
                                CGPathCreateCopyByStrokingPath(combinedPath,
                                                               nil,
                                                               25.0,
                                                               kCGLineCapButt,
                                                               kCGLineJoinBevel,
                                                               1.0)
                                ];
    
    outlineNode.name = LetterOutlineName;
    outlineNode.lineWidth = 7.0;
    outlineNode.strokeColor = [SKColor darkGrayColor];
    outlineNode.zPosition = TrackContainerTrackOutlineZPosition;
    
    return outlineNode;
}

- (void)addCrossbarsAndWaypointsToTrackContainer {
    [self createSpritesForCrossbars:[_pathSegments generateObjectsWithType:CrossbarObjectType forLetter:_letterKey]];

    NSArray *waypointValues = [_pathSegments generateObjectsWithType:WaypointObjectType forLetter:_letterKey];
    [self createSpritesForWaypoints:waypointValues];
}

- (void)createSpritesForCrossbars:(NSArray *)crossbars {
    for (NSUInteger i = 0; i < crossbars.count; i++) {
        [self addCrossbarWithPath:(__bridge CGPathRef)[crossbars objectAtIndex:i]];
    }
}

- (void)addCrossbarWithPath:(CGPathRef)crossbarPath {
    SKShapeNode *crossbarNode = [SKShapeNode shapeNodeWithPath:crossbarPath];
    
    crossbarNode.lineWidth = 8.0;
    crossbarNode.strokeColor = [SKColor brownColor];
    crossbarNode.name = @"Crossbar";
    crossbarNode.zPosition = TrackContainerCrossbarZPosition;
    
    [self addChild:crossbarNode];
}

- (void)createSpritesForWaypoints:(NSArray *)waypoints {
    _waypoints = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < waypoints.count; i++) {
        [self addEnvelopeAtPoint:[[waypoints objectAtIndex:i] CGPointValue]];
    }
}

- (void)addEnvelopeAtPoint:(CGPoint)position {
    SKSpriteNode *envelope = [[SKSpriteNode alloc] initWithImageNamed:EnvelopeName];
    
    envelope.name = @"Waypoint";
    envelope.position = position;
    envelope.zPosition = TrackContainerWaypointZPosition;
    
    envelope.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:envelope.size];
    envelope.physicsBody.categoryBitMask = WAYPOINT_CATEGORY;
    envelope.physicsBody.contactTestBitMask = TRAIN_CATEGORY;
    envelope.physicsBody.collisionBitMask = 0;
    
    [_waypoints addObject:envelope];
    [self addChild:envelope];
}

- (Train *)createTrainNodeWithPathSegments:(PathSegments *)segments {
    Train *trainNode = [[Train alloc] initWithPathSegments:segments];
    trainNode.name = TrainNodeName;
    trainNode.zPosition = TrackContainerTrainZPosition;
    
    trainNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:trainNode.size];
    trainNode.physicsBody.categoryBitMask = TRAIN_CATEGORY;
    trainNode.physicsBody.contactTestBitMask = WAYPOINT_CATEGORY;
    trainNode.physicsBody.collisionBitMask = 0;

    [self positionTrainAtStartPoint:trainNode];
    
    return trainNode;
}

- (void)assignCenteringPointUsingShapeNode:(SKShapeNode *)node {
    CGRect pathBoundingBox = CGPathGetPathBoundingBox(node.path);
    _centeringPoint = [LayoutMath centerOfMainScreen];
    _centeringPoint.x -= HALF_OF(pathBoundingBox.size.width) + pathBoundingBox.origin.x;
    _centeringPoint.y -= HALF_OF(pathBoundingBox.size.height) + pathBoundingBox.origin.y;
}

@end

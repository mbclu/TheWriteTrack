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
    _currentWaypointArrayIndex = 0;
    
    self.name = LetterSceneTrackContainerNodeName;
    
    [self addChild:[SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:_pathSegments.segmentBounds.size]];

    [_pathSegments generateCombinedPathAndWaypointsForLetter:_letterKey];
    SKShapeNode *trackOutline = [self createTrackOutlineNode:_pathSegments.generatedSegmentPath];
    [self addChild:trackOutline];
    
    [self addCrossbarsToTrackContainer];
    [self addWaypointsToTrackContainer];
    
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

- (NSArray *)getWaypointChildren {
    return [[self children] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@", WaypointNodeName]];
}

- (void)evaluateContactForTrainBody:(SKPhysicsBody *)trainBody waypointBody:(SKPhysicsBody *)waypointBody {
    if ((trainBody.categoryBitMask & TRAIN_CATEGORY) != 0 &&
        (waypointBody.categoryBitMask & WAYPOINT_CATEGORY) != 0)
    {
        [waypointBody.node removeFromParent];
    }
    
    if ([self getWaypointChildren].count == 0) {
        _currentWaypointArrayIndex++;
        [self addWaypointsToTrackContainer];
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

- (void)addCrossbarsToTrackContainer {
    [self createSpritesForCrossbars:[_pathSegments generateObjectsWithType:CrossbarObjectType forLetter:_letterKey]];
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
    crossbarNode.name = CrossbarNodeName;
    crossbarNode.zPosition = TrackContainerCrossbarZPosition;
    
    [self addChild:crossbarNode];
}

- (void)addWaypointsToTrackContainer {
    if (_pathSegments.generatedWaypoints.count > _currentWaypointArrayIndex) {
        NSArray *waypointValues = [_pathSegments.generatedWaypoints objectAtIndex:_currentWaypointArrayIndex];
        [self createSpritesForWaypoints:waypointValues];
    }
}

- (void)createSpritesForWaypoints:(NSArray *)waypoints {
    _waypoints = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < waypoints.count; i++) {
        [self addEnvelopeAtPoint:[[waypoints objectAtIndex:i] CGPointValue]];
    }
}

- (void)addEnvelopeAtPoint:(CGPoint)position {
    SKSpriteNode *envelope = [[SKSpriteNode alloc] initWithImageNamed:EnvelopeTextureName];
    
    envelope.name = WaypointNodeName;
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

- (void)beginDemonstration {
    Train *train = (Train *)[self childNodeWithName:TrainNodeName];
    NSMutableArray *actionSequence = [[NSMutableArray alloc] init];
    
    for (id array in _pathSegments.generatedWaypoints) {
        
        train.position = [array[0] CGPointValue];
        
        for (id point in array) {
            SKAction *demoAction = [SKAction moveTo:[point CGPointValue] duration:0.3];
            [actionSequence addObject:demoAction];
        }
        
        [train runAction:[SKAction sequence:actionSequence]];
    }
}

@end

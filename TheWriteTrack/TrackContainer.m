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
    
    SKShapeNode *trackOutline = [self createTrackOutlineNode:[_pathSegments generateCombinedPathForLetter:_letterKey]];
    [self addChild:trackOutline];
    
    [self addCrossbarsAndWaypointsToTrackContainer];
    
    [self assignCenteringPointUsingShapeNode:trackOutline];
    
    [self addChild:[self createTrainNodeWithPathSegments:_pathSegments]];
    
    self.position = _centeringPoint;
    
    return self;
}

- (void)positionTrainAtStartPoint:(Train *)train {
    if (_waypoints.count > 0) {
        CGPoint firstPoint = [(NSValue *)[_waypoints objectAtIndex:0] CGPointValue];
        [train setPosition:firstPoint];
    }
    else {
        [train setPosition:CGPointMake(-100, -100)];
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

    _waypoints = [_pathSegments generateObjectsWithType:WaypointObjectType forLetter:_letterKey];
    [self createSpritesForWaypoints:_waypoints];
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
    for (NSInteger i = 0; i < waypoints.count; i++) {
        CGPoint envelopePosition = [[waypoints objectAtIndex:i] CGPointValue];
        [self addEnvelopeAtPoint:envelopePosition];
    }
}

- (void)addEnvelopeAtPoint:(CGPoint)position {
    SKSpriteNode *envelope = [[SKSpriteNode alloc] initWithImageNamed:EnvelopeName];
    
    envelope.name = @"Waypoint";
    envelope.position = position;
    envelope.zPosition = TrackContainerWaypointZPosition;
    
    [self addChild:envelope];
}

- (Train *)createTrainNodeWithPathSegments:(PathSegments *)segments {
    Train *trainNode = [[Train alloc] initWithPathSegments:segments];
    trainNode.name = TrainNodeName;
    trainNode.zPosition = TrackContainerTrainZPosition;

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

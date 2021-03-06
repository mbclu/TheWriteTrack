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
#import "LetterScene.h"
#import "SettingsKeys.h"

#if (DEBUG)
NSTimeInterval const defaultTrainMoveIntervalInSeconds = 0.2;
NSTimeInterval const defaultSceneTransitionWaitInSeconds = 0.1;
#else
NSTimeInterval const defaultTrainMoveIntervalInSeconds = 0.4;
NSTimeInterval const defaultSceneTransitionWaitInSeconds = 0.55;
#endif

@implementation TrackContainer

- (instancetype)initWithLetterKey:(NSString *)letterKey andPathSegments:(PathSegments *)pathSegments {
    self = [super init];
    
    [self initializeProperties:letterKey pathSegments:pathSegments];

    [self initializeChildren];

    [self centerThyself:(SKShapeNode *)[self childNodeWithName:LetterOutlineName]];

    self.name = LetterSceneTrackContainerNodeName;
    
    return self;
}

- (void)initializeProperties:(NSString *)letterKey pathSegments:(PathSegments *)pathSegments {
    _letterKey = letterKey;
    _pathSegments = pathSegments;
    if (_pathSegments == nil) {
        _pathSegments = [[PathSegments alloc] init];
    }
    _currentWaypointArrayIndex = 0;
    _shouldDemo = YES;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_SETTINGS_BOOL_KEY_SHOULD_SKIP_DEMO]) {
        _shouldDemo = NO;
    }
    _shouldResetTrain = NO;
    _shouldChangeScenes = NO;
    _sceneTransitionWaitInSeconds = defaultSceneTransitionWaitInSeconds;
}

- (void)initializeChildren {
    [_pathSegments generateCombinedPathAndWaypointsForLetter:_letterKey];
    SKShapeNode *trackOutline = [self createTrackOutlineNode:_pathSegments.generatedSegmentPath];
    [self addChild:trackOutline];
    
    [self addCrossbarsToTrackContainer];
    
    [self addWaypointsToTrackContainer];
    
    [self addChild:[self createTrainNodeWithPathSegments:_pathSegments]];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self evaluateTouchesBegan];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self evaluateTouchesEnded];
}

- (void)evaluateContactForTrainBody:(SKPhysicsBody *)trainBody waypointBody:(SKPhysicsBody *)waypointBody {
    if ((trainBody.categoryBitMask & TRAIN_CATEGORY) != 0 &&
        (waypointBody.categoryBitMask & WAYPOINT_CATEGORY) != 0)
    {
        [waypointBody.node removeFromParent];
        [self determinePostWaypointRemovalAction];
    }
}

- (void)determinePostWaypointRemovalAction {
    if ([self getWaypointChildren].count == 0) {
        if (++_currentWaypointArrayIndex == _pathSegments.generatedWaypointArrays.count) {
            if (_isDemoing) {
                _isDemoing = NO;
                _currentWaypointArrayIndex = 0;
            }
            else {
                _shouldChangeScenes = YES;
                return;
            }
        }
        _shouldResetTrain = YES;
    }
}

- (void)notifyLastWaypointWasRemoved {
    if ([_letterKey isEqual: @"Z"]) {
        [(LetterScene *)self.parent performSelector:@selector(transitionToLetterSelectScene)];
    } else {
        [(LetterScene *)self.parent performSelector:@selector(transitionToNextScene)];
    }
}

- (void)evaluateTouchesEnded {
    if (_shouldChangeScenes) {
        [self waitAndNotifyParentOfSceneChange];
    }
    
    if (_shouldResetTrain) {
        [self resetWaypointsAndTrain];
    }
}

- (void)evaluateTouchesBegan {
    [self childNodeWithName:TrainNodeName].physicsBody.contactTestBitMask = WAYPOINT_CATEGORY;
}

- (void)positionTrainAtStartPoint:(Train *)train {
    if ([self getWaypointChildren].count > 0) {
        CGPoint position = [(SKSpriteNode *)[[self getWaypointChildren] objectAtIndex:0] position];
        train.position = position;
        if (_shouldDemo) {
            [self beginDemonstration];
        }
    }
    else {
        train.position = CGPointMake(-100, -100);
    }
}

- (void)waitAndNotifyParentOfSceneChange {
    if (_sceneTransitionWaitInSeconds > 0.0) {
        [self runAction:[SKAction waitForDuration:_sceneTransitionWaitInSeconds] completion:^{
            [self notifyLastWaypointWasRemoved];
        }];
    }
    else {
        [self notifyLastWaypointWasRemoved];
    }
}

- (void)resetWaypointsAndTrain {
    _shouldResetTrain = NO;
    [self childNodeWithName:TrainNodeName].physicsBody.contactTestBitMask = 0;
    [self addWaypointsToTrackContainer];
    [self positionTrainAtStartPoint:(Train *)[self childNodeWithName:TrainNodeName]];
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
    if (_pathSegments.generatedWaypointArrays.count > _currentWaypointArrayIndex) {
        NSArray *waypointValues = [_pathSegments.generatedWaypointArrays objectAtIndex:_currentWaypointArrayIndex];
        [self createSpritesForWaypoints:waypointValues];
    }
}

- (void)createSpritesForWaypoints:(NSArray *)waypoints {
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
    
    [self addChild:envelope];
}

- (Train *)createTrainNodeWithPathSegments:(PathSegments *)segments {
    Train *trainNode = [[Train alloc] initWithPathSegments:segments];
    trainNode.name = TrainNodeName;
    trainNode.zPosition = TrackContainerTrainZPosition;
    
    trainNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:trainNode.size];
    trainNode.physicsBody.categoryBitMask = TRAIN_CATEGORY;
    trainNode.physicsBody.contactTestBitMask = 0;
    trainNode.physicsBody.collisionBitMask = 0;

    [self positionTrainAtStartPoint:trainNode];
    
    return trainNode;
}

- (void)centerThyself:(SKShapeNode *)node {
    CGRect pathBoundingBox = CGPathGetPathBoundingBox(node.path);
    CGPoint centeringPoint = [LayoutMath centerOfMainScreen];
    centeringPoint.x -= HALF_OF(pathBoundingBox.size.width) + pathBoundingBox.origin.x;
    centeringPoint.y -= HALF_OF(pathBoundingBox.size.height) + pathBoundingBox.origin.y;
    self.position = centeringPoint;
}

- (SKAction *)createDemonstrationActionSequenceWithDuration:(NSTimeInterval)seconds {
    NSMutableArray *actionSequence = [[NSMutableArray alloc] init];
    
    for (SKShapeNode *waypoint in [self getWaypointChildren]) {
        SKAction *demoAction = [SKAction moveTo:waypoint.position duration:seconds];
        [actionSequence addObject:demoAction];
    }
    
    return [SKAction sequence:actionSequence];
}

- (void)beginDemonstration {
    [self beginDemonstrationWithDuration:defaultTrainMoveIntervalInSeconds andCompletionHandler:^{
        [self resetWaypointsAndTrain];
    }];
}

- (void)beginDemonstrationWithDuration:(NSTimeInterval)seconds andCompletionHandler:(demoCompletion) completionHandler {
    if (_shouldDemo) {
        _isDemoing = YES;
        Train *train = (Train *)[self childNodeWithName:TrainNodeName];
        train.physicsBody.contactTestBitMask = WAYPOINT_CATEGORY;
        [train runAction:[self createDemonstrationActionSequenceWithDuration:defaultTrainMoveIntervalInSeconds] completion:completionHandler];
    }
}

- (NSArray *)getWaypointChildren {
    return [[self children] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name == %@", WaypointNodeName]];
}

- (void)skipDemo {
    _shouldDemo = NO;
}

@end

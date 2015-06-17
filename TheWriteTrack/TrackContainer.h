//
//  TrackContainer.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 6/12/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "PathSegments.h"
#import "Train.h"
#import <SpriteKit/SpriteKit.h>

static const uint32_t TRAIN_CATEGORY    = 0x1 << 0;
static const uint32_t WAYPOINT_CATEGORY = 0x1 << 1;

typedef NS_ENUM(NSUInteger, ETrackContainerSceneZOrder) {
    TrackContainerTrackOutlineZPosition,
    TrackContainerCrossbarZPosition,
    TrackContainerWaypointZPosition,
    TrackContainerTrainZPosition
};

typedef void(^demoCompletion)(void);

@interface TrackContainer : SKNode <SKPhysicsContactDelegate>

@property PathSegments *pathSegments;
@property NSString *letterKey;
@property NSUInteger currentWaypointArrayIndex;
@property BOOL isDemoing;

- (instancetype)initWithLetterKey:(NSString *)letterKey andPathSegments:(PathSegments *)pathSegments;
- (void)positionTrainAtStartPoint:(Train *)train;
- (void)evaluateContactForTrainBody:(SKPhysicsBody *)trainBody waypointBody:(SKPhysicsBody *)waypointBody;
- (void)notifyLastWaypointWasRemoved;
- (SKAction *)createDemonstrationActionSequenceWithDuration:(NSTimeInterval)seconds;
- (void)beginDemonstration;
- (void)beginDemonstrationWithDuration:(NSTimeInterval)seconds andCompletionHandler:(demoCompletion) completionHandler;

@end

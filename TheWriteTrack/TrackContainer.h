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

@interface TrackContainer : SKNode <SKPhysicsContactDelegate>

@property PathSegments *pathSegments;
@property NSString *letterKey;
@property CGPoint centeringPoint;
@property NSMutableArray *waypoints;

- (instancetype)initWithLetterKey:(NSString *)letterKey andPathSegments:(PathSegments *)pathSegments;
- (void)positionTrainAtStartPoint:(Train *)train;

@end

//
//  Train.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/19/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "AttributedStringPath.h"
#import "PathSegments.h"
#import <SpriteKit/SpriteKit.h>

@interface Train : SKSpriteNode

@property PathSegments *pathSegments;
@property NSMutableArray *waypoints;
@property CGPoint centerOffset;
@property BOOL isMoving;

- (instancetype)initWithPathSegments:(PathSegments *)pathSegments andCenterOffset:(CGPoint)centerOffset;
- (instancetype)init NS_UNAVAILABLE;
- (void)positionTrainAtStartPoint;
- (void)evaluateTouchesBeganAtPoint:(CGPoint)touchPoint;
- (void)evaluateTouchesMovedAtPoint:(CGPoint)touchPoint;
- (void)evaluateTouchesEndedAtPoint:(CGPoint)touchPoint;

@end

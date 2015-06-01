//
//  Train.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/19/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "AttributedStringPath.h"
#import <SpriteKit/SpriteKit.h>

@interface Train : SKSpriteNode

@property (nonatomic) CGPathRef letterPath;
@property (nonatomic, retain) NSArray *waypoints;
@property BOOL isMoving;

- (instancetype)initWithPath:(CGPathRef)letterPath;
- (instancetype)init NS_UNAVAILABLE;
- (void)positionTrainAtStartPoint;
- (void)evaluateTouchesBeganAtPoint:(CGPoint)touchPoint;
- (void)evaluateTouchesMovedAtPoint:(CGPoint)touchPoint;
- (void)evaluateTouchesEndedAtPoint:(CGPoint)touchPoint;

@end

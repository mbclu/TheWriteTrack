//
//  Train.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/19/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "Train.h"

#import "LayoutMath.h"
#import "PathInfo.h"
#import "PathSegments.h"

NSString *const MagicTrainName = @"MagicTrain";
NSString *const TrainName = @"Train";

@implementation Train

- (instancetype)initWithPathSegments:(PathSegments *)pathSegments andCenterOffset:(CGPoint)centerOffset {
    self = [super initWithImageNamed:MagicTrainName];
    
    _centerOffset = centerOffset;
    _isMoving = NO;
    
    self.userInteractionEnabled = YES;
    
    [self setName:TrainName];
    
    [self setPathSegments:pathSegments];
    [self setWaypoints:pathSegments.waypoints];
    
    [self positionTrainAtStartPoint];
    
    return self;
}

- (void)positionTrainAtStartPoint {
    if (_waypoints.count > 0) {
        CGPoint firstPoint = [(NSValue *)[_waypoints objectAtIndex:0] CGPointValue];
        INCREMENT_POINT_BY_POINT(firstPoint, _pathSegments.centerShift);
        [self setPosition:firstPoint];
    }
    else {
        [self setPosition:CGPointMake(-100, -100)];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self evaluateTouchesBeganAtPoint:[[touches anyObject] locationInNode:self.parent]];
}

- (void)evaluateTouchesBeganAtPoint:(CGPoint)touchPoint {
    if (CGRectContainsPoint(self.frame, touchPoint)) {
        _isMoving = YES;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self evaluateTouchesMovedAtPoint:[[touches anyObject] locationInNode:self.parent]];
}

- (void)evaluateTouchesMovedAtPoint:(CGPoint)touchPoint {
    if (_isMoving == YES && CGPathContainsPoint(_pathSegments.generatedSegmentPath, nil, touchPoint, NO)) {
        self.position = touchPoint;
    }
    else {
        _isMoving = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self evaluateTouchesEndedAtPoint:[[touches anyObject] locationInNode:self.parent]];
}

- (void)evaluateTouchesEndedAtPoint:(CGPoint)touchPoint {
    _isMoving = NO;
}

@end

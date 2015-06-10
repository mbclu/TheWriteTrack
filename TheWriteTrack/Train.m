//
//  Train.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/19/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "Train.h"

#import "Constants.h"
#import "LayoutMath.h"
#import "PathInfo.h"
#import "PathSegments.h"

#import "CocoaLumberjack.h"

NSString *const MagicTrainName = @"MagicTrain";
NSString *const TrainName = @"Train";

@implementation Train

- (instancetype)initWithPathSegments:(PathSegments *)pathSegments {
    self = [super initWithImageNamed:MagicTrainName];
    
    _isMoving = NO;
    
    self.userInteractionEnabled = YES;
    
    [self setName:TrainName];
    
    [self setPathSegments:pathSegments];
    [self setWaypoints:pathSegments.generatedWaypoints];

    _touchablePath = CGPathCreateCopyByStrokingPath(_pathSegments.generatedSegmentPath, nil, 30.0, kCGLineCapRound, kCGLineJoinRound, 1.0);
    
    [self positionTrainAtStartPoint];
    
    return self;
}

- (void)positionTrainAtStartPoint {
    if (_waypoints.count > 0) {
        CGPoint firstPoint = [(NSValue *)[_waypoints objectAtIndex:0] CGPointValue];
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
    DDLogInfo(@"Touches began at point %@ in Train class.", NSStringFromCGPoint(touchPoint));

    if (CGRectContainsPoint(self.frame, touchPoint)) {
        _isMoving = YES;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self evaluateTouchesMovedAtPoint:[[touches anyObject] locationInNode:self.parent]];
}

- (void)evaluateTouchesMovedAtPoint:(CGPoint)touchPoint {
    if (_isMoving == YES && CGPathContainsPoint(_touchablePath, nil, touchPoint, NO)) {
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
    DDLogInfo(@"Touches ended at point %@ in Train class.", NSStringFromCGPoint(touchPoint));

    _isMoving = NO;
}

@end

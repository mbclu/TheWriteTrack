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

NSString *const TrainName = @"Train";

@implementation Train

- (instancetype)initWithPathSegments:(PathSegments *)pathSegments {
    self = [super initWithImageNamed:@"MagicTrain2"];
    
    _isMoving = NO;
    
    self.userInteractionEnabled = YES;
    
    [self setName:TrainName];
    
    _touchablePath = CGPathCreateCopyByStrokingPath(pathSegments.generatedSegmentPath, nil, 30.0, kCGLineCapRound, kCGLineJoinRound, 1.0);
    
    return self;
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

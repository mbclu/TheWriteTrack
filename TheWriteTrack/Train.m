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
CGFloat const maxMoveAmount = 10.0;

@implementation Train

@synthesize pathSegments;

- (instancetype)initWithPathSegments:(PathSegments *)somePathSegments {
    self = [super initWithImageNamed:@"MagicTrain2"];
    
    _isMoving = NO;
    
    self.userInteractionEnabled = YES;
    
    [self setName:TrainName];
    
    [self setPathSegments:somePathSegments];
    
    return self;
}

- (void)setPathSegments:(PathSegments *)newPathSegments {
    pathSegments = newPathSegments;
    _touchablePath = CGPathCreateCopyByStrokingPath(pathSegments.generatedSegmentPath, nil, 30.0, kCGLineCapRound, kCGLineJoinRound, 1.0);
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
    if (_isMoving == YES && CGPathContainsPoint(_touchablePath, nil, touchPoint, NO) && [self didMoveIncrementallyWithPosition:touchPoint]) {
        self.position = touchPoint;
    }
}

- (BOOL)didMoveIncrementallyWithPosition:(CGPoint)touchPoint {
    BOOL ressult = NO;
    if (CGRectContainsPoint(CGRectMake(self.frame.origin.x - maxMoveAmount,
                                       self.frame.origin.y - maxMoveAmount,
                                       self.frame.size.width + maxMoveAmount,
                                       self.frame.size.height + maxMoveAmount),
                            touchPoint)) {
        ressult = YES;
    }
    return ressult;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self evaluateTouchesEndedAtPoint:[[touches anyObject] locationInNode:self.parent]];
    [self.parent touchesEnded:touches withEvent:event];
}

- (void)evaluateTouchesEndedAtPoint:(CGPoint)touchPoint {
    DDLogInfo(@"Touches ended at point %@ in Train class.", NSStringFromCGPoint(touchPoint));

    _isMoving = NO;
}

@end

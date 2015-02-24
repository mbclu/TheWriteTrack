//
//  Train.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/20/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "Train.h"

static const int POINTS_PER_SECOND = 80;

@implementation Train
{
    NSMutableArray *_wayPoints;
    CGPoint _velocity;
}

@synthesize pointsPerSecond;

- (instancetype) init {
    self = [super init];
    if (self) {
        pointsPerSecond = POINTS_PER_SECOND;
    }
    return self;
}

- (instancetype)initWithImageNamed:(NSString *)name {
    self = [self init];
    if(self = [super initWithImageNamed:name]) {
        _wayPoints = [NSMutableArray array];
    }
    
    return self;
}

- (void)addPointToMove:(CGPoint)point {
    [_wayPoints addObject:[NSValue valueWithCGPoint:point]];
}

- (void)move:(NSNumber *)dt {
    CGPoint currentPosition = self.position;
    CGPoint newPosition;
    
    if([_wayPoints count] > 0) {
        CGPoint targetPoint = [[_wayPoints firstObject] CGPointValue];
        
        //1
        CGPoint offset = CGPointMake(targetPoint.x - currentPosition.x, targetPoint.y - currentPosition.y);
        CGFloat length = sqrtf(offset.x * offset.x + offset.y * offset.y);
        CGPoint direction = CGPointMake(offset.x / length, offset.y / length);
        _velocity = CGPointMake(direction.x * POINTS_PER_SECOND, direction.y * POINTS_PER_SECOND);
        
        //2
        newPosition = CGPointMake(currentPosition.x + _velocity.x * [dt doubleValue],
                                  currentPosition.y + _velocity.y * [dt doubleValue]);
        self.position = newPosition;
        
        //3
        if(CGRectContainsPoint(self.frame, targetPoint)) {
            [_wayPoints removeObjectAtIndex:0];
        }
    }
}

- (void) dealloc {
}

@end

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

@synthesize pointsPerSecond;
@synthesize wayPoints;
@synthesize velocity;

- (instancetype)initWithImageNamed:(NSString *)name {
    if(self = [super initWithImageNamed:name]) {
        pointsPerSecond = POINTS_PER_SECOND;
        wayPoints = [NSMutableArray array];
    }
    
    return self;
}

- (void)addPointToMove:(CGPoint)point {
    [wayPoints addObject:[NSValue valueWithCGPoint:point]];
}

- (void)move:(NSNumber *)dt {
    CGPoint currentPosition = self.position;
    CGPoint newPosition;
    
    if([wayPoints count] > 0) {
        CGPoint targetPoint = [[wayPoints firstObject] CGPointValue];
        
        //1
        CGPoint offset = CGPointMake(targetPoint.x - currentPosition.x, targetPoint.y - currentPosition.y);
        CGFloat length = sqrtf(offset.x * offset.x + offset.y * offset.y);
        CGPoint direction = CGPointMake(offset.x / length, offset.y / length);
        velocity = CGPointMake(direction.x * POINTS_PER_SECOND, direction.y * POINTS_PER_SECOND);
        
        //2
        newPosition = CGPointMake(currentPosition.x + velocity.x * [dt doubleValue],
                                  currentPosition.y + velocity.y * [dt doubleValue]);
        self.position = newPosition;
        
        //3
        if(CGRectContainsPoint(self.frame, targetPoint)) {
            [wayPoints removeObjectAtIndex:0];
        }
    }
}

@end

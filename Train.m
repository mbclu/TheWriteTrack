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

@end

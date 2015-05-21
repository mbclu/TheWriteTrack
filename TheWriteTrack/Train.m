//
//  Train.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/19/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "Train.h"

NSString *const MagicTrainName = @"MagicTrain";
NSString *const TrainName = @"Train";

@implementation Train

- (instancetype)initWithAttributedStringPath:(AttributedStringPath*)letterPath {
    self = [super initWithImageNamed:MagicTrainName];
    self.name = TrainName;
    [self setLetterPath:letterPath];
    [self setWaypoints:[NSArray arrayWithObject:[NSValue valueWithCGPoint:CGPointMake(0, 0)]]];
    [self positionTrainAtStartPoint];
    return self;
}

- (void)positionTrainAtStartPoint {
    NSValue *firstPoint = (NSValue *)[_waypoints objectAtIndex:0];
    [self setPosition:[firstPoint CGPointValue]];
}

@end

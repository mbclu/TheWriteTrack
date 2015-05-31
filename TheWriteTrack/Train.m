//
//  Train.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/19/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "Train.h"
#import "PathInfo.h"

NSString *const MagicTrainName = @"MagicTrain";
NSString *const TrainName = @"Train";

@implementation Train

- (instancetype)initWithPath:(CGPathRef)letterPath {
    self = [super initWithImageNamed:MagicTrainName];
    
    [self setName:TrainName];
    
    [self setLetterPath:letterPath];
    
    PathInfo *pathInfo = [[PathInfo alloc] init];
    [self setWaypoints:[pathInfo TransformPathToArray:_letterPath]];

//    [self positionTrainAtStartPoint];
    
    return self;
}

- (void)positionTrainAtStartPoint {
    NSValue *firstPoint = (NSValue *)[_waypoints objectAtIndex:0];
    [self setPosition:[firstPoint CGPointValue]];
}

@end

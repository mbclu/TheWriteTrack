//
//  PathSegments.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/26/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "PathSegments.h"

@implementation PathSegments

- (instancetype)init {
    self = [super init];
    [self setSegmentBounds:CGRectMake(CGPointZero.x, CGPointZero.y,
                                      ([UIScreen mainScreen].bounds.size.width * 0.35),
                                      ([UIScreen mainScreen].bounds.size.height * 0.95))];
    _segments = [[NSMutableArray alloc] init];
    [self createLeftSideSegments];
    return self;
}

- (void)createLeftSideSegments {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 0, 0);
    CGPathAddLineToPoint(path, nil, 0, _segmentBounds.size.height * 0.25);
    [_segments addObject:(__bridge id)(path)];
}

@end

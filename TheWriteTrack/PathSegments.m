//
//  PathSegments.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/26/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "PathSegments.h"

const NSUInteger numberOfRows = 4;
const NSUInteger numberOfColumns = 4;
const CGFloat segmentMultiplier = 0.25;
const CGFloat boundingWidthPercentage = 0.35;
const CGFloat boundingHeightPercentage = 0.75;

@implementation PathSegments

- (instancetype)init {
    self = [super init];
    [self setSegmentBounds:CGRectMake(CGPointZero.x, CGPointZero.y,
                                      ([UIScreen mainScreen].bounds.size.width * boundingWidthPercentage),
                                      ([UIScreen mainScreen].bounds.size.height * boundingHeightPercentage))];
    _segments = [[NSMutableArray alloc] init];
    
    [self createColumnSegmentsForRow:0];
    [self createColumnSegmentsForRow:1];
    return self;
}

- (void)createColumnSegmentsForRow:(NSUInteger)row {
    for (NSUInteger i = 0; i < numberOfRows; i++) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, nil, _segmentBounds.size.width * segmentMultiplier * row, _segmentBounds.size.height * segmentMultiplier * i);
        CGPathAddLineToPoint(path, nil, _segmentBounds.size.width * segmentMultiplier * row, _segmentBounds.size.height * segmentMultiplier * (i + 1));
        [_segments addObject:(__bridge id)(path)];
    }
}

- (void)drawAllSegementsInScene:(SKScene *)scene {
    for (NSUInteger i = 0; i < _segments.count; i++) {
        SKShapeNode *segmentNode = [SKShapeNode shapeNodeWithPath:(CGPathRef)[_segments objectAtIndex:i]];
        segmentNode.strokeColor = [SKColor blueColor];
        segmentNode.lineWidth = 20;
        [scene addChild:segmentNode];
    }
}

@end

//
//  PathSegments.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/26/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "PathSegments.h"
#if (DEBUG)
    #import <CocoaLumberjack/CocoaLumberjack.h>
    static const DDLogLevel ddLogLevel = DDLogLevelInfo;
#endif

const NSUInteger segmentsPerDimension = 4;
const CGFloat oneOverTheNumberOfSegments = 1.0 / segmentsPerDimension;
const CGFloat boundingWidthPercentage = 0.35;
const CGFloat boundingHeightPercentage = 0.75;

@implementation PathSegments

- (instancetype)init {
    self = [self initWithRect:CGRectMake(CGPointZero.x, CGPointZero.y,
                              ([UIScreen mainScreen].bounds.size.width * boundingWidthPercentage),
                              ([UIScreen mainScreen].bounds.size.height * boundingHeightPercentage))];
    return self;
}

- (instancetype)initWithRect:(CGRect)rect {
    self = [super init];
    [self setSegmentBounds:rect];
    _segments = [[NSMutableArray alloc] init];
    
    [self addVerticalSegments];
    [self addHorizontalSegments];
    [self addDiagonalSegments];

    return self;
}

- (void)addVerticalSegments {
    for (NSUInteger i = 0; i <= segmentsPerDimension; i++) {
        [self createColumnSegmentsForRow:i];
    }
}

- (void)addHorizontalSegments {
    for (NSUInteger i = 0; i <= segmentsPerDimension; i++) {
        [self createRowSegmentsForColumn:i];
    }
}

- (void)addDiagonalSegments {
    [self createDiagonalSegmentsWithXShift:0.5 yShift:1.0 xOffset:0 yOffset:0];
    [self createDiagonalSegmentsWithXShift:0.5 yShift:-1.0 xOffset:4 yOffset:-4];
    [self createDiagonalSegmentsWithXShift:0.5 yShift:-1.0 xOffset:0 yOffset:-4];
    [self createDiagonalSegmentsWithXShift:0.5 yShift:1.0 xOffset:4 yOffset:0];
    [self createDiagonalSegmentsWithXShift:1.0 yShift:1.0 xOffset:0 yOffset:0];
    [self createDiagonalSegmentsWithXShift:1.0 yShift:-1.0 xOffset:0 yOffset:-4];
}

- (void)createColumnSegmentsForRow:(NSUInteger)row {
    for (NSUInteger i = 0; i < segmentsPerDimension; i++) {
        CGFloat x = _segmentBounds.size.width * oneOverTheNumberOfSegments * row;
        CGFloat yStart = _segmentBounds.size.height * oneOverTheNumberOfSegments * i;
        CGFloat yEnd = _segmentBounds.size.height * oneOverTheNumberOfSegments * (i + 1);
        [self addLineSegmentWithXStart:x YStart:yStart XEnd:x YEnd:yEnd];
    }
}

- (void)createRowSegmentsForColumn:(NSUInteger)column {
    for (NSUInteger i = 0; i < segmentsPerDimension; i++) {
        CGFloat xStart = _segmentBounds.size.width * oneOverTheNumberOfSegments * i;
        CGFloat xEnd = _segmentBounds.size.width * oneOverTheNumberOfSegments * (i + 1);
        CGFloat y = _segmentBounds.size.height * oneOverTheNumberOfSegments * column;
        [self addLineSegmentWithXStart:xStart YStart:y XEnd:xEnd YEnd:y];
    }
}

- (void)createDiagonalSegmentsWithXShift:(CGFloat)xShift yShift:(CGFloat)yShift xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset {
    for (NSInteger i = 0; i < segmentsPerDimension; i++) {
        CGFloat xStart = _segmentBounds.size.width * oneOverTheNumberOfSegments * (i + xOffset) * xShift;
        CGFloat yStart = _segmentBounds.size.height * oneOverTheNumberOfSegments * (i + yOffset) * yShift;
        CGFloat xEnd = _segmentBounds.size.width * oneOverTheNumberOfSegments * (1 + i + xOffset) * xShift;
        CGFloat yEnd = _segmentBounds.size.height * oneOverTheNumberOfSegments * (1 + i + yOffset) * yShift;
        [self addLineSegmentWithXStart:xStart YStart:yStart XEnd:xEnd YEnd:yEnd];
    }
}

- (void)addLineSegmentWithXStart:(CGFloat)xStart YStart:(CGFloat)yStart XEnd:(CGFloat)xEnd YEnd:(CGFloat)yEnd {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, xStart, yStart);
    CGPathAddLineToPoint(path, nil, xEnd, yEnd);
    [_segments addObject:(__bridge id)(path)];
    
//#if (DEBUG)
//        DDLogDebug(@"Line Segment:\n\tINDEX = %lu\n\tSTART = <%0.1f, %0.1f>\n\tENDPT = <%0.1f, %0.1f>",
//                   (_segments.count - 1), xStart, yStart, xEnd, yEnd);
//#endif
}

- (void)drawAllSegementsInCenter:(CGPoint)center ofScene:(SKScene *)scene {
#if (DEBUG)
    for (NSUInteger i = 0; i < _segments.count; i++) {
        SKShapeNode *segmentNode = [SKShapeNode shapeNodeWithPath:(CGPathRef)[_segments objectAtIndex:i]];
        segmentNode.strokeColor = [SKColor blueColor];
        segmentNode.lineWidth = 10;
        segmentNode.position = center;
        [scene addChild:segmentNode];
    }
#endif
}

@end

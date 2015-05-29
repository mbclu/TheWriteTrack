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
    #define APP_SHOULD_DRAW_ALL_SEGMENTS    1
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
    
    [self calculateGridDimensions];
    
    [self addVerticalSegments];
    [self addHorizontalSegments];
    [self addDiagonalSegments];
    [self addCurvedSegments];
    
    return self;
}

- (void)calculateGridDimensions {
    _quarterHeight = _segmentBounds.size.height * 0.25;
    _halfHeight = _segmentBounds.size.height * 0.5;
    _threeQuarterHeight = _segmentBounds.size.height * 0.75;
    _fullHeight = _segmentBounds.size.height;
    _quarterWidth = _segmentBounds.size.width * 0.25;
    _halfWidth = _segmentBounds.size.width * 0.5;
    _threeQuarterWidth = _segmentBounds.size.width * 0.75;
    _fullWidth = _segmentBounds.size.width;
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

- (void)addCurvedSegments {
    [self addCurveSegmentsWithXStart:_halfWidth YStart:0 XControl:0 YControl:0 XEnd:0 YEnd:_quarterHeight];
    [self addCurveSegmentsWithXStart:0 YStart:_quarterHeight XControl:0 YControl:_halfHeight XEnd:_halfWidth YEnd:_halfHeight];
    [self addCurveSegmentsWithXStart:_halfWidth YStart:_halfHeight XControl:0 YControl:_halfHeight XEnd:0 YEnd:_threeQuarterHeight];
    [self addCurveSegmentsWithXStart:0 YStart:_threeQuarterHeight XControl:0 YControl:_fullHeight XEnd:_halfWidth YEnd:_fullHeight];
    
    [self addCurveSegmentsWithXStart:_halfWidth YStart:_fullHeight XControl:_fullWidth YControl:_fullHeight XEnd:_fullWidth YEnd:_threeQuarterHeight];
    [self addCurveSegmentsWithXStart:_fullWidth YStart:_threeQuarterHeight XControl:_fullWidth YControl:_halfHeight XEnd:_halfWidth YEnd:_halfHeight];
    [self addCurveSegmentsWithXStart:_halfWidth YStart:_halfHeight XControl:_fullWidth YControl:_halfHeight XEnd:_fullWidth YEnd:_quarterHeight];
    [self addCurveSegmentsWithXStart:_fullWidth YStart:_quarterHeight XControl:_fullWidth YControl:0 XEnd:_halfWidth YEnd:0];
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

- (void)addCurveSegmentsWithXStart:(CGFloat)xStart YStart:(CGFloat)yStart
                          XControl:(CGFloat)xControl YControl:(CGFloat)yControl
                              XEnd:(CGFloat)xEnd YEnd:(CGFloat)yEnd {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, xStart, yStart);
    CGPathAddQuadCurveToPoint(path, nil, xControl, yControl, xEnd, yEnd);
    [_segments addObject:(__bridge id)(path)];
}

- (void)drawAllSegementsInCenter:(CGPoint)center ofScene:(SKScene *)scene {
#if (APP_SHOULD_DRAW_ALL_SEGMENTS)
    for (NSUInteger i = 0; i < _segments.count; i++) {
        CGPathRef path = (__bridge CGPathRef)[_segments objectAtIndex:i];
        SKShapeNode *segmentNode = [SKShapeNode shapeNodeWithPath:path];
        segmentNode.strokeColor = [SKColor whiteColor];
        segmentNode.lineWidth = 10;
        segmentNode.position = center;
        
        SKLabelNode *labelNode = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%lu", (unsigned long)i]];
        labelNode.fontSize = 20;
        labelNode.fontColor  = [SKColor blackColor];
        CGRect pathBounds = CGPathGetBoundingBox(path);
        CGPoint labelNodePosition = CGPointMake(pathBounds.origin.x + pathBounds.size.width * 0.5,
                                                pathBounds.origin.y + pathBounds.size.height * 0.5);
        labelNode.position = labelNodePosition;
        labelNode.zPosition = 200;
        [segmentNode addChild:labelNode];
        
        [scene addChild:segmentNode];
    }
#endif
}

@end

//
//  PathSegments.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/26/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "PathSegments.h"


#import "PathSegmentsIndeces.h"
#if (DEBUG)
    #import "PathDots.h"
    #import "PathInfo.h"
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

static inline float degreesToRadians(double degrees) { return degrees * M_PI / 180; }

- (void)addCrossbarWithSlope:(CGFloat)slope andPosition:(CGPoint)position toCenter:(CGPoint)center ofScene:(SKScene *)scene {
    CGFloat angleInRadians = atanf(slope);
    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(angleInRadians + degreesToRadians(90));
    CGAffineTransform moveTransform = CGAffineTransformMakeTranslation(position.x + center.x, position.y + center.y);

    CGMutablePathRef crossbar = CGPathCreateMutable();
    CGPathMoveToPoint(crossbar, nil, -20, 0);
    CGPathAddLineToPoint(crossbar, nil, 20, 0);
    
    CGAffineTransform zeroTransform = CGAffineTransformMakeTranslation(0, 0);
    crossbar = CGPathCreateMutableCopyByTransformingPath(crossbar, &zeroTransform);
    crossbar = CGPathCreateMutableCopyByTransformingPath(crossbar, &rotationTransform);
    crossbar = CGPathCreateMutableCopyByTransformingPath(crossbar, &moveTransform);
    
    SKShapeNode *crossbarNode = [SKShapeNode shapeNodeWithPath:crossbar];
    crossbarNode.lineWidth = 8;
    crossbarNode.strokeColor = [SKColor brownColor];
    crossbarNode.zPosition = 10;
    
    [scene addChild:crossbarNode];
}

- (void)addAllCrossbarsForPath:(CGPathRef)path toCenter:(CGPoint)center ofScene:(SKScene *)scene {
    PathInfo *pathInfo = [[PathInfo alloc] init];
    NSArray *pathArray = [pathInfo TransformPathToArray:path];
    
    for (NSUInteger j = 1; j < pathArray.count; j++) {
        CGPoint end = [[pathArray objectAtIndex:j] CGPointValue];
        CGPoint start = [[pathArray objectAtIndex:j - 1] CGPointValue];
        CGFloat yChange = (end.y - start.y);
        CGFloat xChange = (end.x - start.x);
        CGFloat slope = yChange / xChange;
        for (NSInteger k = 0; k < 5; k++) {
            if (!isnan(slope) && !isinf(slope)) {
                CGFloat xNew = (start.x + (xChange * k / 5));
                CGFloat yNew = (start.y + (yChange * k / 5));
                [self addCrossbarWithSlope:slope andPosition:CGPointMake(xNew, yNew) toCenter:center ofScene:scene];
            }
        }
        [self addCrossbarWithSlope:slope andPosition:end toCenter:center ofScene:scene];
    }
}

- (void)drawAllSegementsInCenter:(CGPoint)center ofScene:(SKScene *)scene {
#if (APP_SHOULD_DRAW_ALL_SEGMENTS)
    NSArray *letterKeys = [NSArray arrayWithObjects:@"A", nil];
    NSMutableArray *letterValues = [[NSMutableArray alloc] init];
    NSArray *A_Values = [NSArray arrayWithObjects:a43, a42, a41, a44, a45, a46, h29, h30, nil];
    NSArray *B_Values = [NSArray arrayWithObjects:v7, v6, v5, v4, h37, c68, c69, h29, c70, c71, h21, nil];
    
    [letterValues addObject:A_Values];
    [letterValues addObject:B_Values];
//    NSDictionary *letterDictionary = [NSDictionary dictionaryWithObjects:letterValues forKeys:letterKeys];
    
    CGMutablePathRef combinedPath = CGPathCreateMutable();
    
    for (NSUInteger i = 0; i < A_Values.count; i++) {
        NSInteger segmentIndex = [[A_Values objectAtIndex:i] integerValue];
        CGPathRef path = (__bridge CGPathRef)[_segments objectAtIndex:segmentIndex];

        [self addAllCrossbarsForPath:path toCenter:center ofScene:scene];
        
        CGPathAddPath(combinedPath, nil, path);
    }
    
    CGAffineTransform centerTranslateTransform = CGAffineTransformMakeTranslation(center.x, center.y);

    SKShapeNode *outlineNode = [SKShapeNode shapeNodeWithPath:CGPathCreateCopyByStrokingPath(combinedPath, &centerTranslateTransform, 25.0, kCGLineCapButt, kCGLineJoinRound, 1.0)];
    outlineNode.lineWidth = 10.0;
    outlineNode.strokeColor = [SKColor darkGrayColor];
    
    SKShapeNode *segmentNode = [SKShapeNode shapeNodeWithPath:CGPathCreateCopyByStrokingPath(combinedPath, &centerTranslateTransform, 1.0, kCGLineCapRound, kCGLineJoinRound, 1.0)];
    segmentNode.strokeColor = [SKColor lightGrayColor];
    segmentNode.lineWidth = 20.0;

    [scene addChild:outlineNode];
    [scene addChild:segmentNode];
#endif
}

@end

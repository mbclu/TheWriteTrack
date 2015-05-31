//
//  PathSegments.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/26/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "PathSegments.h"

#if (DEBUG)
    #import "PathDots.h"
    #import "PathInfo.h"
    #import <CocoaLumberjack/CocoaLumberjack.h>
    #define APP_SHOULD_DRAW_ALL_SEGMENTS    0
#endif

const NSUInteger segmentsPerDimension = 4;
const NSUInteger numberOfCurvedSegments = 12;
const NSUInteger numberOfValuesDefiningQuadCurve = 6;
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
    CGFloat curvePoints[numberOfCurvedSegments][numberOfValuesDefiningQuadCurve];
    [self getCurveDefintions:curvePoints];
    for (NSUInteger i = 0; i < numberOfCurvedSegments; i++) {
        [self addCurveSegmentsWithXStart:curvePoints[i][0] YStart:curvePoints[i][1]
                                XControl:curvePoints[i][2] YControl:curvePoints[i][3]
                                    XEnd:curvePoints[i][4] YEnd:curvePoints[i][5]];
    }
}

- (void)getCurveDefintions:(CGFloat[numberOfCurvedSegments][numberOfValuesDefiningQuadCurve])points {
    CGFloat curvePoints[numberOfCurvedSegments][numberOfValuesDefiningQuadCurve] = {
        //Bottom left bubble:
        { _halfWidth, 0.0, 0.0, 0.0, 0.0, _quarterHeight },
        { 0, _quarterHeight, 0, _halfHeight, _halfWidth, _halfHeight },
        
        //Top left bubble:
        { _halfWidth, _halfHeight, 0, _halfHeight, 0, _threeQuarterHeight },
        { 0, _threeQuarterHeight, 0, _fullHeight, _halfWidth, _fullHeight },
        
        //Top right bubble:
        { _halfWidth, _fullHeight, _fullWidth, _fullHeight, _fullWidth, _threeQuarterHeight },
        { _fullWidth, _threeQuarterHeight, _fullWidth, _halfHeight, _halfWidth, _halfHeight },
        
        //Bottom right bubble:
        { _halfWidth, _halfHeight, _fullWidth, _halfHeight, _fullWidth, _quarterHeight },
        { _fullWidth, _quarterHeight, _fullWidth, 0, _halfWidth, 0 },
        
        //Top left quadrant:
        { _halfWidth, _fullHeight, 0, _fullHeight, 0, _halfHeight },
        
        //Bottom left quadrant:
        { 0, _halfHeight, 0, 0, _halfWidth, 0 },
        
        //Bottom right quadrant:
        { _halfWidth, 0, _fullWidth, 0, _fullWidth, _halfHeight },
        
        //Top right quadrant:
        { _fullWidth, _halfHeight, _fullWidth, _fullHeight, _halfWidth, _fullHeight }
    };
    
    for (NSUInteger i = 0; i < numberOfCurvedSegments; i++) {
        for (NSUInteger j = 0; j < numberOfValuesDefiningQuadCurve; j++) {
            points[i][j] = curvePoints[i][j];
        }
    }
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


/*** Unfortunately, NOT much testing after this point ***/

static inline float degreesToRadians(double degrees) { return degrees * M_PI / 180; }

- (void)addCrossbarWithSlope:(CGFloat)slope andPosition:(CGPoint)position toCenter:(CGPoint)center ofScene:(SKScene *)scene {
    CGFloat angleInRadians = atanf(slope);
    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(angleInRadians + degreesToRadians(90));
    CGAffineTransform zeroTransform = CGAffineTransformMakeTranslation(0, 0);
    CGAffineTransform moveTransform = CGAffineTransformMakeTranslation(position.x + center.x, position.y + center.y);

    CGMutablePathRef crossbar = CGPathCreateMutable();
    CGPathMoveToPoint(crossbar, nil, -20, 0);
    CGPathAddLineToPoint(crossbar, nil, 20, 0);
    
    crossbar = CGPathCreateMutableCopyByTransformingPath(crossbar, &zeroTransform);
    crossbar = CGPathCreateMutableCopyByTransformingPath(crossbar, &rotationTransform);
    crossbar = CGPathCreateMutableCopyByTransformingPath(crossbar, &moveTransform);
    
    SKShapeNode *crossbarNode = [SKShapeNode shapeNodeWithPath:crossbar];
    crossbarNode.lineWidth = 8;
    crossbarNode.strokeColor = [SKColor brownColor];
    crossbarNode.zPosition = 10;
    
    [scene addChild:crossbarNode];
}

- (void)addCrossbarsForStraightPath:(CGPathRef)path toCenter:(CGPoint)center ofScene:(SKScene *)scene {
    PathInfo *pathInfo = [[PathInfo alloc] init];
    NSArray *pathArray = [pathInfo TransformPathToArray:path];
    
    for (NSUInteger j = 1; j < pathArray.count; j++) {
        CGPoint start = [[pathArray objectAtIndex:j - 1] CGPointValue];
        CGPoint end = [[pathArray objectAtIndex:j] CGPointValue];
        CGFloat yChange = (end.y - start.y);
        CGFloat xChange = (end.x - start.x);
        CGFloat slope = yChange / xChange;
        for (CGFloat t = 0.0; t <= 1.0; t += 0.25) {
            CGFloat xNew = start.x;
            CGFloat yNew = start.y;
            if (isinf(slope)) {
                yNew += (yChange * (1.0 - t));
            }
            else if (!isnan(slope)) {
                xNew += (xChange * (1.0 - t));
                yNew += (yChange * (1.0 - t));
            }
            [self addCrossbarWithSlope:slope andPosition:CGPointMake(xNew, yNew) toCenter:center ofScene:scene];
        }
//        [self addCrossbarWithSlope:slope andPosition:end toCenter:center ofScene:scene];
    }
}

float interpolateQuadBezier(const CGFloat step, const CGFloat start, const CGFloat control, const CGFloat end)
{
    const CGFloat percent = (1.0 - step);
    const CGFloat percentSquared = percent * percent;
    const CGFloat stepSquared = step * step;
    
    return start * percentSquared
            + 2.0 *  control * percent * step
            + end * stepSquared;
}

float tangentQuadBezier(const CGFloat step, const CGFloat start, const CGFloat control, const CGFloat end)
{
    const CGFloat percent = (1.0 - step);
    
    return 2.0 * percent * (control - start)
    + 2.0 * step * (end - control);
}


- (void)addCrossbarsForCurve:(NSUInteger)curveIndex atCenter:(CGPoint)center ofScene:(SKScene *)scene {
    CGFloat curvePoints[numberOfCurvedSegments][numberOfValuesDefiningQuadCurve];
    [self getCurveDefintions:curvePoints];
    for (CGFloat t = 0.05; t <= 1.0; t += 0.1) {
        CGPoint interpolationPoint = CGPointMake(interpolateQuadBezier(t, curvePoints[curveIndex][0], curvePoints[curveIndex][2], curvePoints[curveIndex][4]) + center.x,
                                                 interpolateQuadBezier(t, curvePoints[curveIndex][1], curvePoints[curveIndex][3], curvePoints[curveIndex][5]) + center.y);
        
        CGPoint tangent = CGPointMake(tangentQuadBezier(t, curvePoints[curveIndex][0], curvePoints[curveIndex][2], curvePoints[curveIndex][4]),
                                      tangentQuadBezier(t, curvePoints[curveIndex][1], curvePoints[curveIndex][3], curvePoints[curveIndex][5]));
        
        float y2 = interpolationPoint.y + tangent.y;
        float y1 = interpolationPoint.y;
        float x2 = interpolationPoint.x + tangent.x;
        float x1 = interpolationPoint.x;
        
        CGFloat slope = (y2 - y1) / (x2 - x1);
        
        [self addCrossbarWithSlope:(slope) andPosition:CGPointMake(interpolationPoint.x, interpolationPoint.y) toCenter:CGPointZero ofScene:scene];
    }
}

- (void)drawAllSegementsInCenter:(CGPoint)center ofScene:(SKScene *)scene {
#if (APP_SHOULD_DRAW_ALL_SEGMENTS)
    const NSArray *letterKeys = [NSArray arrayWithObjects:@"A", nil];
    NSMutableArray *letterValues = [[NSMutableArray alloc] init];
    
    [letterValues addObject:A_Values];
    [letterValues addObject:B_Values];
    [letterValues addObject:C_Values];
    
    CGMutablePathRef combinedPath = CGPathCreateMutable();
    
    for (NSUInteger i = 0; i < C_Values.count; i++) {
        NSInteger segmentIndex = [[C_Values objectAtIndex:i] integerValue];
        CGPathRef path = (__bridge CGPathRef)[_segments objectAtIndex:segmentIndex];

        if (segmentIndex < [c64 integerValue]) {
            [self addCrossbarsForStraightPath:path toCenter:center ofScene:scene];
        }
        else {
            [self addCrossbarsForCurve:(segmentIndex - [c64 integerValue]) atCenter:center ofScene:scene];
        }
        
        CGPathAddPath(combinedPath, nil, path);
    }
    
    CGAffineTransform centerTranslateTransform = CGAffineTransformMakeTranslation(center.x, center.y);

    SKShapeNode *outlineNode = [SKShapeNode shapeNodeWithPath:CGPathCreateCopyByStrokingPath(combinedPath, &centerTranslateTransform, 25.0, kCGLineCapRound, kCGLineJoinRound, 1.0)];
    outlineNode.lineWidth = 10.0;
    outlineNode.strokeColor = [SKColor darkGrayColor];
    
    SKShapeNode *segmentNode = [SKShapeNode shapeNodeWithPath:CGPathCreateCopyByStrokingPath(combinedPath, &centerTranslateTransform, 1.0, kCGLineCapRound, kCGLineJoinRound, 1.0)];
    segmentNode.strokeColor = [SKColor lightGrayColor];
    segmentNode.lineWidth = 20.0;

    [scene addChild:outlineNode];
//    [scene addChild:segmentNode];
#endif
}

@end

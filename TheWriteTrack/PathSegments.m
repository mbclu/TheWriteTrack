//
//  PathSegments.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/26/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "PathSegments.h"

#import "LayoutMath.h"
#import "LetterPathSegmentDictionary.h"

#if (DEBUG)
    #import "PathDots.h"
    #import "PathInfo.h"
    #import <CocoaLumberjack/CocoaLumberjack.h>
#endif

const NSUInteger segmentsPerDimension = 4;
const NSUInteger numberOfCurvedSegments = 12;
const NSUInteger numberOfValuesDefiningQuadCurve = 6;
const CGFloat oneOverTheNumberOfSegments = 1.0 / segmentsPerDimension;
const CGFloat boundingWidthPercentage = 0.35;
const CGFloat boundingHeightPercentage = 0.75;

static inline CGFloat degreesToRadians(CGFloat degrees) { return degrees * M_PI / 180; }

@implementation PathSegments

- (instancetype)init {
    self = [self initWithRect:CGRectMake(CGPointZero.x, CGPointZero.y,
                              ([UIScreen mainScreen].bounds.size.width * boundingWidthPercentage),
                              ([UIScreen mainScreen].bounds.size.height * boundingHeightPercentage))];
    _letterSegmentDictionary = [LetterPathSegmentDictionary dictionaryWithUpperCasePathSegments];
    _center = CGPointZero;
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
        [self addQuadCurveDefinitionWithP1:CGPointMake(curvePoints[i][0], curvePoints[i][1])
                              ControlPoint:CGPointMake(curvePoints[i][2], curvePoints[i][3])
                                        P2:CGPointMake(curvePoints[i][4], curvePoints[i][5])];
    }
}

- (void)getCurveDefintions:(CGFloat[numberOfCurvedSegments][numberOfValuesDefiningQuadCurve])points {
    CGFloat curvePoints[numberOfCurvedSegments][numberOfValuesDefiningQuadCurve] = {
        //Bottom left bubble:
        { _halfWidth, 0, 0, 0, 0, _quarterHeight },
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
        [self addLineDefinitionWithPointsP1:CGPointMake(x, yStart) P2:CGPointMake(x, yEnd)];
    }
}

- (void)createRowSegmentsForColumn:(NSUInteger)column {
    for (NSUInteger i = 0; i < segmentsPerDimension; i++) {
        CGFloat xStart = _segmentBounds.size.width * oneOverTheNumberOfSegments * i;
        CGFloat xEnd = _segmentBounds.size.width * oneOverTheNumberOfSegments * (i + 1);
        CGFloat y = _segmentBounds.size.height * oneOverTheNumberOfSegments * column;
        [self addLineDefinitionWithPointsP1:CGPointMake(xStart, y) P2:CGPointMake(xEnd, y)];
    }
}

- (void)createDiagonalSegmentsWithXShift:(CGFloat)xShift yShift:(CGFloat)yShift xOffset:(NSInteger)xOffset yOffset:(NSInteger)yOffset {
    for (NSInteger i = 0; i < segmentsPerDimension; i++) {
        CGFloat xStart = _segmentBounds.size.width * oneOverTheNumberOfSegments * (i + xOffset) * xShift;
        CGFloat yStart = _segmentBounds.size.height * oneOverTheNumberOfSegments * (i + yOffset) * yShift;
        CGFloat xEnd = _segmentBounds.size.width * oneOverTheNumberOfSegments * (1 + i + xOffset) * xShift;
        CGFloat yEnd = _segmentBounds.size.height * oneOverTheNumberOfSegments * (1 + i + yOffset) * yShift;
        [self addLineDefinitionWithPointsP1:CGPointMake(xStart, yStart) P2:CGPointMake(xEnd, yEnd)];
    }
}

- (void)addLineDefinitionWithPointsP1:(CGPoint)point1 P2:(CGPoint)point2 {
    [_segments addObject:
     [NSArray arrayWithObjects:
      [NSValue valueWithCGPoint:point1],
      [NSValue valueWithCGPoint:point2],
      nil]];
}

- (void)addQuadCurveDefinitionWithP1:(CGPoint)point1 ControlPoint:(CGPoint)control P2:(CGPoint)point2 {
    [_segments addObject:
     [NSArray arrayWithObjects:
      [NSValue valueWithCGPoint:point1],
      [NSValue valueWithCGPoint:control],
      [NSValue valueWithCGPoint:point2],
      nil]
     ];
}

/* Unfortunately, NOT much test coverage after this point  *
 * Everything was instead spiked out with trial and error. */

- (CGPathRef)generateCombinedPathForLetter:(NSString *)letter {
    _combinedPath = CGPathCreateMutable();
    CGMutablePathRef subPath = CGPathCreateMutable();
    
    NSArray *letterSegments = [_letterSegmentDictionary objectForKey:letter];
    
    BOOL isSegmentDirectionReversed = NO;
    
    for (NSUInteger i = 0; i < letterSegments.count; i++) {
        NSInteger segmentIndex = [[letterSegments objectAtIndex:i] integerValue];
        
        switch (segmentIndex) {
            case NORMAL_PATH_SEGMENT_DIRECTION:
                isSegmentDirectionReversed = NO;
                break;
            case REVERSE_PATH_SEGMENT_DIRECTION:
                isSegmentDirectionReversed = YES;
                break;
            case PATH_SEGMENT_END:
                CGPathAddPath(_combinedPath, nil, subPath);
                CGPathRelease(subPath);
                subPath = CGPathCreateMutable();
                break;
            default:
            {
                NSArray *points = [_segments objectAtIndex:segmentIndex];
                NSUInteger startIndex = 0;
                NSInteger indexChange = +1;
                
                if (isSegmentDirectionReversed) {
                    startIndex = points.count - 1;
                    indexChange = -1;
                }
                
                if (CGPathIsEmpty(subPath)) {
                    CGPoint start = [[points objectAtIndex:startIndex] CGPointValue];
                    CGPathMoveToPoint(subPath, nil, start.x, start.y);
                }
                
                if (points.count == 2) {
                    CGPoint point = [[points objectAtIndex:startIndex + indexChange] CGPointValue];
                    CGPathAddLineToPoint(subPath, nil, point.x, point.y);
                }
                else {
                    CGPoint controlPoint = [[points objectAtIndex:startIndex + indexChange] CGPointValue];
                    CGPoint endPoint = [[points objectAtIndex:startIndex + (2 * indexChange)] CGPointValue];
                    CGPathAddQuadCurveToPoint(subPath, nil, controlPoint.x, controlPoint.y, endPoint.x, endPoint.y);
                }

                break;
            }
        }
    }
    
    CGPathRelease(subPath);
    return _combinedPath;
}

- (NSArray *)generateCrossbarsForLetter:(NSString *)letter {
    _crossbars = [[NSMutableArray alloc] init];

    NSArray *letterSegments = [_letterSegmentDictionary objectForKey:letter];
    
    for (NSUInteger i = 0; i < letterSegments.count; i++) {
        NSInteger segmentIndex = [[letterSegments objectAtIndex:i] integerValue];
        
        switch (segmentIndex) {
            case NORMAL_PATH_SEGMENT_DIRECTION:
            case REVERSE_PATH_SEGMENT_DIRECTION:
            case PATH_SEGMENT_END:
                break;
            default:
            {
                NSArray *points = [_segments objectAtIndex:segmentIndex];
                if (points.count == 2) {
                    [self createCrossbarsForStraightSegment:points];
                }
                else if (points.count == 3) {
                    [self createCrossbarsForCurveSegment:(segmentIndex - [c64 integerValue])];
                }
                break;
            }
        }
    }
    
    return _crossbars;
}

- (void)createCrossbarsForStraightSegment:(NSArray *)points {
    SEL addCrossbarsSelector = @selector(addCrossbarWithPosition:andSlope:);
    [self interpolateStraightSegmentWithPoints:points usingSelector:addCrossbarsSelector andStepSizeInPercent:0.25];
}

- (void)createCrossbarsForCurveSegment:(NSUInteger)curveIndex {
    SEL addCrossbarsSelector = @selector(addCrossbarWithPosition:andSlope:);
    [self interpolateQuadCurveSegmentWithCurveIndex:curveIndex usingSelector:addCrossbarsSelector andStepSize:0.1];
}

- (void)addCrossbarWithPosition:(CGPoint)position andSlope:(CGFloat)slope {
    CGFloat angleInRadians = degreesToRadians(90);
    if (!isnan(slope)) {
        angleInRadians = atanf(slope);
    }
    
    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(angleInRadians + degreesToRadians(90));
    CGAffineTransform zeroTransform = CGAffineTransformMakeTranslation(0, 0);
    CGAffineTransform moveTransform = CGAffineTransformMakeTranslation(position.x + _center.x, position.y + _center.y);
    
    CGMutablePathRef crossbar = CGPathCreateMutable();
    CGPathMoveToPoint(crossbar, nil, -20, 0);
    CGPathAddLineToPoint(crossbar, nil, 20, 0);
    
    crossbar = CGPathCreateMutableCopyByTransformingPath(crossbar, &zeroTransform);
    crossbar = CGPathCreateMutableCopyByTransformingPath(crossbar, &rotationTransform);
    crossbar = CGPathCreateMutableCopyByTransformingPath(crossbar, &moveTransform);
    
    [_crossbars addObject:(__bridge id)crossbar];
}

- (NSArray *)generateWaypointsForLetter:(NSString *)letter {
    _waypoints = [[NSMutableArray alloc] init];
    
    NSArray *letterSegments = [_letterSegmentDictionary objectForKey:letter];
    
    for (NSUInteger i = 0; i < letterSegments.count; i++) {
        NSInteger segmentIndex = [[letterSegments objectAtIndex:i] integerValue];
        
        switch (segmentIndex) {
            case NORMAL_PATH_SEGMENT_DIRECTION:
            case REVERSE_PATH_SEGMENT_DIRECTION:
            case PATH_SEGMENT_END:
                break;
            default:
            {
                NSArray *points = [_segments objectAtIndex:segmentIndex];
                if (points.count == 2) {
                    [self createWaypointsForStraightSegment:points];
                }
                else if (points.count == 3) {
                    [self createWaypointsForCurveSegment:(segmentIndex - [c64 integerValue])];
                }
                break;
            }
        }
    }
    
    return _waypoints;
}

- (void)createWaypointsForStraightSegment:(NSArray *)points {
    SEL addWaypointsSelector = @selector(addWaypointWithPosition:);
    [self interpolateStraightSegmentWithPoints:points usingSelector:addWaypointsSelector andStepSizeInPercent:0.50];
}

- (void)createWaypointsForCurveSegment:(NSUInteger)curveIndex {
    SEL addWaypointsSelector = @selector(addWaypointWithPosition:);
    [self interpolateQuadCurveSegmentWithCurveIndex:curveIndex usingSelector:addWaypointsSelector andStepSize:0.2];
}

- (void)addWaypointWithPosition:(CGPoint)position {
    [_waypoints addObject:[NSValue valueWithCGPoint:position]];
}

- (NSArray *)getPathArrayFromStraightSegmentPathWithPoints:(NSArray *)points {
    return [[[PathInfo alloc] init] TransformPathToArray:[self getPathFromSegementWithPoints:points]];
}

- (CGPathRef)getPathFromSegementWithPoints:(NSArray *)points {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, [points[0] CGPointValue].x, [points[0] CGPointValue].y);
    if (points.count == 2) {
        CGPathAddLineToPoint(path, nil,
                             [points[1] CGPointValue].x, [points[1] CGPointValue].y);
    }
    else if (points.count == 3) {
        CGPathAddQuadCurveToPoint(path, nil,
                                  [points[1] CGPointValue].x, [points[1] CGPointValue].y,
                                  [points[2] CGPointValue].x, [points[2] CGPointValue].y);
    }
    return path;
}

- (void)interpolateStraightSegmentWithPoints:(NSArray *)points usingSelector:(SEL)selector andStepSizeInPercent:(CGFloat)stepSize {
    NSArray *pathArray = [self getPathArrayFromStraightSegmentPathWithPoints:points];
    
    for (NSUInteger i = 1; i < pathArray.count; i++) {
        CGPoint start = [[pathArray objectAtIndex:i - 1] CGPointValue];
        CGPoint end = [[pathArray objectAtIndex:i] CGPointValue];
        for (CGFloat t = 0.0; t <= 1.0; t += stepSize) {
            CGPoint interpolationPoint = CGPointMake([LayoutMath interpolateLineWithStep:t start:start.x end:end.x],
                                                     [LayoutMath interpolateLineWithStep:t start:start.y end:end.y]);
            NSNumber *slope = [NSNumber numberWithFloat:[LayoutMath slopeOfLineWithStartPoint:start endPoint:end]];
            [self performSelector:selector withObject:(__bridge id)(&interpolationPoint) withObject:slope];
        }
    }
}

- (void)interpolateQuadCurveSegmentWithCurveIndex:(NSUInteger)curveIndex usingSelector:(SEL)selector andStepSize:(CGFloat)stepSize {
    CGFloat curvePoints[numberOfCurvedSegments][numberOfValuesDefiningQuadCurve];
    [self getCurveDefintions:curvePoints];
    
    for (CGFloat t = 0.05; t <= 1.0; t += stepSize) {
        CGPoint interpolationPoint = CGPointMake([LayoutMath interpolateQuadBezierAtStep:t
                                                                                   start:curvePoints[curveIndex][0]
                                                                                 control:curvePoints[curveIndex][2]
                                                                                     end:curvePoints[curveIndex][4]] + _center.x,
                                                 [LayoutMath interpolateQuadBezierAtStep:t
                                                                                   start:curvePoints[curveIndex][1]
                                                                                 control:curvePoints[curveIndex][3]
                                                                                     end:curvePoints[curveIndex][5]] + _center.y);
        
        CGPoint tangent = CGPointMake([LayoutMath tangentQuadBezierAtStep:t
                                                                    start:curvePoints[curveIndex][0]
                                                                  control:curvePoints[curveIndex][2]
                                                                      end:curvePoints[curveIndex][4]],
                                      [LayoutMath tangentQuadBezierAtStep:t
                                                                    start:curvePoints[curveIndex][1]
                                                                  control:curvePoints[curveIndex][3]
                                                                      end:curvePoints[curveIndex][5]]);
        
        float y2 = interpolationPoint.y + tangent.y;
        float y1 = interpolationPoint.y;
        float x2 = interpolationPoint.x + tangent.x;
        float x1 = interpolationPoint.x;
        
        CGFloat slopeValue = (y2 - y1) / (x2 - x1);
        NSNumber *slope = [NSNumber numberWithFloat:slopeValue];
        
        [self performSelector:selector withObject:(__bridge id)(&interpolationPoint) withObject:slope];
    }
}

@end

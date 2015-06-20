//
//  PathSegments.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/26/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "PathSegments.h"

#import "LayoutMath.h"
#import "PathSegmentDictionary.h"

#if (DEBUG)
    #import "PathInfo.h"
    #import <CocoaLumberjack/CocoaLumberjack.h>
#endif

const NSUInteger segmentsPerDimension = 4;
const NSUInteger numberOfCurvedSegments = 14;
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
    _letterSegmentDictionary = [PathSegmentDictionary dictionaryWithUpperCasePathSegments];
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
        { _fullWidth, _halfHeight, _fullWidth, _fullHeight, _halfWidth, _fullHeight },

        // J Segments
        { _halfWidth, _quarterHeight, _halfWidth, 0, _quarterWidth, 0 },
        { _quarterWidth, 0, 0, 0, 0, _quarterHeight }
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

- (void)generateCombinedPathAndWaypointsForLetter:(const NSString *)letter {
    NSArray *letterSegments = [_letterSegmentDictionary objectForKey:letter];

    CGMutablePathRef subPath;
    NSMutableArray *subArray;
    [self initializePath:&subPath andWaypointsArray:&subArray];
    
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
                [self finalizeSubpath:&subPath andWaypointsArray:&subArray];
                break;
            default:
                [self updateSubpath:&subPath andWaypointsArray:&subArray
                           forIndex:segmentIndex reversedDirection:isSegmentDirectionReversed];
                break;
        }
    }

    CGPathRelease(subPath);
}

- (void)initializePath:(CGMutablePathRef *)subPath andWaypointsArray:(NSMutableArray **)subArray {
    _generatedSegmentPath = CGPathCreateMutable();
    _generatedWaypointArrays = [[NSMutableArray alloc] init];
    *subPath = CGPathCreateMutable();
    *subArray = [[NSMutableArray alloc] init];
}

- (void)finalizeSubpath:(CGMutablePathRef *)subPath andWaypointsArray:(NSMutableArray **)subArray {
    CGPathAddPath(_generatedSegmentPath, nil, *subPath);
    CGPathRelease(*subPath);
    *subPath = CGPathCreateMutable();
    
    [_generatedWaypointArrays addObject:*subArray];
    *subArray = [[NSMutableArray alloc] init];
}

- (void)updateSubpath:(CGMutablePathRef *)subPath andWaypointsArray:(NSMutableArray **)subArray
             forIndex:(NSInteger)segmentIndex reversedDirection:(BOOL)isSegmentDirectionReversed {
    NSArray *points = [_segments objectAtIndex:segmentIndex];
    NSMutableArray *directionalPoints = [[NSMutableArray alloc] initWithArray:points];
    
    if (isSegmentDirectionReversed) {
        [directionalPoints removeAllObjects];
        NSEnumerator *enumerator = [points reverseObjectEnumerator];
        for (id point in enumerator) {
            [directionalPoints addObject:point];
        }
    }
    
    if (CGPathIsEmpty(*subPath)) {
        CGPoint start = [[directionalPoints objectAtIndex:0] CGPointValue];
        CGPathMoveToPoint(*subPath, nil, start.x, start.y);
    }
    
    if (directionalPoints.count == 2) {
        CGPoint point = [[directionalPoints objectAtIndex:1] CGPointValue];
        CGPathAddLineToPoint(*subPath, nil, point.x, point.y);
        [self interpolateStraightSegmentWithPoints:directionalPoints
                              andStepSizeInPercent:1.0
                                   intoObjectArray:*subArray
                                     forObjectType:WaypointObjectType];
    }
    else {
        CGPoint controlPoint = [[directionalPoints objectAtIndex:1] CGPointValue];
        CGPoint endPoint = [[directionalPoints objectAtIndex:2] CGPointValue];
        CGPathAddQuadCurveToPoint(*subPath, nil, controlPoint.x, controlPoint.y, endPoint.x, endPoint.y);
        [self interpolateQuadCurveSegmentWithCurveIndex:directionalPoints
                                   andStepSizeInPercent:0.5
                                        intoObjectArray:*subArray
                                          forObjectType:WaypointObjectType];
    }
}

- (NSMutableArray *)generateObjectsWithType:(enum EInterpolatableObjectTypes)objectType forLetter:(NSString *)letter {
    NSMutableArray *generatedObjects = [[NSMutableArray alloc] init];
    NSArray *letterSegments = [_letterSegmentDictionary objectForKey:letter];
    CGFloat straightStepSize = (objectType == CrossbarObjectType) ? 0.25 : 1.0;
    CGFloat curveStepSize = (objectType == CrossbarObjectType) ? 0.1 : 0.5;
    
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
                    [self interpolateStraightSegmentWithPoints:points
                                          andStepSizeInPercent:straightStepSize
                                               intoObjectArray:generatedObjects
                                                 forObjectType:objectType];
                }
                else if (points.count == 3) {
                    [self interpolateQuadCurveSegmentWithCurveIndex:points
                                               andStepSizeInPercent:curveStepSize
                                                    intoObjectArray:generatedObjects
                                                      forObjectType:objectType];
                }
                break;
            }
        }
    }
    
    return generatedObjects;
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


- (NSArray *)getPathArrayFromStraightSegmentPathWithPoints:(NSArray *)points {
    return [[[PathInfo alloc] init] TransformPathToArray:[self getPathFromSegementWithPoints:points]];
}

- (void)interpolateStraightSegmentWithPoints:(NSArray *)points andStepSizeInPercent:(CGFloat)stepSize
                             intoObjectArray:(NSMutableArray *)generatedObjects forObjectType:(enum EInterpolatableObjectTypes)objectType {
    NSArray *pathArray = [self getPathArrayFromStraightSegmentPathWithPoints:points];
    
    for (NSUInteger i = 1; i < pathArray.count; i++) {
        CGPoint start = [[pathArray objectAtIndex:i - 1] CGPointValue];
        CGPoint end = [[pathArray objectAtIndex:i] CGPointValue];
        for (CGFloat t = 1.0; t >= 0.0; t -= stepSize) {
            CGPoint interpolationPoint = CGPointMake([LayoutMath interpolateLineWithStep:t start:start.x end:end.x],
                                                     [LayoutMath interpolateLineWithStep:t start:start.y end:end.y]);
            switch (objectType) {
                case CrossbarObjectType:
                    [self addCrossbarWithPosition:interpolationPoint
                                         andSlope:[LayoutMath slopeOfLineWithStartPoint:start endPoint:end]
                                          toArray:generatedObjects];
                    break;
                case WaypointObjectType:
                    [self addWaypointWithPosition:interpolationPoint
                                          toArray:generatedObjects];
                    break;
            }
        }
    }
}

- (void)interpolateQuadCurveSegmentWithCurveIndex:(NSArray *)points andStepSizeInPercent:(CGFloat)stepSize
                                  intoObjectArray:(NSMutableArray *)generatedObjects forObjectType:(enum EInterpolatableObjectTypes)objectType {
    for (CGFloat t = 0.0; t <= 1.0; t += stepSize) {
        CGPoint interpolationPoint = CGPointMake([LayoutMath interpolateQuadBezierAtStep:t
                                                                                   start:[points[0] CGPointValue].x
                                                                                 control:[points[1] CGPointValue].x
                                                                                     end:[points[2] CGPointValue].x],
                                                 [LayoutMath interpolateQuadBezierAtStep:t
                                                                                   start:[points[0] CGPointValue].y
                                                                                 control:[points[1] CGPointValue].y
                                                                                     end:[points[2] CGPointValue].y]);
        
        CGPoint tangent = CGPointMake([LayoutMath tangentQuadBezierAtStep:t
                                                                    start:[points[0] CGPointValue].x
                                                                  control:[points[1] CGPointValue].x
                                                                      end:[points[2] CGPointValue].x],
                                      [LayoutMath tangentQuadBezierAtStep:t
                                                                    start:[points[0] CGPointValue].y
                                                                  control:[points[1] CGPointValue].y
                                                                      end:[points[2] CGPointValue].y]);
        
        float y2 = interpolationPoint.y + tangent.y;
        float y1 = interpolationPoint.y;
        float x2 = interpolationPoint.x + tangent.x;
        float x1 = interpolationPoint.x;
        
        CGFloat slope = (y2 - y1) / (x2 - x1);
        
        switch (objectType) {
            case CrossbarObjectType:
                [self addCrossbarWithPosition:interpolationPoint andSlope:slope toArray:generatedObjects];
                break;
            case WaypointObjectType:
                [self addWaypointWithPosition:interpolationPoint toArray:generatedObjects];
                break;
        }
    }
}

- (void)addCrossbarWithPosition:(CGPoint)position andSlope:(CGFloat)slope toArray:(NSMutableArray *)generatedObject {
    CGFloat angleInRadians = degreesToRadians(90);
    if (!isnan(slope)) {
        angleInRadians = atanf(slope);
    }
    
    CGAffineTransform zeroTransform = CGAffineTransformMakeTranslation(0, 0);
    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(angleInRadians + degreesToRadians(90));
    CGAffineTransform moveTransform = CGAffineTransformMakeTranslation(position.x, position.y);
    
    CGMutablePathRef crossbar = CGPathCreateMutable();
    CGPathMoveToPoint(crossbar, nil, -20, 0);
    CGPathAddLineToPoint(crossbar, nil, 20, 0);
    
    crossbar = CGPathCreateMutableCopyByTransformingPath(crossbar, &zeroTransform);
    crossbar = CGPathCreateMutableCopyByTransformingPath(crossbar, &rotationTransform);
    crossbar = CGPathCreateMutableCopyByTransformingPath(crossbar, &moveTransform);
    
    [generatedObject addObject:(__bridge id)crossbar];
}

- (void)addWaypointWithPosition:(CGPoint)position toArray:(NSMutableArray *)generatedObjects {
    NSUInteger foundPositionIndex = [generatedObjects
                                     indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                                         return CGPointEqualToPoint([obj CGPointValue], position);
                                     }];
    if (foundPositionIndex == NSNotFound) {
        [generatedObjects addObject:[NSValue valueWithCGPoint:position]];
    }
}

@end

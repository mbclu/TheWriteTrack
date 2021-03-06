//
//  PathSegments.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/26/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

NS_ENUM(NSUInteger, EInterpolatableObjectTypes) {
    CrossbarObjectType,
    WaypointObjectType
};

@interface PathSegments : NSObject

@property CGRect segmentBounds;
@property NSMutableArray *segments;
@property CGFloat quarterHeight;
@property CGFloat halfHeight;
@property CGFloat threeQuarterHeight;
@property CGFloat fullHeight;
@property CGFloat quarterWidth;
@property CGFloat halfWidth;
@property CGFloat threeQuarterWidth;
@property CGFloat fullWidth;
@property CGMutablePathRef generatedSegmentPath;
@property NSMutableArray *generatedWaypointArrays;
@property NSDictionary *letterSegmentDictionary;

- (instancetype)initWithRect:(CGRect)rect;
- (void)calculateGridDimensions;
- (void)createRowSegmentsForColumn:(NSUInteger)column;
- (void)createColumnSegmentsForRow:(NSUInteger)row;
- (void)addQuadCurveDefinitionWithP1:(CGPoint)point1 ControlPoint:(CGPoint)control P2:(CGPoint)point2;
- (void)generateCombinedPathAndWaypointsForLetter:(const NSString *)letter;
- (NSMutableArray *)generateObjectsWithType:(enum EInterpolatableObjectTypes)objectType forLetter:(const NSString *)letter;

@end

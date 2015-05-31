//
//  PathSegments.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/26/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PathSegments : NSObject {
}

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
@property CGMutablePathRef combinedPath;
@property NSMutableArray *crossbars;

- (instancetype)initWithRect:(CGRect)rect;

- (void)calculateGridDimensions;

- (void)createRowSegmentsForColumn:(NSUInteger)column;

- (void)createColumnSegmentsForRow:(NSUInteger)row;

- (void)addCurveSegmentsWithXStart:(CGFloat)xStart YStart:(CGFloat)yStart
                          XControl:(CGFloat)xControl YControl:(CGFloat)yControl
                              XEnd:(CGFloat)xEnd YEnd:(CGFloat)yEnd;

- (void)generateCombinedPathAndCrossbarsForLetter:(NSString *)letter atCenter:(CGPoint)center;

@end

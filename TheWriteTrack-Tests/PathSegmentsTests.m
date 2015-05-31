//
//  PathSegmentsTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/26/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "PathSegments.h"

#import "CGMatchers.h"
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

const CGFloat oneOverTheNumberOfSegments = 0.25;
const NSUInteger numberOfVerticleSegments = 20;
const NSUInteger numberOfHorizontalSegments = 20;
const NSUInteger numberOfAFrameSegments = 8;
const NSUInteger numberOfVFrameSegments = 8;

@interface PathSegmentsTests : XCTestCase {
    PathSegments *thePathSegments;
    CGFloat rowSegmentHeight;
    CGFloat columnSegmentWidth;
    NSArray *pathSegmentArray;
}

@end

@implementation PathSegmentsTests

- (void)setUp {
    [super setUp];
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeLeft]
                                forKey:@"orientation"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)checkSegmentStart:(CGPoint)start andEndPoint:(CGPoint)end atIndex:(NSUInteger)index {
    CGPathRef path = (__bridge CGPathRef)([thePathSegments.segments objectAtIndex:index]);
    XCTAssertTrue(CGPathContainsPoint(path, nil, CGPointMake(start.x, start.y), NO),
                  @"\nExpected Start Point = <%0.2f, %0.2f>", start.x, start.y);
    XCTAssertTrue(CGPathContainsPoint(path, nil, CGPointMake(end.x, end.y), NO),
                  @"\nExpected End Point = <%0.2f, %0.2f>", end.x, end.y);
}

- (void)checkSegment:(PathSegments *)segments index:(NSUInteger)index
                  x1:(CGFloat)x1 y1:(CGFloat)y1 x2:(CGFloat)x2 y2:(CGFloat)y2  {
    CGPathRef path = (__bridge CGPathRef)([segments.segments objectAtIndex:index]);
    XCTAssertTrue(CGPathContainsPoint(path, nil, CGPointMake(x1, y1), NO), @"\nExpected Start Point = <%0.2f, %0.2f>", x1, y1);
    XCTAssertTrue(CGPathContainsPoint(path, nil, CGPointMake(x2, y2), NO), @"\nExpected End Point = <%0.2f, %0.2f>", x2, y2);
}

- (void)checkRowSegmentAtIndex:(NSUInteger)index {
    thePathSegments = [[PathSegments alloc] init];
    rowSegmentHeight = thePathSegments.segmentBounds.size.height * oneOverTheNumberOfSegments;
    columnSegmentWidth = thePathSegments.segmentBounds.size.width * oneOverTheNumberOfSegments;
    [self checkSegmentStart:CGPointMake(columnSegmentWidth * 0, rowSegmentHeight * (index + 0))
                andEndPoint:CGPointMake(columnSegmentWidth * 0, rowSegmentHeight * (index + 1))
                    atIndex:index];
}

- (void)checkColumnSegmentAtIndex:(NSUInteger)index {
    thePathSegments = [[PathSegments alloc] init];
    rowSegmentHeight = thePathSegments.segmentBounds.size.height * oneOverTheNumberOfSegments;
    columnSegmentWidth = thePathSegments.segmentBounds.size.width * oneOverTheNumberOfSegments;
    [self checkSegmentStart:CGPointMake(columnSegmentWidth * (index - numberOfVerticleSegments + 0), rowSegmentHeight * 0)
                andEndPoint:CGPointMake(columnSegmentWidth * (index - numberOfVerticleSegments + 1), rowSegmentHeight * 0)
                    atIndex:index];
}

- (void)checkDiagonalSegmentAtIndex:(NSUInteger)index indexOffset:(NSUInteger)indexOffset
                             xShift:(CGFloat)xShift yShift:(CGFloat)yShift {
    CGFloat xStart = columnSegmentWidth * (index - indexOffset + 0) * xShift;
    CGFloat xEnd = columnSegmentWidth * (index - indexOffset + 1) * xShift;
    CGFloat yStart = rowSegmentHeight * (index - indexOffset + 0) * yShift;
    CGFloat yEnd = rowSegmentHeight * (index - indexOffset + 1) * yShift;
    [self checkSegmentStart:CGPointMake(xStart, yStart)
                andEndPoint:CGPointMake(xEnd, yEnd)
                    atIndex:index];
}

- (void)testSegmentsObjectHasAAnOriginOfZeroByDefault {
    PathSegments *pathSegments = [[PathSegments alloc] init];
    XCTAssertEqualPoints(pathSegments.segmentBounds.origin, CGPointZero);
}

- (void)testSegmentsObjectHasAHeightOfNinetyFivePrecentThatOfTheSreenHeightByDefault {
    PathSegments *pathSegments = [[PathSegments alloc] init];
    XCTAssertEqualWithAccuracy(pathSegments.segmentBounds.size.height, [UIScreen mainScreen].bounds.size.height * 0.75, 0.1);
}

- (void)testSegmentsObjectHasAWidthOfThirtyFivePrecentThatOfTheSreenWidthByDefault {
    PathSegments *pathSegments = [[PathSegments alloc] init];
    XCTAssertEqualWithAccuracy(pathSegments.segmentBounds.size.width, [UIScreen mainScreen].bounds.size.width * 0.35, 0.1);
}

- (void)testSegmentFrameMatchesSuppliedRectangle {
    CGRect expectedFrame = CGRectMake(1, 2, 3, 4);
    PathSegments *pathSegments = [[PathSegments alloc] initWithRect:expectedFrame];
    XCTAssertEqualWithAccuracy(pathSegments.segmentBounds.origin.x, 1, 0.0);
    XCTAssertEqualWithAccuracy(pathSegments.segmentBounds.origin.y, 2, 0.0);
    XCTAssertEqualWithAccuracy(pathSegments.segmentBounds.size.width, 3, 0.0);
    XCTAssertEqualWithAccuracy(pathSegments.segmentBounds.size.height, 4, 0.0);
}

- (void)testRow_1_Column_1_Verticlal {
    [self checkRowSegmentAtIndex:0];
}

- (void)testRow_2_Column_1_Vertical {
    [self checkRowSegmentAtIndex:1];
}

- (void)testRow_3_Column_1_Vertical {
    [self checkRowSegmentAtIndex:2];
}

- (void)testRow_4_Column_1_Vertical {
    [self checkRowSegmentAtIndex:3];
}

- (void)testColumn_1_Row_1_Horizontal {
    [self checkColumnSegmentAtIndex:numberOfVerticleSegments];
}

- (void)testColumn_2_Row_1_Horizontal {
    [self checkColumnSegmentAtIndex:numberOfVerticleSegments + 1];
}

- (void)testColumn_3_Row_1_Horizontal {
    [self checkColumnSegmentAtIndex:numberOfVerticleSegments + 2];
}

- (void)testColumn_4_Row_1_Horizontal {
    [self checkColumnSegmentAtIndex:numberOfVerticleSegments + 3];
}

- (void)testThereAre_5_TotalColumns {
    PathSegments *theseSegments = [PathSegments alloc];
    id mockPathSegments = OCMPartialMock(theseSegments);
    XCTAssertNotNil([theseSegments init]);
    OCMVerify([mockPathSegments createColumnSegmentsForRow:0]);
    OCMVerify([mockPathSegments createColumnSegmentsForRow:1]);
    OCMVerify([mockPathSegments createColumnSegmentsForRow:2]);
    OCMVerify([mockPathSegments createColumnSegmentsForRow:3]);
    OCMVerify([mockPathSegments createColumnSegmentsForRow:4]);
}

- (void)testThereAre_5_TotalRows {
    PathSegments *theseSegments = [PathSegments alloc];
    id mockPathSegments = OCMPartialMock(theseSegments);
    XCTAssertNotNil([theseSegments init]);
    OCMVerify([mockPathSegments createRowSegmentsForColumn:0]);
    OCMVerify([mockPathSegments createRowSegmentsForColumn:1]);
    OCMVerify([mockPathSegments createRowSegmentsForColumn:2]);
    OCMVerify([mockPathSegments createRowSegmentsForColumn:3]);
    OCMVerify([mockPathSegments createRowSegmentsForColumn:4]);
}

- (void)checkDiagonalSegmentAtIndex:(NSUInteger)index indexOffset:(NSUInteger)indexOffset andSlope:(CGFloat)slope {
    [self checkSegmentStart:CGPointMake(0, (index - indexOffset) * slope)
                andEndPoint:CGPointMake(1, (index - indexOffset + 1) * slope)
                    atIndex:index];
}

/*     /\     */
/*    /  \    */
/*   /    \   */
/*  /      \  */
- (void)test_A_FrameSegmentsExist {
    PathSegments *segments = [[PathSegments alloc] initWithRect:CGRectMake(0, 0, 8, 8)];
    NSUInteger index =
    numberOfVerticleSegments
    +   numberOfHorizontalSegments
    -   1;

    // Slope up
    [self checkSegment:segments index:++index x1:0 y1:0 x2:1 y2:2];
    [self checkSegment:segments index:++index x1:1 y1:2 x2:2 y2:4];
    [self checkSegment:segments index:++index x1:2 y1:4 x2:3 y2:6];
    [self checkSegment:segments index:++index x1:3 y1:6 x2:4 y2:8];
    
    // Slope down
    [self checkSegment:segments index:++index x1:4 y1:8 x2:5 y2:6];
    [self checkSegment:segments index:++index x1:5 y1:6 x2:6 y2:4];
    [self checkSegment:segments index:++index x1:6 y1:4 x2:7 y2:2];
    [self checkSegment:segments index:++index x1:7 y1:2 x2:8 y2:0];
}

/*  \      /  */
/*   \    /   */
/*    \  /    */
/*     \/     */
- (void)test_V_FrameSegmentsExist {
    PathSegments *segments = [[PathSegments alloc] initWithRect:CGRectMake(0, 0, 8, 8)];
    NSUInteger index =
        numberOfVerticleSegments
    +   numberOfHorizontalSegments
    +   numberOfAFrameSegments
    -   1;
    
    // Slope down
    [self checkSegment:segments index:++index x1:0 y1:8 x2:1 y2:6];
    [self checkSegment:segments index:++index x1:1 y1:6 x2:2 y2:4];
    [self checkSegment:segments index:++index x1:2 y1:4 x2:3 y2:2];
    [self checkSegment:segments index:++index x1:3 y1:2 x2:4 y2:0];
    
    // Slope up
    [self checkSegment:segments index:++index x1:4 y1:0 x2:5 y2:2];
    [self checkSegment:segments index:++index x1:5 y1:2 x2:6 y2:4];
    [self checkSegment:segments index:++index x1:6 y1:4 x2:7 y2:6];
    [self checkSegment:segments index:++index x1:7 y1:6 x2:8 y2:8];
}

/*  \  /  */
/*   \/   */
/*   /\   */
/*  /  \  */
- (void)test_X_FrameSegmentsExist {
    PathSegments *segments = [[PathSegments alloc] initWithRect:CGRectMake(0, 0, 8, 8)];
    
    NSUInteger index =
        numberOfVerticleSegments
    +   numberOfHorizontalSegments
    +   numberOfAFrameSegments
    +   numberOfVFrameSegments
    -   1;
    
    // Slope down
    [self checkSegment:segments index:++index x1:0 y1:0 x2:2 y2:2];
    [self checkSegment:segments index:++index x1:2 y1:2 x2:4 y2:4];
    [self checkSegment:segments index:++index x1:4 y1:4 x2:6 y2:6];
    [self checkSegment:segments index:++index x1:6 y1:6 x2:8 y2:8];
    
    // Slope up
    [self checkSegment:segments index:++index x1:0 y1:8 x2:2 y2:6];
    [self checkSegment:segments index:++index x1:2 y1:6 x2:4 y2:4];
    [self checkSegment:segments index:++index x1:4 y1:4 x2:6 y2:2];
    [self checkSegment:segments index:++index x1:6 y1:2 x2:8 y2:0];
}

@end

@interface CurveSegmentsTests : XCTestCase {
    PathSegments *theSegments;
    id theMockSegments;
}
@end

@implementation CurveSegmentsTests

- (void)setUp {
    [super setUp];
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeLeft]
                                forKey:@"orientation"];
    
    theSegments = [PathSegments alloc];
    theMockSegments = OCMPartialMock(theSegments);
    XCTAssertNotNil([theSegments initWithRect:CGRectMake(0, 0, 8, 8)]);
}

- (void)tearDown {
    [super tearDown];
}

- (void)testTheGridIsDefinedAsAFourByFour {
    XCTAssertEqual(theSegments.quarterHeight, 2);
    XCTAssertEqual(theSegments.halfHeight, 4);
    XCTAssertEqual(theSegments.threeQuarterHeight, 6);
    XCTAssertEqual(theSegments.fullHeight, 8);
    XCTAssertEqual(theSegments.quarterWidth, 2);
    XCTAssertEqual(theSegments.halfWidth, 4);
    XCTAssertEqual(theSegments.threeQuarterWidth, 6);
    XCTAssertEqual(theSegments.fullWidth, 8);
}

- (void)testThe_LowerLeft_CurveIsAdded {
    OCMVerify([theMockSegments addCurveSegmentsWithXStart:4 YStart:0 XControl:0 YControl:0 XEnd:0 YEnd:2]);
}

- (void)testThe_SecondLeft_CurveIsAdded {
    OCMVerify([theMockSegments addCurveSegmentsWithXStart:0 YStart:2 XControl:0 YControl:4 XEnd:4 YEnd:4]);
}

- (void)testThe_ThirdLeft_CurveIsAdded {
    OCMVerify([theMockSegments addCurveSegmentsWithXStart:4 YStart:4 XControl:0 YControl:4 XEnd:0 YEnd:6]);
}

- (void)testThe_UpperLeft_CurveIsAdded {
    OCMVerify([theMockSegments addCurveSegmentsWithXStart:0 YStart:6 XControl:0 YControl:8 XEnd:4 YEnd:8]);
}

- (void)testThe_UpperRight_CurveIsAdded {
    OCMVerify([theMockSegments addCurveSegmentsWithXStart:4 YStart:8 XControl:8 YControl:8 XEnd:8 YEnd:6]);
}

- (void)testThe_SecondRight_CurveIsAdded {
    OCMVerify([theMockSegments addCurveSegmentsWithXStart:8 YStart:6 XControl:8 YControl:4 XEnd:4 YEnd:4]);
}

- (void)testThe_ThirdRight_CurveIsAdded {
    OCMVerify([theMockSegments addCurveSegmentsWithXStart:4 YStart:4 XControl:8 YControl:4 XEnd:8 YEnd:2]);
}

- (void)testThe_LowerRight_CurveIsAdded {
    OCMVerify([theMockSegments addCurveSegmentsWithXStart:8 YStart:2 XControl:8 YControl:0 XEnd:4 YEnd:0]);
}

- (void)testThe_TopLeftQuadrant_CurveIsAdded {
    OCMVerify([theMockSegments addCurveSegmentsWithXStart:4 YStart:8 XControl:0 YControl:8 XEnd:0 YEnd:4]);
}

- (void)testThe_BottomLeftQuadrant_CurveIsAdded {
    OCMVerify([theMockSegments addCurveSegmentsWithXStart:0 YStart:4 XControl:0 YControl:0 XEnd:4 YEnd:0]);
}

- (void)testThe_BottomRightQuadrant_CurveIsAdded {
    OCMVerify([theMockSegments addCurveSegmentsWithXStart:4 YStart:0 XControl:8 YControl:0 XEnd:8 YEnd:4]);
}

- (void)testThe_TopRightQuadrant_CurveIsAdded {
    OCMVerify([theMockSegments addCurveSegmentsWithXStart:8 YStart:4 XControl:8 YControl:8 XEnd:4 YEnd:8]);
}

- (void)testAMethodCanDrawAPathForAGivenLetter {
    
}

@end

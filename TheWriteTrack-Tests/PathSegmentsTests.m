//
//  PathSegmentsTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/26/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "PathSegments.h"
#import "PathSegmentDictionary.h"

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
    CGFloat segmentHeight;
    CGFloat segmentWidth;
    NSArray *pathSegmentArray;
}

@end

@implementation PathSegmentsTests

- (void)setUp {
    [super setUp];
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeLeft]
                                forKey:@"orientation"];
    
    thePathSegments = [[PathSegments alloc] init];
    segmentHeight = thePathSegments.segmentBounds.size.height * oneOverTheNumberOfSegments;
    segmentWidth = thePathSegments.segmentBounds.size.width * oneOverTheNumberOfSegments;
}

- (void)tearDown {
    [super tearDown];
}

/********************************************************************************
 *      HELPERS
 ********************************************************************************/
- (void)assertPointsP0:(CGPoint)p0 andP1:(CGPoint)p1 existAtIndex:(NSUInteger)index {
    NSArray *pointArray = (NSArray *)[thePathSegments.segments objectAtIndex:index];
    XCTAssertEqualPoints([pointArray[0] CGPointValue], p0);
    XCTAssertEqualPoints([pointArray[1] CGPointValue], p1);
}

- (void)assertSegmentPointsExist:(PathSegments *)segments index:(NSUInteger)index
                              x1:(CGFloat)x1 y1:(CGFloat)y1 x2:(CGFloat)x2 y2:(CGFloat)y2  {
    NSArray *pointArray = (NSArray *)[segments.segments objectAtIndex:index];
    XCTAssertEqualPoints([pointArray[0] CGPointValue], CGPointMake(x1, y1));
    XCTAssertEqualPoints([pointArray[1] CGPointValue], CGPointMake(x2, y2));
}

- (void)checkVerticalSegmentAtIndex:(NSUInteger)index {
    [self assertPointsP0:CGPointMake(segmentWidth * 0, segmentHeight * (index + 0))
                   andP1:CGPointMake(segmentWidth * 0, segmentHeight * (index + 1))
            existAtIndex:index];
}

- (void)checkHorizontalSegmentAtIndex:(NSUInteger)index {
    [self assertPointsP0:CGPointMake(segmentWidth * (index - numberOfVerticleSegments + 0), segmentHeight * 0)
                   andP1:CGPointMake(segmentWidth * (index - numberOfVerticleSegments + 1), segmentHeight * 0)
            existAtIndex:index];
}

/********************************************************************************
 *      TESTS
 ********************************************************************************/
- (void)testSegmentsObjectHasAAnOriginOfZeroByDefault {
    PathSegments *pathSegments = [[PathSegments alloc] init];
    XCTAssertEqualPoints(pathSegments.segmentBounds.origin, CGPointZero);
}

- (void)testSegmentsObjectHasAHeightOfSeventyFivePrecentThatOfTheSreenHeightByDefault {
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

- (void)testRow_1_Column_1_Vertical {
    [self checkVerticalSegmentAtIndex:0];
}

- (void)testRow_2_Column_1_Vertical {
    [self checkVerticalSegmentAtIndex:1];
}

- (void)testRow_3_Column_1_Vertical {
    [self checkVerticalSegmentAtIndex:2];
}

- (void)testRow_4_Column_1_Vertical {
    [self checkVerticalSegmentAtIndex:3];
}

- (void)testColumn_1_Row_1_Horizontal {
    [self checkHorizontalSegmentAtIndex:numberOfVerticleSegments + 0];
}

- (void)testColumn_2_Row_1_Horizontal {
    [self checkHorizontalSegmentAtIndex:numberOfVerticleSegments + 1];
}

- (void)testColumn_3_Row_1_Horizontal {
    [self checkHorizontalSegmentAtIndex:numberOfVerticleSegments + 2];
}

- (void)testColumn_4_Row_1_Horizontal {
    [self checkHorizontalSegmentAtIndex:numberOfVerticleSegments + 3];
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

/*     /\     */    //left slope = 2
/*    /  \    */    //right slope = -2
/*   /    \   */
/*  /      \  */
- (void)test_A_FrameSegmentsExist {
    PathSegments *segments = [[PathSegments alloc] initWithRect:CGRectMake(0, 0, 8, 8)];
    NSUInteger index =
    numberOfVerticleSegments
    +   numberOfHorizontalSegments
    -   1;

    // Slope up
    [self assertSegmentPointsExist:segments index:++index x1:0 y1:0 x2:1 y2:2];
    [self assertSegmentPointsExist:segments index:++index x1:1 y1:2 x2:2 y2:4];
    [self assertSegmentPointsExist:segments index:++index x1:2 y1:4 x2:3 y2:6];
    [self assertSegmentPointsExist:segments index:++index x1:3 y1:6 x2:4 y2:8];
    
    // Slope down
    [self assertSegmentPointsExist:segments index:++index x1:4 y1:8 x2:5 y2:6];
    [self assertSegmentPointsExist:segments index:++index x1:5 y1:6 x2:6 y2:4];
    [self assertSegmentPointsExist:segments index:++index x1:6 y1:4 x2:7 y2:2];
    [self assertSegmentPointsExist:segments index:++index x1:7 y1:2 x2:8 y2:0];
}

/*  \      /  */    //left slope = -2
/*   \    /   */    //right slope = 2
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
    [self assertSegmentPointsExist:segments index:++index x1:0 y1:8 x2:1 y2:6];
    [self assertSegmentPointsExist:segments index:++index x1:1 y1:6 x2:2 y2:4];
    [self assertSegmentPointsExist:segments index:++index x1:2 y1:4 x2:3 y2:2];
    [self assertSegmentPointsExist:segments index:++index x1:3 y1:2 x2:4 y2:0];
    
    // Slope up
    [self assertSegmentPointsExist:segments index:++index x1:4 y1:0 x2:5 y2:2];
    [self assertSegmentPointsExist:segments index:++index x1:5 y1:2 x2:6 y2:4];
    [self assertSegmentPointsExist:segments index:++index x1:6 y1:4 x2:7 y2:6];
    [self assertSegmentPointsExist:segments index:++index x1:7 y1:6 x2:8 y2:8];
}

/*  \  /  */    //top down slope = -1
/*   \/   */    //bottom up slope = 1
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
    [self assertSegmentPointsExist:segments index:++index x1:0 y1:0 x2:2 y2:2];
    [self assertSegmentPointsExist:segments index:++index x1:2 y1:2 x2:4 y2:4];
    [self assertSegmentPointsExist:segments index:++index x1:4 y1:4 x2:6 y2:6];
    [self assertSegmentPointsExist:segments index:++index x1:6 y1:6 x2:8 y2:8];
    
    // Slope up
    [self assertSegmentPointsExist:segments index:++index x1:0 y1:8 x2:2 y2:6];
    [self assertSegmentPointsExist:segments index:++index x1:2 y1:6 x2:4 y2:4];
    [self assertSegmentPointsExist:segments index:++index x1:4 y1:4 x2:6 y2:2];
    [self assertSegmentPointsExist:segments index:++index x1:6 y1:2 x2:8 y2:0];
}

@end

@interface PathSegmentsCurveSegmentsTests : XCTestCase {
    PathSegments *theSegments;
    id theMockSegments;
}
@end

@implementation PathSegmentsCurveSegmentsTests

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
    OCMVerify([theMockSegments addQuadCurveDefinitionWithP1:CGPointMake(4,0) ControlPoint:CGPointMake(0,0) P2:CGPointMake(0,2)]);
}

- (void)testThe_SecondLeft_CurveIsAdded {
    OCMVerify([theMockSegments addQuadCurveDefinitionWithP1:CGPointMake(0,2) ControlPoint:CGPointMake(0,4) P2:CGPointMake(4,4)]);
}

- (void)testThe_ThirdLeft_CurveIsAdded {
    OCMVerify([theMockSegments addQuadCurveDefinitionWithP1:CGPointMake(4,4) ControlPoint:CGPointMake(0,4) P2:CGPointMake(0,6)]);
}

- (void)testThe_UpperLeft_CurveIsAdded {
    OCMVerify([theMockSegments addQuadCurveDefinitionWithP1:CGPointMake(0,6) ControlPoint:CGPointMake(0,8) P2:CGPointMake(4,8)]);
}

- (void)testThe_UpperRight_CurveIsAdded {
    OCMVerify([theMockSegments addQuadCurveDefinitionWithP1:CGPointMake(4,8) ControlPoint:CGPointMake(8,8) P2:CGPointMake(8,6)]);
}

- (void)testThe_SecondRight_CurveIsAdded {
    OCMVerify([theMockSegments addQuadCurveDefinitionWithP1:CGPointMake(8,6) ControlPoint:CGPointMake(8,4) P2:CGPointMake(4,4)]);
}

- (void)testThe_ThirdRight_CurveIsAdded {
    OCMVerify([theMockSegments addQuadCurveDefinitionWithP1:CGPointMake(4,4) ControlPoint:CGPointMake(8,4) P2:CGPointMake(8,2)]);
}

- (void)testThe_LowerRight_CurveIsAdded {
    OCMVerify([theMockSegments addQuadCurveDefinitionWithP1:CGPointMake(8,2) ControlPoint:CGPointMake(8,0) P2:CGPointMake(4,0)]);
}

- (void)testThe_TopLeftQuadrant_CurveIsAdded {
    OCMVerify([theMockSegments addQuadCurveDefinitionWithP1:CGPointMake(4,8) ControlPoint:CGPointMake(0,8) P2:CGPointMake(0,4)]);
}

- (void)testThe_BottomLeftQuadrant_CurveIsAdded {
    OCMVerify([theMockSegments addQuadCurveDefinitionWithP1:CGPointMake(0,4) ControlPoint:CGPointMake(0,0) P2:CGPointMake(4,0)]);
}

- (void)testThe_BottomRightQuadrant_CurveIsAdded {
    OCMVerify([theMockSegments addQuadCurveDefinitionWithP1:CGPointMake(4,0) ControlPoint:CGPointMake(8,0) P2:CGPointMake(8,4)]);
}

- (void)testThe_TopRightQuadrant_CurveIsAdded {
    OCMVerify([theMockSegments addQuadCurveDefinitionWithP1:CGPointMake(8,4) ControlPoint:CGPointMake(8,8) P2:CGPointMake(4,8)]);
}

@end

@interface PathSegmentsIterpolatedObjectTests : XCTestCase {
    PathSegments *thePathSegments;
    NSDictionary *segmentDictionaryForTest;
}

@end

@implementation PathSegmentsIterpolatedObjectTests

- (void)setUp {
    [super setUp];
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeLeft]
                                forKey:@"orientation"];
    
    thePathSegments = [[PathSegments alloc] initWithRect:CGRectMake(0, 0, 8, 8)];
    
    segmentDictionaryForTest = [NSDictionary dictionaryWithObjects:
                                [NSArray arrayWithObjects:
                                 [NSArray arrayWithObjects:ND, RD, SE, nil],
                                 [NSArray arrayWithObjects:v0, SE, nil],
                                 [NSArray arrayWithObjects:h20, SE, nil],
                                 [NSArray arrayWithObjects:a40, SE, nil],
                                 [NSArray arrayWithObjects:c64, SE, nil],
                                 [NSArray arrayWithObjects:RD, v3, h37, a40, v55, x61, c70, c75, SE, nil],
                                 [NSArray arrayWithObjects:v0, v1, SE, nil],
                                 [NSArray arrayWithObjects:v1, c72, SE, nil],
                                 [NSArray arrayWithObjects:c72, c73, SE, nil],
                                 nil]
                                                           forKeys:
                                [NSArray arrayWithObjects:@"ControlPointsOnly", @"VericalOne", @"HorizontalOne",
                                 @"DiagonalOne", @"CurvedOne", @"AllTypesCombined",
                                 @"StraightToStraight", @"StraightToCurve", @"CurveToCurve", nil]];
    
    [thePathSegments setLetterSegmentDictionary:segmentDictionaryForTest];
}

- (void)tearDown {
    [super tearDown];
}

@end

@interface PathSegmentsCrossbarTests : PathSegmentsIterpolatedObjectTests { } @end
@implementation PathSegmentsCrossbarTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGivenALetterDefinitionDoesNotExistForKeyWhenCrossbarsAreGeneratedThenTheCountIsZero {
    NSMutableArray *generatedCrossbars = [thePathSegments generateObjectsWithType:CrossbarObjectType forLetter:@"!"];
    XCTAssertEqual(generatedCrossbars.count, 0);
}

- (void)testGivenAValidLetterWhenCrossbarsAreCreatedThenAnyControlSegmentsAreIgnored {
    NSMutableArray *generatedCrossbars = [thePathSegments generateObjectsWithType:CrossbarObjectType forLetter:@"ControlPointsOnly"];
    XCTAssertEqual(generatedCrossbars.count, 0);
}

- (void)testGivenAValidLetterWhenCrossbarsAreCreatedThenFiveCrossbarsAreGeneratedForVerticalSegments {
    NSMutableArray *generatedCrossbars = [thePathSegments generateObjectsWithType:CrossbarObjectType forLetter:@"VericalOne"];
    XCTAssertEqual(generatedCrossbars.count, 5);
}

- (void)testGivenAValidLetterWhenCrossbarsAreCreatedThenFiveCrossbarsAreGeneratedForHorizontalSegments {
    NSMutableArray *generatedCrossbars = [thePathSegments generateObjectsWithType:CrossbarObjectType forLetter:@"HorizontalOne"];
    XCTAssertEqual(generatedCrossbars.count, 5);
}

- (void)testGivenAValidLetterWhenCrossbarsAreCreatedThenFiveCrossbarsAreGeneratedForDiagonalSegments {
    NSMutableArray *generatedCrossbars = [thePathSegments generateObjectsWithType:CrossbarObjectType forLetter:@"DiagonalOne"];
    XCTAssertEqual(generatedCrossbars.count, 5);
}

- (void)testGivenAValidLetterWhenCrossbarsAreCreatedThenTenCrossbarsAreGeneratedForCurvedSegments {
    NSMutableArray *generatedCrossbars = [thePathSegments generateObjectsWithType:CrossbarObjectType forLetter:@"CurvedOne"];
    XCTAssertEqual(generatedCrossbars.count, 11);
}

- (void)testGivenAValidLetterWithDifferentSegmentTypesWhenCrossbarsAreCreatedThenTheTotalNumberOfCrossbarsIncludesAllSegments {
    NSMutableArray *generatedCrossbars = [thePathSegments generateObjectsWithType:CrossbarObjectType forLetter:@"AllTypesCombined"];
    XCTAssertEqual(generatedCrossbars.count, 5 + 5 + 5 + 5 + 5 + 11 + 11);
}

@end

@interface PathSegmentsWaypointTests : PathSegmentsIterpolatedObjectTests { } @end
@implementation PathSegmentsWaypointTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGivenALetterDefinitionDoesNotExistForKeyWhenWaypointsAreGeneratedThenTheCountIsZero {
    [thePathSegments generateCombinedPathAndWaypointsForLetter:@"!"];
    XCTAssertEqual(thePathSegments.generatedWaypoints.count, 0);
}

- (void)testGivenAValidLetterWhenWaypointsAreCreatedThenAnyControlSegmentsAreIgnored {
    [thePathSegments generateCombinedPathAndWaypointsForLetter:@"ControlPointsOnly"];
    XCTAssertEqual([[thePathSegments.generatedWaypoints objectAtIndex:0] count], 0);
}

- (void)testGivenAValidLetterWhenWaypointsAreCreatedThenThreeWaypointsAreGeneratedForVerticalSegments {
    [thePathSegments generateCombinedPathAndWaypointsForLetter:@"VericalOne"];
    XCTAssertEqual([[thePathSegments.generatedWaypoints objectAtIndex:0] count], 2);
}

- (void)testGivenAValidLetterWhenWaypointsAreCreatedThenThreeWaypointsAreGeneratedForHorizontalSegments {
    [thePathSegments generateCombinedPathAndWaypointsForLetter:@"HorizontalOne"];
    XCTAssertEqual([[thePathSegments.generatedWaypoints objectAtIndex:0] count], 2);
}

- (void)testGivenAValidLetterWhenWaypointsAreCreatedThenThreeWaypointsAreGeneratedForDiagonalSegments {
    [thePathSegments generateCombinedPathAndWaypointsForLetter:@"DiagonalOne"];
    XCTAssertEqual([[thePathSegments.generatedWaypoints objectAtIndex:0] count], 2);
}

- (void)testGivenAValidLetterWhenWaypointsAreCreatedThenFiveWaypointsAreGeneratedForCurvedSegments {
    [thePathSegments generateCombinedPathAndWaypointsForLetter:@"CurvedOne"];
    XCTAssertEqual([[thePathSegments.generatedWaypoints objectAtIndex:0] count], 3);
}

- (void)testDuplicatePointsAreNotAddedForTwoStraightSegmentsThatTouch {
    [thePathSegments generateCombinedPathAndWaypointsForLetter:@"StraightToStraight"];
    NSMutableArray *firstArray = [thePathSegments.generatedWaypoints objectAtIndex:0];
    XCTAssertEqual(firstArray.count, 3);
    XCTAssertEqualPoints([[firstArray objectAtIndex:0] CGPointValue], CGPointMake(0, 0));
    XCTAssertEqualPoints([[firstArray objectAtIndex:1] CGPointValue], CGPointMake(0, 2));
    XCTAssertEqualPoints([[firstArray objectAtIndex:2] CGPointValue], CGPointMake(0, 4));
}

- (void)testDuplicatePointsAreNotAddedForAStraightAndACurveSegmentThatTouch {
    [thePathSegments generateCombinedPathAndWaypointsForLetter:@"StraightToCurve"];
    XCTAssertEqual([[thePathSegments.generatedWaypoints objectAtIndex:0] count], 4);
}

- (void)testDuplicatePointsAreNotAddedForTwoCurvedSegmentsThatTouch {
    [thePathSegments generateCombinedPathAndWaypointsForLetter:@"CurveToCurve"];
    XCTAssertEqual([[thePathSegments.generatedWaypoints objectAtIndex:0] count], 5);
}

@end

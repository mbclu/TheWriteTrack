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

- (void)testWhenTheCombinedPathIsGeneratedThenTheZeroingPointIsSetToTheXYDifferenceFromTheCombinedPathOrigin {
    CGRect expectedFrame = CGRectMake(0, 0, 8, 8);
    PathSegments *pathSegments = [[PathSegments alloc] initWithRect:expectedFrame];

    /* Could test this other ways, but we know that the letter 'B' has problems right now. */
    [pathSegments setLetterSegmentDictionary:[PathSegmentDictionary dictionaryWithUpperCasePathSegments]];
    [pathSegments generateCombinedPathForLetter:@"B"];
    
    XCTAssertEqualPoints(pathSegments.zeroingPoint, CGPointMake(2, 0));
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
                                 [NSArray arrayWithObjects:v0, nil],
                                 [NSArray arrayWithObjects:h20, nil],
                                 [NSArray arrayWithObjects:a40, nil],
                                 [NSArray arrayWithObjects:c64, nil],
                                 [NSArray arrayWithObjects:RD, v1, h21, a41, v48, x59, c64, c65, SE, nil], nil]
                                                           forKeys:
                                [NSArray arrayWithObjects:@"ControlPointsOnly", @"VericalOne", @"HorizontalOne", @"DiagonalOne", @"CurvedOne", @"AllCombined", nil]];
    
    [thePathSegments setLetterSegmentDictionary:segmentDictionaryForTest];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testTheDefaultZeroingPointIsZero {
    XCTAssertEqualPoints(thePathSegments.zeroingPoint, CGPointZero);
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
    [thePathSegments generateObjectsWithType:CrossbarObjectType forLetter:@"!"];
    XCTAssertEqual(thePathSegments.generatedCrossbars.count, 0);
}

- (void)testGivenAValidLetterWhenCrossbarsAreCreatedThenAnyControlSegmentsAreIgnored {
    [thePathSegments generateObjectsWithType:CrossbarObjectType forLetter:@"ControlPointsOnly"];
    XCTAssertEqual(thePathSegments.generatedCrossbars.count, 0);
}

- (void)testGivenAValidLetterWhenCrossbarsAreCreatedThenFiveCrossbarsAreGeneratedForVerticalSegments {
    [thePathSegments generateObjectsWithType:CrossbarObjectType forLetter:@"VericalOne"];
    XCTAssertEqual(thePathSegments.generatedCrossbars.count, 5);
}

- (void)testGivenAValidLetterWhenCrossbarsAreCreatedThenFiveCrossbarsAreGeneratedForHorizontalSegments {
    [thePathSegments generateObjectsWithType:CrossbarObjectType forLetter:@"HorizontalOne"];
    XCTAssertEqual(thePathSegments.generatedCrossbars.count, 5);
}

- (void)testGivenAValidLetterWhenCrossbarsAreCreatedThenFiveCrossbarsAreGeneratedForDiagonalSegments {
    [thePathSegments generateObjectsWithType:CrossbarObjectType forLetter:@"DiagonalOne"];
    XCTAssertEqual(thePathSegments.generatedCrossbars.count, 5);
}

- (void)testGivenAValidLetterWhenCrossbarsAreCreatedThenTenCrossbarsAreGeneratedForCurvedSegments {
    [thePathSegments generateObjectsWithType:CrossbarObjectType forLetter:@"CurvedOne"];
    XCTAssertEqual(thePathSegments.generatedCrossbars.count, 11);
}

- (void)testGivenAValidLetterWithDifferentSegmentTypesWhenCrossbarsAreCreatedThenTheTotalNumberOfCrossbarsIncludesAllSegments {
    [thePathSegments generateObjectsWithType:CrossbarObjectType forLetter:@"AllCombined"];
    XCTAssertEqual(thePathSegments.generatedCrossbars.count, 5 + 5 + 5 + 5 + 5 + 11 + 11);
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
    [thePathSegments generateObjectsWithType:WaypointObjectType forLetter:@"!"];
    XCTAssertEqual(thePathSegments.generatedWaypoints.count, 0);
}

- (void)testGivenAValidLetterWhenWaypointsAreCreatedThenAnyControlSegmentsAreIgnored {
    [thePathSegments generateObjectsWithType:WaypointObjectType forLetter:@"ControlPointsOnly"];
    XCTAssertEqual(thePathSegments.generatedWaypoints.count, 0);
}

- (void)testGivenAValidLetterWhenWaypointsAreCreatedThenThreeWaypointsAreGeneratedForVerticalSegments {
    [thePathSegments generateObjectsWithType:WaypointObjectType forLetter:@"VericalOne"];
    XCTAssertEqual(thePathSegments.generatedWaypoints.count, 2);
}

- (void)testGivenAValidLetterWhenWaypointsAreCreatedThenThreeWaypointsAreGeneratedForHorizontalSegments {
    [thePathSegments generateObjectsWithType:WaypointObjectType forLetter:@"HorizontalOne"];
    XCTAssertEqual(thePathSegments.generatedWaypoints.count, 2);
}

- (void)testGivenAValidLetterWhenWaypointsAreCreatedThenThreeWaypointsAreGeneratedForDiagonalSegments {
    [thePathSegments generateObjectsWithType:WaypointObjectType forLetter:@"DiagonalOne"];
    XCTAssertEqual(thePathSegments.generatedWaypoints.count, 2);
}

- (void)testGivenAValidLetterWhenWaypointsAreCreatedThenFiveWaypointsAreGeneratedForCurvedSegments {
    [thePathSegments generateObjectsWithType:WaypointObjectType forLetter:@"CurvedOne"];
    XCTAssertEqual(thePathSegments.generatedWaypoints.count, 3);
}

- (void)testGivenAValidLetterWithDifferentSegmentTypesWhenWaypointsAreCreatedThenTheTotalNumberOfWaypointsIncludesAllSegments {
    [thePathSegments generateObjectsWithType:WaypointObjectType forLetter:@"AllCombined"];
    XCTAssertEqual(thePathSegments.generatedWaypoints.count, 2 + 2 + 2 + 2 + 2 + 3 + 3);
}

@end

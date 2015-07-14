//
//  LayoutMathTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 3/16/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LayoutMath.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "LetterConverter.h"

@interface LayoutMathTestsSetup : XCTestCase {
    @protected CGFloat defaultAccuracy;
    @protected id startingOrientation;
    @protected CGRect rectForTest;
    @protected CGMutablePathRef rectPathForTest;
    @protected LetterConverter *letterConverter;
}

@end

CGRect printBoundingBoxForLetter(CGMutablePathRef path, NSString *letter) {
    CGRect bounds = CGPathGetPathBoundingBox(path);
    NSLog(@"\nBounds for the letter \"%@\":\n"
          "\t x = %1.2f \t y= %1.2f\n"
          "\t width = %1.2f \t height = %1.2f",
          letter,
          bounds.origin.x,
          bounds.origin.y,
          bounds.size.width,
          bounds.size.height);
    return bounds;
}

@implementation LayoutMathTestsSetup

- (void)setUpRectPath {
    rectPathForTest = CGPathCreateMutable();
    rectForTest = CGRectMake(0, 0, 10, 20);
    CGPathAddRect(rectPathForTest, nil, rectForTest);
    letterConverter = [[LetterConverter alloc] init];
}

- (void)setUp {
    [super setUp];
    defaultAccuracy = 1.0;
    startingOrientation = [[UIDevice currentDevice] valueForKey:@"orientation"];
    [self setUpRectPath];
}

- (void)tearDown {
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: (NSInteger)startingOrientation]
                                forKey:@"orientation"];
    [super tearDown];
}

@end

@interface LayoutMathTests : LayoutMathTestsSetup
@end

@implementation LayoutMathTests

- (void)testGivenABoundingRectangleWhenTheRectangleIsCeneteredThenTheStartingXValueIsPositionedCorrectly {
    NSString *stringForTest = @"A";
    CGMutablePathRef path = [letterConverter createPathFromString:stringForTest andSize:100];
    CGRect bounds = printBoundingBoxForLetter(path, stringForTest);
    CGFloat expectedX = ([UIScreen mainScreen].bounds.size.width - bounds.size.width) / 2;
    XCTAssertEqual([LayoutMath findStartingXValueForRect:bounds], expectedX);
}

- (void)testGivenABoundingRectangleWhenTheRectangleIsCeneteredThenTheStartingYValueIsPositionedCorrectly {
    NSString *stringForTest = @"A";
    CGMutablePathRef path = [letterConverter createPathFromString:stringForTest andSize:100];
    CGRect bounds = printBoundingBoxForLetter(path, stringForTest);
    CGFloat expectedY = ([UIScreen mainScreen].bounds.size.height - bounds.size.height) / 2;
    XCTAssertEqual([LayoutMath findStartingYValueForRect:bounds], expectedY);
}

- (void)testTheUpperLeftCornerOfAnObjectCanBePlacedAtTheUpperLeftOfTheScreen {
    CGPoint origin = [LayoutMath originForUpperLeftPlacementOfPath:rectPathForTest];
    
    CGFloat xExpected = rectForTest.origin.x;
    CGFloat yExpected = [UIScreen mainScreen].bounds.size.height - rectForTest.size.height;
    
    XCTAssertEqualWithAccuracy(origin.x, xExpected, defaultAccuracy);
    XCTAssertEqualWithAccuracy(origin.y, yExpected, defaultAccuracy);
}

- (void)testThePointAdjacentToTheRightMostLetterHasGreaterXValue {
    CGPoint origin = [LayoutMath originForPath:rectPathForTest adjacentToPathOnLeft:rectPathForTest];
    
    CGFloat xExpected = rectForTest.size.width;
    CGFloat yExpected = [UIScreen mainScreen].bounds.size.height - rectForTest.size.height;
    
    XCTAssertEqualWithAccuracy(origin.x, xExpected, defaultAccuracy);
    XCTAssertEqualWithAccuracy(origin.y, yExpected, defaultAccuracy);
}

- (void)testGivenAStartAndEndPointWhenALineIsInterpolatedForXThenTheReturnIsXStartPlusAPercentageOfTheChange {
    CGPoint start = CGPointZero;
    CGPoint end = CGPointMake(10, 0);
    XCTAssertEqual([LayoutMath interpolateLineWithStep:0.1 start:start.x end:end.x], 9);
}

- (void)testTheLetterButtonFontSizeAllowsFor13LettersIn75To85PercentOfTheScreen {
    CGFloat minSize = [UIScreen mainScreen].bounds.size.width * 0.75 / 13;
    CGFloat maxSize = [UIScreen mainScreen].bounds.size.width * 0.85 / 13;
    CGFloat size = [LayoutMath letterButtonFontSizeByForDevice];
    XCTAssertGreaterThan(size, minSize);
    XCTAssertLessThan(size, maxSize);
}

@end

@interface LayoutMathTests_Landscape : LayoutMathTestsSetup
@end

@implementation LayoutMathTests_Landscape

- (void)setUp {
    [super setUp];
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeLeft]
                                forKey:@"orientation"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGivenALandscapeLayoutTheSmallerOfWidthOrHeightIsFoundToBeHeight {
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    XCTAssertLessThan(height, width);
    XCTAssertEqualWithAccuracy([LayoutMath sizeOfSmallerDimension], height, defaultAccuracy);
}

- (void)testGivenALandscapeLayoutTheLargerOfWidthOrHeightIsFoundToBeWidth {
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    XCTAssertLessThan(height, width);
    XCTAssertEqualWithAccuracy([LayoutMath sizeOfLargerDimension], width, defaultAccuracy);
}

- (void)testGivenALandscapeOrientationThenTheCenterXValueIsHalfTheWidth {
    CGFloat expectedX = [UIScreen mainScreen].bounds.size.width / 2;
    XCTAssertEqualWithAccuracy([LayoutMath xCenterForMainScreen], expectedX, defaultAccuracy);
}

- (void)testGivenALandscapeOrientationThenTheCenterYValueIsHalfTheHeight {
    CGFloat expectedY = [UIScreen mainScreen].bounds.size.height / 2;
    XCTAssertEqualWithAccuracy([LayoutMath yCenterForMainScreen], expectedY, defaultAccuracy);
}

- (void)testTheCenterPointIsWidthHeightWhenInLandscapeOrientation {
    CGPoint expectedCenter = CGPointMake([UIScreen mainScreen].bounds.size.width / 2,
                                         [UIScreen mainScreen].bounds.size.height / 2);
    XCTAssertEqualWithAccuracy([LayoutMath centerOfMainScreen].x, expectedCenter.x, defaultAccuracy);
    XCTAssertEqualWithAccuracy([LayoutMath centerOfMainScreen].y, expectedCenter.y, defaultAccuracy);
}

@end

@interface LayoutMathTests_Portrait : LayoutMathTestsSetup
@end

@implementation LayoutMathTests_Portrait

- (void)setUp {
    [super setUp];
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGivenAPortraitLayoutTheSmallerOfWidthOrHeightIsFoundToBeHeight {
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    XCTAssertLessThan(height, width);
    XCTAssertEqualWithAccuracy([LayoutMath sizeOfSmallerDimension], height, defaultAccuracy);
}

- (void)testGivenAniPhone6InPortraitOrientationTheLetterSizeIsFoundToBeThreeHundredTwentyFiveOrFiftyLessThanHalfTheSmallerScreenDimension {
    CGFloat expectedSize = 325.0;
    XCTAssertEqualWithAccuracy([LayoutMath maximumViableFontSize], expectedSize, defaultAccuracy);
}

- (void)testGivenAPortraitOrientationThenTheCenterXValueIsHalfTheHeight {
    CGFloat expectedX = [UIScreen mainScreen].bounds.size.height / 2;
    XCTAssertEqualWithAccuracy([LayoutMath xCenterForMainScreen], expectedX, defaultAccuracy);
}

- (void)testGivenAPortraitOrientationThenTheCenterYValueIsHalfTheWidth {
    CGFloat expectedY = [UIScreen mainScreen].bounds.size.width / 2;
    XCTAssertEqualWithAccuracy([LayoutMath yCenterForMainScreen], expectedY, defaultAccuracy);
}

- (void)testTheCenterPointIsHeightWidthWhenInPortraitOrientation {
    CGPoint expectedCenter = CGPointMake([UIScreen mainScreen].bounds.size.height / 2,
                                         [UIScreen mainScreen].bounds.size.width / 2);
    XCTAssertEqualWithAccuracy([LayoutMath centerOfMainScreen].x, expectedCenter.x, defaultAccuracy);
    XCTAssertEqualWithAccuracy([LayoutMath centerOfMainScreen].y, expectedCenter.y, defaultAccuracy);
}

@end

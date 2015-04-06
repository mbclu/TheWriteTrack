//
//  LayoutMathTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 3/16/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "LayoutMath.h"
#import "LetterConverter.h"
#import "CocoaLumberjack.h"

static const DDLogLevel ddLogLevel = DDLogLevelInfo;

@interface LayoutMathTests : XCTestCase
@property CGFloat defaultAccuracy;
@property id startingOrientation;
@end

CGRect printBoundingBoxForLetter(CGMutablePathRef path, NSString *letter) {
    CGRect bounds = CGPathGetPathBoundingBox(path);
    DDLogInfo(@"\nBounds for the letter \"%@\":\n"
          "\t x = %1.2f \t y= %1.2f\n"
          "\t width = %1.2f \t height = %1.2f",
          letter,
          bounds.origin.x,
          bounds.origin.y,
          bounds.size.width,
          bounds.size.height);
    return bounds;
}

@implementation LayoutMathTests
@synthesize defaultAccuracy;
@synthesize startingOrientation;

- (void)setUp {
    [super setUp];
    defaultAccuracy = 1.0;
    startingOrientation = [[UIDevice currentDevice] valueForKey:@"orientation"];
}

- (void)tearDown {
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: (NSInteger)startingOrientation]
                                forKey:@"orientation"];
    [super tearDown];
}

- (void)testThatGivenABoundingRectangleWhenTheRectangleIsCeneteredThenTheStartingXValueIsPositionedCorrectly {
    NSString *stringForTest = @"A";
    CGMutablePathRef path = CGPathCreateMutable();
    path = [LetterConverter pathFromAttributedString:[LetterConverter createAttributedString:stringForTest]];
    CGRect bounds;
    bounds = printBoundingBoxForLetter(path, stringForTest);
    CGFloat expectedX = ([UIScreen mainScreen].bounds.size.width - bounds.size.width) / 2;
    XCTAssertEqual([LayoutMath findStartingXValueForRect:bounds], expectedX);
}

- (void)testThatGivenABoundingRectangleWhenTheRectangleIsCeneteredThenTheStartingYValueIsPositionedCorrectly {
    NSString *stringForTest = @"A";
    CGMutablePathRef path = CGPathCreateMutable();
    path = [LetterConverter pathFromAttributedString:[LetterConverter createAttributedString:stringForTest]];
    CGRect bounds;
    bounds = printBoundingBoxForLetter(path, stringForTest);
    CGFloat expectedY = ([UIScreen mainScreen].bounds.size.height - bounds.size.height) / 2;
    XCTAssertEqual([LayoutMath findStartingYValueForRect:bounds], expectedY);
}

@end

@interface LayoutMathTests_Landscape : LayoutMathTests
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

- (void)testThatGivenALandscapeLayoutTheSmallerOfWidthOrHeightIsFoundToBeHeight {
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    XCTAssertLessThan(height, width);
    XCTAssertEqualWithAccuracy([LayoutMath sizeOfSmallerDimension], height, super.defaultAccuracy);
}

- (void)testThatGivenALandscapeOrientationThenTheCenterXValueIsHalfTheWidth {
    CGFloat expectedX = [UIScreen mainScreen].bounds.size.width / 2;
    XCTAssertEqualWithAccuracy([LayoutMath centerX], expectedX, super.defaultAccuracy);
}

- (void)testThatGivenALandscapeOrientationThenTheCenterYValueIsHalfTheHeight {
    CGFloat expectedY = [UIScreen mainScreen].bounds.size.height / 2;
    XCTAssertEqualWithAccuracy([LayoutMath centerY], expectedY, super.defaultAccuracy);
}

@end

@interface LayoutMathTests_Portrait : LayoutMathTests
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

- (void)testThatGivenAPortraitLayoutTheSmallerOfWidthOrHeightIsFoundToBeHeight {
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    XCTAssertLessThan(height, width);
    XCTAssertEqualWithAccuracy([LayoutMath sizeOfSmallerDimension], height, super.defaultAccuracy);
}

- (void)testThatGivenAniPhone6InPortraitOrientationTheLetterSizeIsFoundToBe325Or50LessThanHalfTheSmallerScreenDimension {
    CGFloat expectedSize = 325.0;
    XCTAssertEqualWithAccuracy([LayoutMath maximumViableFontSize], expectedSize, super.defaultAccuracy);
}

- (void)testThatGivenAPortraitOrientationThenTheCenterXValueIsHalfTheHeight {
    CGFloat expectedX = [UIScreen mainScreen].bounds.size.height / 2;
    XCTAssertEqualWithAccuracy([LayoutMath centerX], expectedX, super.defaultAccuracy);
}

- (void)testThatGivenAPortraitOrientationThenTheCenterYValueIsHalfTheWidth {
    CGFloat expectedY = [UIScreen mainScreen].bounds.size.width / 2;
    XCTAssertEqualWithAccuracy([LayoutMath centerY], expectedY, super.defaultAccuracy);
}

@end

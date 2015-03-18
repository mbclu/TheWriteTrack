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

@interface LayoutMathTests : XCTestCase

@end

@implementation LayoutMathTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThatGivenAPortraitLayoutTheSmallerOfWidthOrHeightIsFoundToBeHeight {
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    XCTAssertLessThan(height, width);
    XCTAssertEqual([LayoutMath sizeOfSmallerDimension], height);
}

- (void)testThatGivenALandscapeLayoutTheSmallerOfWidthOrHeightIsFoundToBeWidth {
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeLeft]
                                forKey:@"orientation"];
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    XCTAssertLessThan(height, width);
    XCTAssertEqual([LayoutMath sizeOfSmallerDimension], width);
}

/// @TODO - really need to make this more robust for other devices / screen resolutions
/* UIScreen returns a value in points, similar to printer points or font size points, with
 * the exception that points are 1:1 for non-retina diplays and 1:2 for retina displays */
- (void)testThatGivenAniPhone6InPortraitOrientationTheLetterSizeIsFoundToBe325Or50LessThanTheSmallerScreenDimension {
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
    CGFloat expectedSize = 325.0;
    CGFloat accuracy = 1.0;
    XCTAssertEqualWithAccuracy([LayoutMath maximumViableFontSize], expectedSize, accuracy);
}

@end

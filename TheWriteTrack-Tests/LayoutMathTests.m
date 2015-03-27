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

@property CGFloat defaultAccuracy;
@property id startingOrientation;

@end

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
    CGFloat expectedSize = 163.0;
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

- (void)testThatGivenALandscapeLayoutTheSmallerOfWidthOrHeightIsFoundToBeWidth {
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    XCTAssertLessThan(height, width);
    XCTAssertEqualWithAccuracy([LayoutMath sizeOfSmallerDimension], width, super.defaultAccuracy);
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
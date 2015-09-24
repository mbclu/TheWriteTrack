//
//  LetterSelectButtonTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 6/21/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LetterSelectButton.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "CGMatchers.h"
#import "LayoutMath.h"

@interface LetterSelectButtonTests : XCTestCase {
    LetterSelectButton *theSelectButton;
    SKNode *theANode;
    SKNode *theBNode;
    SKNode *theCNode;
}

@end

@implementation LetterSelectButtonTests

- (void)setUp {
    [super setUp];
    theSelectButton = [[LetterSelectButton alloc] init];
    theANode = [theSelectButton childNodeWithName:@"ANode"];
    theBNode = [theSelectButton childNodeWithName:@"BNode"];
    theCNode = [theSelectButton childNodeWithName:@"CNode"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testTheLetterSelectButtonHasALetter_A_Node {
    XCTAssertNotNil(theANode);
}

- (void)testTheLetterSelectButtonHasALetter_B_Node {
    XCTAssertNotNil(theBNode);
}

- (void)testTheLetterSelectButtonHasALetter_C_Node {
    XCTAssertNotNil(theCNode);
}

- (void)testThe_A_NodeIsPositionedAtOrigin {
    XCTAssertEqualPoints(theANode.position, CGPointZero);
}

- (void)testTheBNodeDoesNotOverlapTheANode {
    XCTAssertGreaterThan(theBNode.position.x, theANode.frame.size.width);
}

- (void)testTheCNodeDoesNotOverlapTheBNode {
    XCTAssertGreaterThan(theCNode.position.x, theBNode.frame.size.width);
}

- (void)testUserInteractionIsDisabledForTheLetterNodes {
    XCTAssertFalse(theANode.isUserInteractionEnabled);
    XCTAssertFalse(theBNode.isUserInteractionEnabled);
    XCTAssertFalse(theCNode.isUserInteractionEnabled);
}

- (void)testThatUserInteractionIsEnabledForTheThisButton {
    XCTAssertTrue(theSelectButton.isUserInteractionEnabled);
}

- (void)testWhenTheButtonIsCreatedThenItHasAWidthEqualToTheSumOfTheABCLettersWidthAndPadding {
    float xPaddingSum = DOUBLE_THE(LETTER_SELECT_BUTTON_X_PADDING);
    float letterWidthSum = theANode.frame.size.width + theBNode.frame.size.width + theCNode.frame.size.width;
    XCTAssertEqualWithAccuracy(theSelectButton.frame.size.width, letterWidthSum + xPaddingSum, 0.01);
}

- (void)testWhenTheButtonIsCreatedThenItHasAHeightGreaterThanTheDifferenceOfTheLowestAndHighestABCLetters {
    float expectedHeight = [self findGreatestHeight] - [self findLowestY];
    XCTAssertGreaterThan(theSelectButton.frame.size.height, expectedHeight);
}

- (float)findLowestY {
    return MIN(MIN(theANode.frame.origin.y, theBNode.frame.origin.y), theCNode.frame.origin.y);
}

- (float) findGreatestHeight {
    return MAX(MAX(theANode.frame.size.height, theBNode.frame.size.height), theCNode.frame.size.height);
}

@end

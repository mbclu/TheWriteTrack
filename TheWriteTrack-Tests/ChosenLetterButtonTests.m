//
//  ChosenLetterButtonTests.m
//  TheWriteTrack
//
//  Created by Mitch Clutter on 6/25/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "ChosenLetterButton.h"
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface ChosenLetterButtonTests : XCTestCase {
    ChosenLetterButton *theButton;
    SKNode *theLetterNode;
}

@end

@implementation ChosenLetterButtonTests

- (void)setUp {
    [super setUp];
    unichar aLetter = 'A';
    theButton = [[ChosenLetterButton alloc] initWithLetter:aLetter];
    theLetterNode = [theButton childNodeWithName:@"LetterNode"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testTheLetterIsAsignedToTheButtonWhenInitialized {
    unichar aLetter = 'A';
    theButton = [[ChosenLetterButton alloc] initWithLetter:aLetter];
    XCTAssertEqual(theButton.letter, aLetter);
}

- (void)testTheButtonHasANodeRepresentingALetter {
    XCTAssertNotNil(theLetterNode);
}

- (void)testUserInteractionIsEnabledForTheLetterNode {
    XCTAssertTrue(theLetterNode.userInteractionEnabled);
}

- (void)testLineWidthIsHalfAPointForTheLetterNode {
    XCTAssertEqual(((SKShapeNode *)theLetterNode).lineWidth, 0.5);
}

- (void)testTheAccessibilityValueOfTheButtonIsSetToTheLetter {
    XCTAssertEqualObjects(theButton.accessibilityValue, @"A");
}

- (void)testTheNameOfTheButtonIsLetterOverlayNode {
    XCTAssertEqualObjects(theButton.name, @"LetterOverlayNode");
}

@end

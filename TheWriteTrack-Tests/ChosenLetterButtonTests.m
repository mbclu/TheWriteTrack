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
    ChosenLetterButton *aButton;
    SKNode *aLetterNode;
}

@end

@implementation ChosenLetterButtonTests

- (void)setUp {
    [super setUp];
    unichar aLetter = 'A';
    aButton = [[ChosenLetterButton alloc] initWithLetter:aLetter];
    aLetterNode = [aButton childNodeWithName:@"LetterNode"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testTheLetterIsAsignedToTheButtonWhenInitialized {
    unichar aLetter = 'A';
    aButton = [[ChosenLetterButton alloc] initWithLetter:aLetter];
    XCTAssertEqual(aButton.letter, aLetter);
}

- (void)testTheButtonHasANodeRepresentingALetter {
    XCTAssertNotNil(aLetterNode);
}

- (void)testUserInteractionIsDisabledForTheLetterNode {
    XCTAssertFalse(aLetterNode.userInteractionEnabled);
}

- (void)testLineWidthIsHalfAPointForTheLetterNode {
    XCTAssertEqual(((SKShapeNode *)aLetterNode).lineWidth, 0.5);
}

- (void)testTheAccessibilityValueOfTheButtonIsSetToTheLetter {
    XCTAssertEqualObjects(aButton.accessibilityValue, @"A");
    ChosenLetterButton *button = [[ChosenLetterButton alloc] initWithLetter:'B'];
    XCTAssertEqualObjects(button.accessibilityValue, @"B");
}

- (void)testTheNameOfTheButtonIsLetterOverlayNode {
    XCTAssertEqualObjects(aButton.name, @"LetterOverlayNode");
}

@end

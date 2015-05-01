//
//  StartButtonTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/30/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "StartButton.h"
#import "AttributedStringPath.h"
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

@interface StartButtonTests : XCTestCase

@property StartButton *startButton;

@end

@implementation StartButtonTests

@synthesize startButton;

- (void)setUp {
    [super setUp];
    startButton = [[StartButton alloc] initWithAttributedStringPath:nil];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testTheStartButtonHasANonNilAttributedStringPath {
    XCTAssertNotNil([startButton stringPath]);
}

- (void)testTheNumberOfChildNodesIsEqualToTheNumberLettersInString {
    XCTAssertEqual(startButton.children.count, 5);
}

- (void)testNodesAddedAreOfTypeSKEmitter {
    SKNode *node = [[startButton children] objectAtIndex:0];
    XCTAssertTrue([node isKindOfClass:[SKEmitterNode class]]);
}

- (void)testTheStartButtonEmittersLoadFromTheOrangeSmokePNG {
    SKEmitterNode *node = [[startButton children] objectAtIndex:0];
    XCTAssertNotEqual([node.particleTexture.description rangeOfString:@"OrangeSmoke.png"].location, NSNotFound);
}

- (void)testTheStartButtonEmittersHaveARepeatAction {
    SKEmitterNode *node = [[startButton children] objectAtIndex:0];
    XCTAssertNotEqual([node.particleAction.description rangeOfString:@"SKRepeat"].location, NSNotFound);
}

@end

@interface StartButtonWithMockLetterConverterTests : XCTestCase
@end

@implementation StartButtonWithMockLetterConverterTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testAPathWithFontSizeOneHundredIsCreatedForEachLetter {
    LetterConverter *lcObject = [[LetterConverter alloc] init];
    id lcMock = OCMPartialMock(lcObject);
    
    AttributedStringPath *stringPath = [[AttributedStringPath alloc] initWithLetterConverter:lcMock];
    StartButton *startButton = [[StartButton alloc] initWithAttributedStringPath:stringPath];
    
    XCTAssertNotNil(startButton);
    XCTAssertEqualWithAccuracy(StartStringSize, 100.0, 0.0);
    
    OCMVerify([lcMock createPathFromString:@"s" AndSize:StartStringSize]);
    OCMVerify([lcMock createPathFromString:@"t" AndSize:StartStringSize]);
    OCMVerify([lcMock createPathFromString:@"a" AndSize:StartStringSize]);
    OCMVerify([lcMock createPathFromString:@"r" AndSize:StartStringSize]);
    OCMVerify([lcMock createPathFromString:@"t" AndSize:StartStringSize]);
}

@end

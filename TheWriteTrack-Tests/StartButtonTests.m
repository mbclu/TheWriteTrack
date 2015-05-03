//
//  StartButtonTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/30/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "StartButton.h"
#import "LayoutMath.h"
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

@interface StartButtonTests : XCTestCase

@property StartButton *startButton;
@property SKEmitterNode *s_node;
@property SKEmitterNode *t_node;
@property SKEmitterNode *a_node;
@property SKEmitterNode *r_node;
@end

@implementation StartButtonTests

@synthesize startButton;
@synthesize s_node;
@synthesize t_node;
@synthesize a_node;

- (void)setUp {
    [super setUp];
    startButton = [[StartButton alloc] initWithAttributedStringPath:nil];
    s_node = [[startButton children] objectAtIndex:0];
    t_node = [[startButton children] objectAtIndex:1];
    a_node = [[startButton children] objectAtIndex:2];
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
    XCTAssertNotEqual([s_node.particleTexture.description rangeOfString:@"OrangeSmoke.png"].location, NSNotFound);
}

- (void)testTheStartButtonEmittersHaveARepeatAction {
    XCTAssertNotEqual([s_node.particleAction.description rangeOfString:@"SKRepeat"].location, NSNotFound);
}

- (void)testTheLetter_s_IsPlacedAtZeroZero {
    CGPoint expectedOrigin = CGPointZero;
    XCTAssertEqual(s_node.frame.origin.x, expectedOrigin.x);
    XCTAssertEqual(s_node.frame.origin.y, expectedOrigin.y);
}

- (void)testTheFirst_t_LetterIsPlacedAtAnXPositionTenGreaterThanTheWidthOfThe_s_Letter {
    CGPathRef sPath = [startButton.stringPath createPathWithString:@"s" andSize:StartStringSize];
    CGRect sBounds = CGPathGetBoundingBox(sPath);
    CGPoint expectedOrigin = CGPointMake(10 + sBounds.origin.x + sBounds.size.width, 0);
    XCTAssertEqual(t_node.frame.origin.x, expectedOrigin.x);
    XCTAssertEqual(t_node.frame.origin.y, expectedOrigin.y);
}

- (void)testThe_a_LetterIsPlacedAtAnXPositionTwentyGreaterThanTheWidthOfThe_s_And_t_Letters {
    CGPathRef sPath = [startButton.stringPath createPathWithString:@"s" andSize:StartStringSize];
    CGPathRef tPath = [startButton.stringPath createPathWithString:@"t" andSize:StartStringSize];
    CGRect sBounds = CGPathGetBoundingBox(sPath);
    CGRect tBounds = CGPathGetBoundingBox(tPath);
    CGPoint expectedOrigin = CGPointMake(10 + sBounds.origin.x + sBounds.size.width +
                                         10 + tBounds.origin.x + tBounds.size.width, 0);
    XCTAssertEqual(a_node.frame.origin.x, expectedOrigin.x);
    XCTAssertEqual(a_node.frame.origin.y, expectedOrigin.y);
}

- (void)testTheStartButtonHasHeightEqualOrGreaterThanItsTallestChildPath {
    CGPathRef tPath = [startButton.stringPath createPathWithString:@"t" andSize:StartStringSize];
    CGRect tBounds = CGPathGetBoundingBox(tPath);
    XCTAssertGreaterThanOrEqual(startButton.size.height, tBounds.size.height);
}

- (void)testTheStartButtonHasWidthEqualOrGreaterThanItsCombinedChildrenPaths {
    CGRect sBounds = CGPathGetBoundingBox([startButton.stringPath createPathWithString:@"s" andSize:StartStringSize]);
    CGRect tBounds = CGPathGetBoundingBox([startButton.stringPath createPathWithString:@"t" andSize:StartStringSize]);
    CGRect aBounds = CGPathGetBoundingBox([startButton.stringPath createPathWithString:@"a" andSize:StartStringSize]);
    CGRect rBounds = CGPathGetBoundingBox([startButton.stringPath createPathWithString:@"r" andSize:StartStringSize]);
    XCTAssertGreaterThanOrEqual(startButton.size.width,
                   sBounds.size.width + (2 * tBounds.size.width) + aBounds.size.width + rBounds.size.width);
}

@end

@interface StartButtonWithMocksTests : XCTestCase
@end

@implementation StartButtonWithMocksTests

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

// Using a mock so that the next position value is not modified during the addEmitters function
- (void)testTheNextLetterPositionValueStartsAtZero {
    id aspMock = OCMClassMock([AttributedStringPath class]);
    StartButton *startButton = [[StartButton alloc] initWithAttributedStringPath:aspMock];
    XCTAssertEqual([startButton nextLetterPosition].x, CGPointZero.x);
    XCTAssertEqual([startButton nextLetterPosition].y, CGPointZero.y);
}

@end

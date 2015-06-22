//
//  StartButtonTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/30/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "StartButton.h"
#import "Constants.h"
#import "LayoutMath.h"
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "FakeTargetScene.h"
#import "CGMatchers.h"

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
    XCTAssertNotNil([startButton attributedStringPath]);
}

- (void)testTheNumberOfChildNodesIsEqualToTheNumberLettersInString {
    XCTAssertEqual(startButton.children.count, 5);
}

- (void)testNodesAddedAreOfTypeSKEmitter {
    SKNode *node = [[startButton children] objectAtIndex:0];
    XCTAssertTrue([node isKindOfClass:[SKEmitterNode class]]);
}

- (void)testTheStartButtonEmittersLoadFromTheOrangeSmokePNG {
    XCTAssertNotEqual([s_node.particleTexture.description rangeOfString:@"StartSmoke.png"].location, NSNotFound);
}

- (void)testTheStartButtonEmittersHaveARepeatAction {
    XCTAssertNotEqual([s_node.particleAction.description rangeOfString:@"SKRepeat"].location, NSNotFound);
}

- (void)testTheLetter_s_IsPlacedAtZero {
    XCTAssertTrue(CGPointEqualToPoint(s_node.frame.origin, CGPointZero));
}

- (void)testTheFirst_t_LetterIsPlacedAtAnXPositionTenGreaterThanTheWidthOfThe_s_Letter {
    CGPathRef sPath = [startButton.attributedStringPath createPathWithString:@"s" andSize:StartStringSize];
    CGRect sBounds = CGPathGetBoundingBox(sPath);
    CGPoint expectedOrigin = CGPointMake(10 + sBounds.origin.x + sBounds.size.width, 0);
    
    XCTAssertEqualPoints(t_node.frame.origin, expectedOrigin);
}

- (void)testThe_a_LetterIsPlacedAtAnXPositionTwentyGreaterThanTheWidthOfThe_s_And_t_Letters {
    CGPathRef sPath = [startButton.attributedStringPath createPathWithString:@"s" andSize:StartStringSize];
    CGPathRef tPath = [startButton.attributedStringPath createPathWithString:@"t" andSize:StartStringSize];
    CGRect sBounds = CGPathGetBoundingBox(sPath);
    CGRect tBounds = CGPathGetBoundingBox(tPath);
    CGPoint expectedOrigin = CGPointMake(10 + sBounds.origin.x + sBounds.size.width +
                                         10 + tBounds.origin.x + tBounds.size.width, 0);
    
    XCTAssertEqualPoints(a_node.frame.origin, expectedOrigin);
}

- (void)testTheStartButtonHasHeightEqualOrGreaterThanItsTallestChildPath {
    CGPathRef tPath = [startButton.attributedStringPath createPathWithString:@"t" andSize:StartStringSize];
    CGRect tBounds = CGPathGetBoundingBox(tPath);
    
    XCTAssertGreaterThanOrEqual(startButton.size.height, tBounds.size.height);
}

- (void)testTheStartButtonHasWidthEqualOrGreaterThanItsCombinedChildrenPathsAndOffsets {
    CGRect sBounds = CGPathGetBoundingBox([startButton.attributedStringPath createPathWithString:@"s" andSize:StartStringSize]);
    CGRect tBounds = CGPathGetBoundingBox([startButton.attributedStringPath createPathWithString:@"t" andSize:StartStringSize]);
    CGRect aBounds = CGPathGetBoundingBox([startButton.attributedStringPath createPathWithString:@"a" andSize:StartStringSize]);
    CGRect rBounds = CGPathGetBoundingBox([startButton.attributedStringPath createPathWithString:@"r" andSize:StartStringSize]);
    float sumOfWidths = sBounds.size.width + (2 * tBounds.size.width) + aBounds.size.width + rBounds.size.width;
    sumOfWidths += (4 * ButtonOffsetMultiplier * LetterHoriztontalOffset);
    
    XCTAssertGreaterThanOrEqual(startButton.size.width, sumOfWidths);
}

- (void)testTheAnchorPointIsAtZero {
    XCTAssertEqualPoints(startButton.anchorPoint, CGPointZero);
}

@end

@interface StartButtonWithMocksTests : XCTestCase {
    StartButton *startButton;
}
@end

@implementation StartButtonWithMocksTests

- (void)setUp {
    [super setUp];
    startButton = [[StartButton alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testAPathWithFontSizeOneHundredTwentyFiveIsCreatedForEachLetter {
    LetterConverter *lcObject = [[LetterConverter alloc] init];
    id lcMock = OCMPartialMock(lcObject);
    
    AttributedStringPath *stringPath = [[AttributedStringPath alloc] initWithLetterConverter:lcMock];
    StartButton *buttonWithMockLetterConverter = [[StartButton alloc] initWithAttributedStringPath:stringPath];
    
    XCTAssertNotNil(buttonWithMockLetterConverter);
    XCTAssertEqualWithAccuracy(StartStringSize, 125.0, 0.0);
    
    OCMVerify([lcMock createPathFromString:@"s" andSize:StartStringSize]);
    OCMVerify([lcMock createPathFromString:@"t" andSize:StartStringSize]);
    OCMVerify([lcMock createPathFromString:@"a" andSize:StartStringSize]);
    OCMVerify([lcMock createPathFromString:@"r" andSize:StartStringSize]);
    OCMVerify([lcMock createPathFromString:@"t" andSize:StartStringSize]);
}

// Using a mock so that the next position value is not modified during the addEmitters function
- (void)testTheNextLetterPositionValueStartsAtZero {
    id aspMock = OCMClassMock([AttributedStringPath class]);
    StartButton *buttonWithMockAttrStringPath = [[StartButton alloc] initWithAttributedStringPath:aspMock];
    XCTAssertEqualPoints([buttonWithMockAttrStringPath nextLetterPosition], CGPointZero);
}

@end

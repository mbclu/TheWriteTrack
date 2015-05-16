//
//  ATests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 3/31/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "A.h"
#import "CocoaLumberjack.h"
#import "GenericSpriteButton.h"
#import "PathInfo.h"

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "CocoaLumberjack.h"
#import "CGMatchers.h"

FOUNDATION_EXPORT CGFloat const GapCheckAccuracy;
const CGFloat GapCheckAccuracy = 1.0;

@interface A_Tests : XCTestCase {
    A *a;
    SKShapeNode *theLetterNode;
    SKSpriteNode *theTrainNode;
}

@end

@implementation A_Tests

- (void)setUp {
    [super setUp];
    a = [[A alloc] initWithSize:[UIScreen mainScreen].bounds.size AndLetter:@"A"];
    theLetterNode = (SKShapeNode *)[a childNodeWithName:@"LetterNode"];
    theTrainNode = (SKSpriteNode *)[a childNodeWithName:@"TrainNode"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testTheSceneUsesAspectScaleMode {
    XCTAssertEqual(a.scene.scaleMode, SKSceneScaleModeAspectFill);
}

- (void)testAUsesTheRockyBackground {
    SKNode *background = [a childNodeWithName:@"RockyBackground"];
    XCTAssertNotNil(background);
}

- (void)testAIsNamedA {
    XCTAssertEqualObjects(a.name, @"A");
}

- (void)testAnSKPathNodeExistsAsAChildOfTheScene {
    SKNode *letterNodeDeclaredWithBaseClassType = [a childNodeWithName:@"LetterNode"];
    XCTAssertNotNil(letterNodeDeclaredWithBaseClassType);
    XCTAssertTrue([theLetterNode isKindOfClass:[SKShapeNode class]]);
}

- (void)testThePathNodeUsesTheLetterA {
    AttributedStringPath *expectedStringPath = [[AttributedStringPath alloc] initWithString:@"A"];
    CGPathRef actualPath = [(SKShapeNode *)([a childNodeWithName:@"LetterNode"]) path];
    XCTAssertTrue(CGPathEqualToPath(actualPath, expectedStringPath.letterPath));
}

- (void)testTheLetterPathIsHorizontallyCenteredInTheScene {
    CGFloat leftGap = theLetterNode.frame.origin.x;
    CGFloat rightGap = a.frame.size.width - theLetterNode.frame.size.width - theLetterNode.frame.origin.x;
    XCTAssertEqualWithAccuracy(leftGap, rightGap, GapCheckAccuracy);
}

- (void)testTheLetterPathIsVerticallyCenteredInTheScene {
    CGFloat topGap = a.frame.size.height - theLetterNode.frame.size.height - theLetterNode.frame.origin.y;
    CGFloat bottomGap = theLetterNode.frame.origin.y;
    XCTAssertEqualWithAccuracy(topGap, bottomGap, GapCheckAccuracy);
}

- (void)testTheLetterPathHasALineWidthOfTen {
    XCTAssertEqual(theLetterNode.lineWidth, 10);
}

- (void)testForThePresenceOfATrainNode {
    XCTAssertNotNil(theTrainNode);
}

- (void)testTrainNodeForMagicTrainTexture {
    XCTAssertTrue([theTrainNode.description containsString:@"MagicTrain"]);
}

- (void)testTheNextButtonTouchesUpIsHookedToTheLetter_B_Scene {
    id mockButton = OCMClassMock([GenericSpriteButton class]);
    [a setNextButtonProperty:mockButton];
    [a connectSceneTransition];
    OCMVerify([mockButton setTouchUpInsideTarget:a action:[OCMArg anySelector]]);
}

- (void)testPressingTheNextButtonSendsAMessageToTheTransitionToNextSceneAction {
    id mockA = OCMPartialMock(a);
    DDLogInfo(@"Next Button Position on A Scene : %@", NSStringFromCGPoint(a.nextButtonProperty.position));
    [a.nextButtonProperty evaluateTouchAtPoint:a.nextButtonProperty.position];
    OCMVerify([mockA transitionToNextScene]);
}

@end

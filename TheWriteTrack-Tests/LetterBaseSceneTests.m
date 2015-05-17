//
//  _BaseTrackTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/11/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LetterBaseScene.h"

#import "AttributedStringPath.h"
#import "GenericSpriteButton.h"
#import "CGMatchers.h"
#import "CocoaLumberjack.h"

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

NSString *const RockyBackground = @"RockyBackground";
NSString *const NextButton = @"NextButton";
NSString *const Letter = @"LetterNode";
NSString *const Train = @"TrainNode";

CGFloat const GapCheckAccuracy = 1.0;
CGFloat const ArbitrarySceneWidth = 300;
CGFloat const ArbitrarySceneHeight = 200;

@interface LetterBaseSceneTests : XCTestCase {
    LetterBaseScene *theScene;
    SKSpriteNode *theBackgroundNode;
    SKSpriteNode *theNextButtonNode;
    SKShapeNode *theLetterNode;
    SKSpriteNode *theTrainNode;
}

@end

@implementation LetterBaseSceneTests

- (void)setUp {
    [super setUp];
    theScene = [[LetterBaseScene alloc]initWithSize:CGSizeMake(ArbitrarySceneWidth, ArbitrarySceneHeight) AndLetter:@"A"];
    theBackgroundNode = (SKSpriteNode *)[theScene childNodeWithName:RockyBackground];
    theNextButtonNode = (SKSpriteNode *)[theScene childNodeWithName:NextButton];
    theLetterNode = (SKShapeNode *)[theScene childNodeWithName:Letter];
    theTrainNode = (SKSpriteNode *)[theScene childNodeWithName:Train];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testTheBaseSceneIsComprisedOfARockyBackground {
    XCTAssertNotNil(theBackgroundNode);
}

- (void)testTheBaseSceneBackgroundIsAnchoredAtZero {
    XCTAssertEqual(theBackgroundNode.anchorPoint.x, CGPointZero.x);
    XCTAssertEqual(theBackgroundNode.anchorPoint.y, CGPointZero.y);
}

- (void)testTheSceneUsesTheFillAspectScaleMode {
    XCTAssertEqual(theScene.scaleMode, SKSceneScaleModeAspectFill);
}

- (void)testTheRockyBackgroundIsComprisedOfTheRockyBackgroundPNG {
    XCTAssertTrue([theBackgroundNode.texture.description containsString:RockyBackground]);
}

- (void)testForANextLetterButton {
    XCTAssertNotNil(theNextButtonNode);
}

- (void)testTheNextButtonIsComprisedOfTheNextButtonImage {
    XCTAssertTrue([theNextButtonNode.texture.description containsString:NextButton]);
}

- (void)testTheNextButtonIsAnchoredAtZero {
    XCTAssertEqualPoints(theNextButtonNode.anchorPoint, CGPointZero);
}

- (void)testTheNextButtonsXPositionIsAtTenLessThanTheDifferenceInWidth {
    XCTAssertEqual(theNextButtonNode.position.x, theScene.size.width - theNextButtonNode.size.width - 10);
}

- (void)testTheNextButtonIsVerticallyCentered {
    XCTAssertEqual(theNextButtonNode.position.y, (theScene.size.height - theNextButtonNode.size.height) * 0.5);
}

- (void)testTheNextButtonIsDerivedOfTheGenericSpriteButton {
    XCTAssertTrue([theNextButtonNode isKindOfClass:[GenericSpriteButton class]]);
}

- (void)testTheSceneUsesAspectScaleMode {
    XCTAssertEqual(theScene.scene.scaleMode, SKSceneScaleModeAspectFill);
}

- (void)testTheNameOfTheSceneMatchesTheNameOfTheInitializerConstant {
    NSString *LetterToInitWith = @"K";
    theScene = [[LetterBaseScene alloc]initWithSize:CGSizeMake(ArbitrarySceneWidth, ArbitrarySceneHeight) AndLetter:LetterToInitWith];
    XCTAssertEqualObjects(theScene.name, LetterToInitWith);
}

- (void)testAnSKPathNodeExistsAsAChildOfTheScene {
    SKNode *letterNodeDeclaredWithBaseClassType = [theScene childNodeWithName:Letter];
    XCTAssertNotNil(letterNodeDeclaredWithBaseClassType);
    XCTAssertTrue([theLetterNode isKindOfClass:[SKShapeNode class]]);
}

- (void)testWhenInitializedWith_T_ThePathNodeUsesTheLetter_T {
    NSString *AString = @"T";
    theScene = [[LetterBaseScene alloc]initWithSize:CGSizeMake(ArbitrarySceneWidth, ArbitrarySceneHeight) AndLetter:AString];
    AttributedStringPath *expectedStringPath = [[AttributedStringPath alloc] initWithString:AString];
    CGPathRef actualPath = [(SKShapeNode *)([theScene childNodeWithName:@"LetterNode"]) path];
    XCTAssertTrue(CGPathEqualToPath(actualPath, expectedStringPath.letterPath));
}

- (void)testWhenTheSceneIsTheSizeOfAFullScreenThenTheLetterPathIsHorizontallyCenteredInTheScene {
    theScene = [[LetterBaseScene alloc]initWithSize:[UIScreen mainScreen].bounds.size AndLetter:@"A"];
    CGFloat leftGap = theLetterNode.frame.origin.x;
    CGFloat rightGap = theScene.frame.size.width - theLetterNode.frame.size.width - theLetterNode.frame.origin.x;
    XCTAssertEqualWithAccuracy(leftGap, rightGap, GapCheckAccuracy);
}

- (void)testWhenTheSceneIsTheSizeOfAFullScreenThenTheLetterPathIsVerticallyCenteredInTheScene {
    theScene = [[LetterBaseScene alloc]initWithSize:[UIScreen mainScreen].bounds.size AndLetter:@"A"];
    CGFloat topGap = theScene.frame.size.height - theLetterNode.frame.size.height - theLetterNode.frame.origin.y;
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
    [theScene setNextButtonProperty:mockButton];
    [theScene connectSceneTransition];
    OCMVerify([mockButton setTouchUpInsideTarget:theScene action:[OCMArg anySelector]]);
}

- (void)testPressingTheNextButtonSendsAMessageToTheTransitionToNextSceneAction {
    id mockA = OCMPartialMock(theScene);
    DDLogInfo(@"Next Button Position on A Scene : %@", NSStringFromCGPoint(theScene.nextButtonProperty.position));
    [theScene.nextButtonProperty evaluateTouchAtPoint:theScene.nextButtonProperty.position];
    OCMVerify([mockA transitionToNextScene]);
}

@end

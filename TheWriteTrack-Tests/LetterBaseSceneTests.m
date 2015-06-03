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
#import "Train.h"

#import "CGMatchers.h"
#import "CocoaLumberjack.h"

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

NSString *const RockyBackground = @"RockyBackground";
NSString *const NextButton = @"NextButton";
NSString *const PrevButton = @"PreviousButton";
NSString *const Letter = @"LetterNode";
NSString *const TheTrain = @"TrainNode";

CGFloat const GapCheckAccuracy = 3.0;
CGFloat const ArbitrarySceneWidth = 300;
CGFloat const ArbitrarySceneHeight = 200;

@interface LetterBaseSceneTests : XCTestCase {
    LetterBaseScene *theScene;
    SKSpriteNode *theBackgroundNode;
    SKSpriteNode *theNextButtonNode;
    SKSpriteNode *thePrevButtonNode;
    SKShapeNode *theLetterNode;
    SKSpriteNode *theTrainNode;
}

@end

@implementation LetterBaseSceneTests

- (void)setUp {
    [super setUp];
    theScene = [[LetterBaseScene alloc]initWithSize:CGSizeMake(ArbitrarySceneWidth, ArbitrarySceneHeight) AndLetter:@"B"];
    theBackgroundNode = (SKSpriteNode *)[theScene childNodeWithName:RockyBackground];
    theNextButtonNode = (SKSpriteNode *)[theScene childNodeWithName:NextButton];
    thePrevButtonNode = (SKSpriteNode *)[theScene childNodeWithName:PrevButton];
    theLetterNode = (SKShapeNode *)[theScene childNodeWithName:Letter];
    theTrainNode = (SKSpriteNode *)[theScene childNodeWithName:TheTrain];
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

- (void)testTheSizeOfTheBackgroundIsTheSameAsTheSceneSize {
    XCTAssertEqualSizes(theBackgroundNode.size, theScene.size);
}

- (void)testTheNameOfTheSceneMatchesTheNameOfTheInitializerConstant {
    NSString *LetterToInitWith = @"K";
    LetterBaseScene *anotherScene = [[LetterBaseScene alloc]initWithSize:CGSizeMake(ArbitrarySceneWidth, ArbitrarySceneHeight) AndLetter:LetterToInitWith];
    XCTAssertEqualObjects(anotherScene.name, LetterToInitWith);
}

- (void)testForThePresenceOfATrainNode {
    XCTAssertNotNil(theTrainNode);
}

//- (void)testTheTrainNodeGetsPassedTheLetterStringPath {
//    Train *train = (Train *)theTrainNode;
//    XCTAssertFalse(CGPathIsEmpty(train.letterPath));
//}

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

- (void)testTheNextButtonTouchesUpIsHookedToTheLetter_B_Scene {
    id mockButton = OCMClassMock([GenericSpriteButton class]);
    [theScene setNextButtonProperty:mockButton];
    [theScene connectSceneTransitions];
    OCMVerify([mockButton setTouchUpInsideTarget:theScene action:[OCMArg anySelector]]);
}

- (void)testPressingTheNextButtonSendsAMessageToTheTransitionToNextSceneAction {
    id mockScene = OCMPartialMock(theScene);
    DDLogDebug(@"Next Button Position on Scene : %@", NSStringFromCGPoint(theScene.nextButtonProperty.position));
    [theScene.nextButtonProperty evaluateTouchAtPoint:theScene.nextButtonProperty.position];
    OCMVerify([mockScene transitionToNextScene]);
}

- (void)testWhenTheLetterIsCapitalZThenNoNextButtonIsAvailable {
    LetterBaseScene *zScene = [[LetterBaseScene alloc] initWithSize:CGSizeMake(ArbitrarySceneWidth, ArbitrarySceneHeight) AndLetter:@"Z"];
    XCTAssertNil([zScene childNodeWithName:NextButton]);
}

- (void)testForAPreviousLetterButton {
    XCTAssertNotNil(thePrevButtonNode);
}

- (void)testThePreviousButtonIsComprisedOfThePreviousButtonImage {
    XCTAssertTrue([thePrevButtonNode.texture.description containsString:PrevButton]);
}

- (void)testThePrevButtonIsAnchoredAtZero {
    XCTAssertEqualPoints(thePrevButtonNode.anchorPoint, CGPointZero);
}

- (void)testThePrevButtonsXPositionIsAtTenMoreThanTheSceneXOrigin {
    XCTAssertEqual(thePrevButtonNode.position.x, theScene.frame.origin.x + 10);
}

- (void)testThePrevButtonIsVerticallyCentered {
    XCTAssertEqual(thePrevButtonNode.position.y, (theScene.size.height - thePrevButtonNode.size.height) * 0.5);
}

- (void)testThePrevButtonIsDerivedOfTheGenericSpriteButton {
    XCTAssertTrue([thePrevButtonNode isKindOfClass:[GenericSpriteButton class]]);
}

- (void)testThePrevButtonTouchesUpIsHookedToTheLetter_B_Scene {
    id mockButton = OCMClassMock([GenericSpriteButton class]);
    [theScene setPreviousButtonProperty:mockButton];
    [theScene connectSceneTransitions];
    OCMVerify([mockButton setTouchUpInsideTarget:theScene action:[OCMArg anySelector]]);
}

- (void)testPressingThePrevButtonSendsAMessageToTheTransitionToPrevSceneAction {
    id mockScene = OCMPartialMock(theScene);
    DDLogDebug(@"Prev Button Position on Scene : %@", NSStringFromCGPoint(theScene.previousButtonProperty.position));
    [theScene.previousButtonProperty evaluateTouchAtPoint:theScene.previousButtonProperty.position];
    OCMVerify([mockScene transitionToPreviousScene]);
}

- (void)testWhenTheLetterIsCapitalAThenNoPrevButtonIsAvailable {
    LetterBaseScene *zScene = [[LetterBaseScene alloc] initWithSize:CGSizeMake(ArbitrarySceneWidth, ArbitrarySceneHeight) AndLetter:@"A"];
    XCTAssertNil([zScene childNodeWithName:PrevButton]);
}

//- (void)testAShapeNodeIsAddedForTheLetterTrack {
//    SKNode *shape = [theScene childNodeWithName:@"LetterNode"];
//    XCTAssertNotNil(shape);
//    XCTAssertTrue([shape isKindOfClass:[SKShapeNode class]]);
//    // Test color?
//    // Test strokeWidth?
//}

- (void)testAnOutlineShapeNodeIsAddedForTheLetterTrack {
    SKNode *outline = [theScene childNodeWithName:@"LetterOutlineNode"];
    XCTAssertNotNil(outline);
    XCTAssertTrue([outline isKindOfClass:[SKShapeNode class]]);
    // Test color?
    // Test strokeWidth?
}

- (void)testTheCrossbarsAreAddedToTheLetterTrack {
    NSUInteger initialChildCount = theScene.children.count;
    id mockScene = OCMPartialMock(theScene);
    
    SKShapeNode *crossbar1 = [[SKShapeNode alloc] init];
    SKShapeNode *crossbar2 = [[SKShapeNode alloc] init];
    SKShapeNode *crossbar3 = [[SKShapeNode alloc] init];
    
    [theScene addCrossbars:[NSArray arrayWithObjects:crossbar1, crossbar2, crossbar3, nil]];
    
    OCMVerify([mockScene addChild:crossbar1]);
    OCMVerify([mockScene addChild:crossbar2]);
    OCMVerify([mockScene addChild:crossbar3]);
    XCTAssertEqual(theScene.children.count, initialChildCount + 3);
}

- (void)testTheWaypointsAreAddedToTheLetterTrack {
    NSUInteger initialChildCount = theScene.children.count;
    
    CGPoint waypoint1 = CGPointMake(0, 10);
    CGPoint waypoint2 = CGPointMake(10, 0);
    
    [theScene addWaypoints:[NSArray arrayWithObjects:
                            [NSValue valueWithCGPoint:waypoint1],
                            [NSValue valueWithCGPoint:waypoint2],
                            nil]];
    
    XCTAssertEqual(theScene.children.count, initialChildCount + 2);
}

@end

@interface LetterBaseSceneLetterPathTests : XCTestCase

@end

@implementation LetterBaseSceneLetterPathTests

#define PERFORM_HORIZONTAL_CENTER_TEST    0
#if (PERFORM_HORIZONTAL_CENTER_TEST)
- (void)testWhenTheSceneIsTheSizeOfAFullScreenThenTheLetterPathIsHorizontallyCenteredInTheScene {
    unichar unicharRepOfLetter = [@"A" characterAtIndex:0];
    while (unicharRepOfLetter <= [@"Z" characterAtIndex:0]) {
        LetterBaseScene *scene = [[LetterBaseScene alloc]initWithSize:[UIScreen mainScreen].bounds.size
                                                            AndLetter:[NSString stringWithCharacters:&unicharRepOfLetter length:1]];
        SKShapeNode *letterNode = (SKShapeNode *)[scene childNodeWithName:Letter];
        CGFloat leftGap = letterNode.frame.origin.x;
        CGFloat rightGap = scene.frame.size.width - letterNode.frame.size.width - letterNode.frame.origin.x;
        XCTAssertEqualWithAccuracy(leftGap, rightGap, GapCheckAccuracy, @"Letter %c Does not meet the Horizontal Alignment Standard", unicharRepOfLetter);
        unicharRepOfLetter = (unichar)(unicharRepOfLetter + 1);
    }
}
#endif

#define PERFORM_VERTICAL_CENTER_TEST    0
#if (PERFORM_VERTICAL_CENTER_TEST)
- (void)testWhenTheSceneIsTheSizeOfAFullScreenThenTheLetterPathIsVerticallyCenteredInTheScene {
    unichar unicharRepOfLetter = [@"A" characterAtIndex:0];
    while (unicharRepOfLetter <= [@"Z" characterAtIndex:0]) {
        LetterBaseScene *scene = [[LetterBaseScene alloc]initWithSize:[UIScreen mainScreen].bounds.size
                                                            AndLetter:[NSString stringWithCharacters:&unicharRepOfLetter length:1]];
        SKShapeNode *letterNode = (SKShapeNode *)[scene childNodeWithName:Letter];
        CGFloat topGap = scene.frame.size.height - letterNode.frame.size.height - letterNode.frame.origin.y;
        CGFloat bottomGap = letterNode.frame.origin.y;
        XCTAssertEqualWithAccuracy(topGap, bottomGap, GapCheckAccuracy, @"Letter %c Does not meet the Vertical Alignment Standard", unicharRepOfLetter);
        unicharRepOfLetter = (unichar)(unicharRepOfLetter + 1);
    }
}
#endif

@end

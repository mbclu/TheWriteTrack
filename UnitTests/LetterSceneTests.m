//
//  LetterSceneTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/11/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LetterScene.h"

#import "AttributedStringPath.h"
#import "GenericSpriteButton.h"
#import "PathSegments.h"
#import "LayoutMath.h"
#import "Train.h"

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "CGMatchers.h"

CGFloat const GapCheckAccuracy = 1.0;
CGFloat const ArbitrarySceneWidth = 400;
CGFloat const ArbitrarySceneHeight = 400;
NSString *const BackgroundName = @"RockyBackground";
NSString *const ContainerNodeName = @"TrackContainerNode";
NSString *const LetterSelectNodeName = @"LetterSelectButton";

@interface LetterSceneTests : XCTestCase {
    LetterScene *theScene;
    CGSize arbitrarySceneSize;
    NSString *letterForTest;
    SKSpriteNode *theBackgroundNode;
    TrackContainer *theContainerNode;
    SKSpriteNode *theNextButtonNode;
    SKSpriteNode *thePrevButtonNode;
    SKNode *theLetterSelectButton;
    SKSpriteNode *theSkipDemoButton;
}

@end

@implementation LetterSceneTests

- (void)setUp {
    [super setUp];
    letterForTest = @"E";
    arbitrarySceneSize = CGSizeMake(ArbitrarySceneWidth, ArbitrarySceneHeight);
    theScene = [[LetterScene alloc]initWithSize:arbitrarySceneSize andLetter:letterForTest];
    theBackgroundNode = (SKSpriteNode *)[theScene childNodeWithName:BackgroundName];
    theContainerNode = (TrackContainer *)[theScene childNodeWithName:ContainerNodeName];
    theNextButtonNode = (SKSpriteNode *)[theScene childNodeWithName:NEXT_BUTTON_NAME];
    thePrevButtonNode = (SKSpriteNode *)[theScene childNodeWithName:PREVIOUS_BUTTON_NAME];
    theLetterSelectButton = [theScene childNodeWithName:LetterSelectNodeName];
    theSkipDemoButton = (SKSpriteNode *)[theScene childNodeWithName:SKIP_DEMO_BUTTON_NAME];
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
    XCTAssertTrue([theBackgroundNode.texture.description containsString:BackgroundName]);
}

- (void)testTheSizeOfTheBackgroundIsTheSameAsTheSceneSize {
    XCTAssertEqualSizes(theBackgroundNode.size, theScene.size);
}

- (void)testTheNameOfTheSceneMatchesTheNameOfTheInitializerConstant {
    NSString *letterToInitWith = @"K";
    LetterScene *anotherScene = [[LetterScene alloc]initWithSize:CGSizeMake(ArbitrarySceneWidth, ArbitrarySceneHeight) andLetter:letterToInitWith];
    XCTAssertEqualObjects(anotherScene.name, letterToInitWith);
}

- (void)testForANextLetterButton {
    XCTAssertNotNil(theNextButtonNode);
    XCTAssertTrue([theNextButtonNode isKindOfClass:[GenericSpriteButton class]]);
}

- (void)testTheNextButtonsXPositionIsAtTenLessThanTheDifferenceInWidth {
    XCTAssertEqual(theNextButtonNode.position.x, theScene.size.width - theNextButtonNode.size.width - 10);
}

- (void)testTheNextButtonIsVerticallyCentered {
    XCTAssertEqual(theNextButtonNode.position.y, (theScene.size.height - theNextButtonNode.size.height) * 0.5);
}

- (void)testTheNextButtonTouchesUpIsHookedToTheNextSceneTransition {
    id mockButton = OCMClassMock([GenericSpriteButton class]);
    [theScene setNextButtonProperty:mockButton];
    [theScene connectSceneTransitions];
    OCMVerify([mockButton setTouchUpInsideTarget:theScene action:@selector(transitionToNextScene)]);
}

- (void)testWhenTheLetterIsCapitalZThenNoNextButtonIsAvailable {
    LetterScene *zScene = [[LetterScene alloc] initWithSize:CGSizeMake(ArbitrarySceneWidth, ArbitrarySceneHeight) andLetter:@"Z"];
    XCTAssertNil([zScene childNodeWithName:NEXT_BUTTON_NAME]);
}

- (void)testForAPreviousLetterButton {
    XCTAssertNotNil(thePrevButtonNode);
    XCTAssertTrue([thePrevButtonNode isKindOfClass:[GenericSpriteButton class]]);
}

- (void)testThePrevButtonsXPositionIsAtTenMoreThanTheSceneXOrigin {
    XCTAssertEqual(thePrevButtonNode.position.x, theScene.frame.origin.x + 10);
}

- (void)testThePrevButtonIsVerticallyCentered {
    XCTAssertEqual(thePrevButtonNode.position.y, (theScene.size.height - thePrevButtonNode.size.height) * 0.5);
}

- (void)testThePrevButtonTouchesUpIsHookedToThePreviousSceneTransition {
    id mockButton = OCMClassMock([GenericSpriteButton class]);
    [theScene setPreviousButtonProperty:mockButton];
    [theScene connectSceneTransitions];
    OCMVerify([mockButton setTouchUpInsideTarget:theScene action:@selector(transitionToPreviousScene)]);
}

- (void)testWhenTheLetterIsCapitalAThenNoPrevButtonIsAvailable {
    LetterScene *zScene = [[LetterScene alloc] initWithSize:CGSizeMake(ArbitrarySceneWidth, ArbitrarySceneHeight) andLetter:@"A"];
    XCTAssertNil([zScene childNodeWithName:PREVIOUS_BUTTON_NAME]);
}

- (void)testWhenLoadedThenAGenericButtonIsCreatedForSkippingTheDemo {
    XCTAssertNotNil(theScene.skipDemoButtonProperty);
    XCTAssertNotNil(theSkipDemoButton);
    XCTAssertTrue([theSkipDemoButton isKindOfClass:[GenericSpriteButton class]]);
}

- (void)testTheSkipButtonIsPlacedInTheUpperLeftCorner {
    XCTAssertEqualPoints(theSkipDemoButton.frame.origin, CGPointMake(20, theScene.frame.size.height - theSkipDemoButton.size.height - 20));
}

- (void)testTheBackgroundIsDrawnBeforeTheTrackContainer {
    XCTAssertLessThan(theBackgroundNode.zPosition, theContainerNode.zPosition);
}

- (void)testTheBackgroundIsDrawnBeforeTheNextButton {
    XCTAssertLessThan(theBackgroundNode.zPosition, theNextButtonNode.zPosition);
}

- (void)testTheBackgroundIsDrawnBeforeThePreviousButton {
    XCTAssertLessThan(theBackgroundNode.zPosition, thePrevButtonNode.zPosition);
}

- (void)testTheBackgroundIsDrawnBeforeTheSkipDemoButton {
    XCTAssertLessThan(theBackgroundNode.zPosition, theSkipDemoButton.zPosition);
}

- (void)testTheTrackContainerIsTheContactDelegate {
    XCTAssertEqualObjects(theScene.physicsWorld.contactDelegate, theContainerNode);
}

- (void)testForZeroGravity {
    XCTAssertEqual(theScene.physicsWorld.gravity.dx, 0.0);
    XCTAssertEqual(theScene.physicsWorld.gravity.dy, 0.0);
}

- (void)testWhenFirstEnteringASceneThenTrackContainerIsAskedToPerformADemonstration {
    id mockContainer = OCMPartialMock(theContainerNode);
    [theScene didMoveToView:nil];
    OCMVerify([mockContainer beginDemonstration]);
}

- (void)testThereIsALetterSelectionButtonOnTheScene {
    XCTAssertNotNil(theLetterSelectButton);
}

- (void)testTheLetterSelectButtonaHasGreaterZPositionThanTheBackground {
    XCTAssertGreaterThan(theLetterSelectButton.zPosition, theBackgroundNode.zPosition);
}

- (void)testTheLetterSelectButtonIsPositionedSlightlyAboveTheBottomLeftOfTheScreen {
    CGPoint expectedPosition = theScene.position;
    INCREMENT_POINT_BY_POINT(expectedPosition, CGPointMake(20, 20));
    XCTAssertEqualPoints(theLetterSelectButton.position, expectedPosition);
}

- (void)testWhenTheLetterSelectButtonIsAddedToTheSceneThenItIsConfiguredToNotifyTheLetterSelectSceneOfTransitionEvents {
    id mockButton = OCMClassMock([GenericSpriteButton class]);
    [theScene setLetterSelectButtonProperty:mockButton];
    [theScene connectSceneTransitions];
    OCMVerify([mockButton setTouchUpInsideTarget:theScene action:@selector(transitionToLetterSelectScene)]);
}

- (void)testWhenTheSkipDemoButtonIsAddedToTheSceneThenItIsConfiguredToNotifyTheTrackContainerOfButtonPressEvents {
    id mockButton = OCMClassMock([GenericSpriteButton class]);
    [theScene setSkipDemoButtonProperty:mockButton];
    [theScene connectSkipDemoAction];
    OCMVerify([mockButton setTouchUpInsideTarget:theScene action:@selector(skipDemo)]);
}

@end

@interface LetterSceneLetterCenteringTests : XCTestCase

@end

@implementation LetterSceneLetterCenteringTests

- (void)testWhenTheSceneIsTheSizeOfAFullScreenThenTheLetterPathIsHorizontallyCenteredInTheScene {
    unichar unicharRepOfLetter = [@"A" characterAtIndex:0];
    
    while (unicharRepOfLetter <= [@"Z" characterAtIndex:0]) {
        LetterScene *scene = [[LetterScene alloc] initWithSize:[UIScreen mainScreen].bounds.size
                                                     andLetter:[NSString stringWithCharacters:&unicharRepOfLetter length:1]];
        
        SKShapeNode *trackOutlineNode = (SKShapeNode *)[[scene childNodeWithName:ContainerNodeName] childNodeWithName:LetterOutlineName];
        CGRect pathBoundingBox = CGPathGetPathBoundingBox(trackOutlineNode.path);
        
        if ( ! CGRectIsNull(pathBoundingBox) ) {
            CGRect pathBoundingBox = CGPathGetPathBoundingBox(trackOutlineNode.path);
            CGPoint parentCoordinatesPoint = [trackOutlineNode convertPoint:pathBoundingBox.origin toNode:trackOutlineNode.parent.parent];
            CGFloat leftGap = parentCoordinatesPoint.x;
            CGFloat rightGap = scene.frame.size.width - parentCoordinatesPoint.x - pathBoundingBox.size.width;
        
            XCTAssertEqualWithAccuracy(leftGap, rightGap, GapCheckAccuracy, @"Letter %c Does not meet the Horizontal Alignment Standard", unicharRepOfLetter);
        }
        
        unicharRepOfLetter = (unichar)(unicharRepOfLetter + 1);
    }
}

- (void)testWhenTheSceneIsTheSizeOfAFullScreenThenTheLetterPathIsVerticallyCenteredInTheScene {
    unichar unicharRepOfLetter = [@"A" characterAtIndex:0];
    
    while (unicharRepOfLetter <= [@"Z" characterAtIndex:0]) {
        LetterScene *scene = [[LetterScene alloc] initWithSize:[UIScreen mainScreen].bounds.size
                                                     andLetter:[NSString stringWithCharacters:&unicharRepOfLetter length:1]];
        
        SKShapeNode *trackOutlineNode = (SKShapeNode *)[[scene childNodeWithName:ContainerNodeName] childNodeWithName:LetterOutlineName];
        CGRect pathBoundingBox = CGPathGetPathBoundingBox(trackOutlineNode.path);
        
        if ( ! CGRectIsNull(pathBoundingBox) ) {
            CGPoint parentCoordinatesPoint = [trackOutlineNode convertPoint:pathBoundingBox.origin toNode:trackOutlineNode.parent.parent];
            CGFloat bottomGap = parentCoordinatesPoint.y;
            CGFloat topGap = scene.frame.size.height - parentCoordinatesPoint.y - pathBoundingBox.size.height;
            
            XCTAssertEqualWithAccuracy(bottomGap, topGap, GapCheckAccuracy, @"Letter %c Does not meet the Vertical Alignment Standard", unicharRepOfLetter);
        }
        
        unicharRepOfLetter = (unichar)(unicharRepOfLetter + 1);
    }
}

@end

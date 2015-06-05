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
#import "PathSegments.h"
#import "Train.h"

#import "CGMatchers.h"
#import "CocoaLumberjack.h"

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

CGFloat const GapCheckAccuracy = 3.0;
CGFloat const ArbitrarySceneWidth = 300;
CGFloat const ArbitrarySceneHeight = 200;
NSString *const CrossbarName = @"Crossbar";
NSString *const WaypointName = @"Waypoint";

@interface LetterBaseSceneTests : XCTestCase {
    LetterBaseScene *theScene;
    NSString *letterForTest;
    SKSpriteNode *theBackgroundNode;
    SKSpriteNode *theNextButtonNode;
    SKSpriteNode *thePrevButtonNode;
    SKShapeNode *theLetterNode;
    SKSpriteNode *theTrainNode;
    SKShapeNode *theLetterTrackOutlineNode;
}

@end

@implementation LetterBaseSceneTests

- (void)setUp {
    [super setUp];
    letterForTest = @"E";
    theScene = [[LetterBaseScene alloc]initWithSize:CGSizeMake(ArbitrarySceneWidth, ArbitrarySceneHeight) AndLetter:letterForTest];
    theBackgroundNode = (SKSpriteNode *)[theScene childNodeWithName:@"RockyBackground"];
    theNextButtonNode = (SKSpriteNode *)[theScene childNodeWithName:@"NextButton"];
    thePrevButtonNode = (SKSpriteNode *)[theScene childNodeWithName:@"PreviousButton"];
    theLetterNode = (SKShapeNode *)[theScene childNodeWithName:@"LetterNode"];
    theTrainNode = (SKSpriteNode *)[theScene childNodeWithName:@"TrainNode"];
    theLetterTrackOutlineNode = (SKShapeNode *)[theScene childNodeWithName:@"LetterOutlineNode"];
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
    XCTAssertTrue([theBackgroundNode.texture.description containsString:@"RockyBackground"]);
}

- (void)testTheSizeOfTheBackgroundIsTheSameAsTheSceneSize {
    XCTAssertEqualSizes(theBackgroundNode.size, theScene.size);
}

- (void)testTheNameOfTheSceneMatchesTheNameOfTheInitializerConstant {
    NSString *letterToInitWith = @"K";
    LetterBaseScene *anotherScene = [[LetterBaseScene alloc]initWithSize:CGSizeMake(ArbitrarySceneWidth, ArbitrarySceneHeight) AndLetter:letterToInitWith];
    XCTAssertEqualObjects(anotherScene.name, letterToInitWith);
}

- (void)testForThePresenceOfATrainNode {
    XCTAssertNotNil(theTrainNode);
}

- (void)testTheTrainNodeGetsPassedTheLetterStringPath {
    Train *train = (Train *)theTrainNode;
    XCTAssertFalse(CGPathIsEmpty(train.letterPath));
    XCTAssertTrue(CGPathEqualToPath(train.letterPath, theLetterTrackOutlineNode.path));
}

- (void)testForANextLetterButton {
    XCTAssertNotNil(theNextButtonNode);
}

- (void)testTheNextButtonIsComprisedOfTheNextButtonImage {
    XCTAssertTrue([theNextButtonNode.texture.description containsString:@"NextButton"]);
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
    XCTAssertNil([zScene childNodeWithName:@"NextButton"]);
}

- (void)testForAPreviousLetterButton {
    XCTAssertNotNil(thePrevButtonNode);
}

- (void)testThePreviousButtonIsComprisedOfThePreviousButtonImage {
    XCTAssertTrue([thePrevButtonNode.texture.description containsString:@"PreviousButton"]);
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
    XCTAssertNil([zScene childNodeWithName:@"PreviousButton"]);
}

- (void)testAnOutlineShapeNodeIsAddedForTheLetterTrack {
    SKNode *outline = [theScene childNodeWithName:@"LetterOutlineNode"];
    XCTAssertNotNil(outline);
    XCTAssertTrue([outline isKindOfClass:[SKShapeNode class]]);
    // Test color?
    // Test strokeWidth?
}

- (void)testTheNumberOfCrossbarsAddedIsEqualToTheNumberOfCrossbarsOnTheTrainPath {
    NSUInteger initialChildCount = theScene.children.count;
    PathSegments *pathSegments = [[PathSegments alloc] init];
    [pathSegments generateCombinedPathAndCrossbarsForLetter:letterForTest atCenter:CGPointZero];
    [theScene addCrossbars:pathSegments.crossbars];
    XCTAssertEqual(theScene.children.count, initialChildCount + pathSegments.crossbars.count);

}

- (void)testTheWaypointsAreAddedToTheLetterTrackAsNodes {
    NSUInteger initialChildCount = theScene.children.count;
    
    CGPoint waypoint1 = CGPointMake(0, 10);
    CGPoint waypoint2 = CGPointMake(10, 0);
    
    [theScene addWaypoints:[NSArray arrayWithObjects:
                            [NSValue valueWithCGPoint:waypoint1],
                            [NSValue valueWithCGPoint:waypoint2],
                            nil]];
    
    XCTAssertEqual(theScene.children.count, initialChildCount + 2);
}

- (void)testTheBackgroundIsDrawnBeforeTheTrackOutline {
    XCTAssertLessThan(theBackgroundNode.zPosition, theLetterTrackOutlineNode.zPosition);
}

- (void)testTheBackgroundIsDrawnBeforeTheNextButton {
    XCTAssertLessThan(theBackgroundNode.zPosition, theNextButtonNode.zPosition);
}

- (void)testTheBackgroundIsDrawnBeforeThePreviousButton {
    XCTAssertLessThan(theBackgroundNode.zPosition, thePrevButtonNode.zPosition);
}

- (void)testTheTrackOutlineIsDrawnBeforeTheCrossbars {
    NSArray *sceneChildren = [theScene children];
    
    XCTAssertNotNil([theScene childNodeWithName:CrossbarName]);
    
    [sceneChildren enumerateObjectsWithOptions:NSEnumerationConcurrent
                                    usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                        SKNode *crossbarNode = (SKNode *)obj;
                                        if ([crossbarNode.name isEqualToString:CrossbarName]) {
                                            XCTAssertLessThan(theLetterTrackOutlineNode.zPosition, crossbarNode.zPosition);
                                        }
                                    }];
}

- (void)testTheTheCrossbarsAreDrawnBeforeTheWaypoints {
    SKNode *aCrossbar = (SKNode *)[theScene childNodeWithName:CrossbarName];
    NSArray *sceneChildren = [theScene children];
    
    XCTAssertNotNil([theScene childNodeWithName:WaypointName]);
    
    [sceneChildren enumerateObjectsWithOptions:NSEnumerationConcurrent
                                    usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                        SKNode *waypointNode = (SKNode *)obj;
                                        if ([waypointNode.name isEqualToString:WaypointName]) {
                                            XCTAssertLessThan(aCrossbar.zPosition, waypointNode.zPosition);
                                        }
                                    }];
}

- (void)testTheWaypointsAreDrawnBeforeTheTrain {
    SKNode *aWaypoint = (SKNode *)[theScene childNodeWithName:WaypointName];
    XCTAssertLessThan(aWaypoint.zPosition, theTrainNode.zPosition);
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

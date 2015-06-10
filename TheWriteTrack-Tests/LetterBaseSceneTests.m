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
#import "LayoutMath.h"
#import "Train.h"

#import "CGMatchers.h"
#import "CocoaLumberjack.h"

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

CGFloat const GapCheckAccuracy = 1.0;
CGFloat const ArbitrarySceneWidth = 300;
CGFloat const ArbitrarySceneHeight = 200;
NSString *const CrossbarName = @"Crossbar";
NSString *const WaypointName = @"Waypoint";
NSString *const OutlineNodeName = @"LetterOutlineNode";
NSString *const ContainerNodeName = @"TrackContainerNode";
NSString *const NextButtonNodeName = @"NextButton";
NSString *const PreviousButtonNodeName = @"PreviousButton";

@interface LetterBaseSceneTests : XCTestCase {
    LetterBaseScene *theScene;
    CGSize arbitrarySceneSize;
    NSString *letterForTest;
    SKSpriteNode *theBackgroundNode;
    SKSpriteNode *theNextButtonNode;
    SKSpriteNode *thePrevButtonNode;
    SKNode *theContainerNode;
    SKShapeNode *theLetterNode;
    SKSpriteNode *theTrainNode;
    SKShapeNode *theLetterTrackOutlineNode;
}

@end

@implementation LetterBaseSceneTests

- (void)setUp {
    [super setUp];
    letterForTest = @"E";
    arbitrarySceneSize = CGSizeMake(ArbitrarySceneWidth, ArbitrarySceneHeight);
    theScene = [[LetterBaseScene alloc]initWithSize:arbitrarySceneSize andLetter:letterForTest];
    theBackgroundNode = (SKSpriteNode *)[theScene childNodeWithName:@"RockyBackground"];
    theNextButtonNode = (SKSpriteNode *)[theScene childNodeWithName:NextButtonNodeName];
    thePrevButtonNode = (SKSpriteNode *)[theScene childNodeWithName:PreviousButtonNodeName];
    theContainerNode = [theScene childNodeWithName:ContainerNodeName];
    theTrainNode = (SKSpriteNode *)[theContainerNode childNodeWithName:@"TrainNode"];
    theLetterTrackOutlineNode = (SKShapeNode *)[theContainerNode childNodeWithName:OutlineNodeName];
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
    LetterBaseScene *anotherScene = [[LetterBaseScene alloc]initWithSize:CGSizeMake(ArbitrarySceneWidth, ArbitrarySceneHeight) andLetter:letterToInitWith];
    XCTAssertEqualObjects(anotherScene.name, letterToInitWith);
}

- (void)testForANextLetterButton {
    XCTAssertNotNil(theNextButtonNode);
}

- (void)testTheNextButtonIsComprisedOfTheNextButtonImage {
    XCTAssertTrue([theNextButtonNode.texture.description containsString:NextButtonName]);
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

- (void)testTheNextButtonTouchesUpIsHookedToTheNextSceneTransition {
    id mockButton = OCMClassMock([GenericSpriteButton class]);
    [theScene setNextButtonProperty:mockButton];
    [theScene connectSceneTransitions];
    OCMVerify([mockButton setTouchUpInsideTarget:theScene action:@selector(transitionToNextScene)]);
}

- (void)testPressingTheNextButtonSendsAMessageToTheTransitionToNextSceneAction {
    id mockScene = OCMPartialMock(theScene);
    DDLogDebug(@"Next Button Position on Scene : %@", NSStringFromCGPoint(theScene.nextButtonProperty.position));
    [theScene.nextButtonProperty evaluateTouchAtPoint:theScene.nextButtonProperty.position];
    OCMVerify([mockScene transitionToNextScene]);
}

- (void)testWhenTheLetterIsCapitalZThenNoNextButtonIsAvailable {
    LetterBaseScene *zScene = [[LetterBaseScene alloc] initWithSize:CGSizeMake(ArbitrarySceneWidth, ArbitrarySceneHeight) andLetter:@"Z"];
    XCTAssertNil([zScene childNodeWithName:NextButtonName]);
}

- (void)testForAPreviousLetterButton {
    XCTAssertNotNil(thePrevButtonNode);
}

- (void)testThePreviousButtonIsComprisedOfThePreviousButtonImage {
    XCTAssertTrue([thePrevButtonNode.texture.description containsString:PreviousButtonNodeName]);
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

- (void)testThePrevButtonTouchesUpIsHookedToThePreviousSceneTransition {
    id mockButton = OCMClassMock([GenericSpriteButton class]);
    [theScene setPreviousButtonProperty:mockButton];
    [theScene connectSceneTransitions];
    OCMVerify([mockButton setTouchUpInsideTarget:theScene action:@selector(transitionToPreviousScene)]);
}

- (void)testPressingThePrevButtonSendsAMessageToTheTransitionToPrevSceneAction {
    id mockScene = OCMPartialMock(theScene);
    DDLogDebug(@"Prev Button Position on Scene : %@", NSStringFromCGPoint(theScene.previousButtonProperty.position));
    [theScene.previousButtonProperty evaluateTouchAtPoint:theScene.previousButtonProperty.position];
    OCMVerify([mockScene transitionToPreviousScene]);
}

- (void)testWhenTheLetterIsCapitalAThenNoPrevButtonIsAvailable {
    LetterBaseScene *zScene = [[LetterBaseScene alloc] initWithSize:CGSizeMake(ArbitrarySceneWidth, ArbitrarySceneHeight) andLetter:@"A"];
    XCTAssertNil([zScene childNodeWithName:PreviousButtonNodeName]);
}

- (void)testAllSubcomponentsOfTheTrackAreAddedToAContainerNode {
    SKNode *containerNode = [theScene childNodeWithName:ContainerNodeName];
    XCTAssertNotNil(containerNode);
}

- (void)testForThePresenceOfATrainNode {
    XCTAssertNotNil(theTrainNode);
}

- (void)testTheTrainNodeGetsPassedThePathSegments {
    Train *train = (Train *)theTrainNode;
    XCTAssertEqualObjects(train.pathSegments, theScene.pathSegments);
}

- (void)testAnOutlineShapeNodeIsAddedForTheLetterTrack {
    XCTAssertNotNil(theLetterTrackOutlineNode);
    XCTAssertTrue([theLetterTrackOutlineNode isKindOfClass:[SKShapeNode class]]);
    // Test color?
    // Test strokeWidth?
}

- (void)testThePositionOfTheTrackContainerNodeCentersTheLetterOutlineNode {
    CGPathRef pathForTest = CGPathCreateWithRect(CGRectMake(10, 10, 35, 35), nil);
    CGPathRef pathOutlineForTest = CGPathCreateCopyByStrokingPath(pathForTest,
                                                                  nil,
                                                                  25.0,
                                                                  kCGLineCapButt,
                                                                  kCGLineJoinBevel,
                                                                  1.0);
    // Above is ugly, but how esle to get the outlined path for testing with?
    
    PathSegments *newPathSegments = [[PathSegments alloc] init];
    id mockPathSegments = OCMClassMock(newPathSegments.class);
    OCMStub([mockPathSegments generateCombinedPathForLetter:letterForTest]).andReturn(pathForTest);
    
    LetterBaseScene *newScene = [[LetterBaseScene alloc] initWithSize:CGSizeMake(100, 100)
                                                               letter:letterForTest
                                                      andPathSegments:mockPathSegments];
    
    SKNode *containerNode = [newScene childNodeWithName:ContainerNodeName];
    SKShapeNode *outlineNode = (SKShapeNode *)[containerNode childNodeWithName:OutlineNodeName];
    CGFloat leftGap = outlineNode.frame.origin.x + containerNode.frame.origin.x;
    CGFloat bottomGap = outlineNode.frame.origin.y + containerNode.frame.origin.y;
    CGFloat rightGap = newScene.frame.size.width - outlineNode.frame.size.width - outlineNode.frame.origin.x;
    CGFloat topGap = newScene.frame.size.height - outlineNode.frame.size.height - outlineNode.frame.origin.y;
    
    XCTAssertTrue(CGPathEqualToPath(outlineNode.path, pathOutlineForTest));
    
    XCTAssertEqualWithAccuracy(leftGap, 25, GapCheckAccuracy);
    XCTAssertEqualWithAccuracy(bottomGap, 25, GapCheckAccuracy);
    XCTAssertEqualWithAccuracy(outlineNode.frame.size.width, 50, GapCheckAccuracy);
    XCTAssertEqualWithAccuracy(outlineNode.frame.size.height, 50, GapCheckAccuracy);
    XCTAssertEqualWithAccuracy(rightGap, 25, GapCheckAccuracy);
    XCTAssertEqualWithAccuracy(topGap, 25, GapCheckAccuracy);
}

- (void)testTheNumberOfCrossbarsAddedIsEqualToTheNumberOfCrossbarsOnTheTrainPath {
    NSUInteger initialChildCount = theContainerNode.children.count;
    PathSegments *pathSegments = [[PathSegments alloc] init];
    [pathSegments generateObjectsWithType:CrossbarObjectType forLetter:letterForTest];
    [theScene createSpritesForCrossbars:pathSegments.generatedCrossbars];
    XCTAssertEqual(theContainerNode.children.count, initialChildCount + pathSegments.generatedCrossbars.count);
}

- (void)testTheWaypointsAreAddedToTheLetterTrackAsNodes {
    NSUInteger initialChildCount = theContainerNode.children.count;
    
    CGPoint waypoint1 = CGPointMake(0, 10);
    CGPoint waypoint2 = CGPointMake(10, 0);
    
    [theScene createSpritesForWaypoints:[NSArray arrayWithObjects:
                            [NSValue valueWithCGPoint:waypoint1],
                            [NSValue valueWithCGPoint:waypoint2],
                            nil]];
    
    XCTAssertEqual(theContainerNode.children.count, initialChildCount + 2);
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
    NSArray *containerChildren = [theContainerNode children];
    
    XCTAssertNotNil([theContainerNode childNodeWithName:CrossbarName]);
    
    [containerChildren enumerateObjectsWithOptions:NSEnumerationConcurrent
                                    usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                        SKNode *crossbarNode = (SKNode *)obj;
                                        if ([crossbarNode.name isEqualToString:CrossbarName]) {
                                            XCTAssertLessThan(theLetterTrackOutlineNode.zPosition, crossbarNode.zPosition);
                                        }
                                    }];
}

- (void)testTheTheCrossbarsAreDrawnBeforeTheWaypoints {
    SKNode *aCrossbar = (SKNode *)[theContainerNode childNodeWithName:CrossbarName];
    NSArray *containerChildren = [theContainerNode children];
    
    XCTAssertNotNil([theContainerNode childNodeWithName:WaypointName]);
    
    [containerChildren enumerateObjectsWithOptions:NSEnumerationConcurrent
                                    usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                        SKNode *waypointNode = (SKNode *)obj;
                                        if ([waypointNode.name isEqualToString:WaypointName]) {
                                            XCTAssertLessThan(aCrossbar.zPosition, waypointNode.zPosition);
                                        }
                                    }];
}

- (void)testTheWaypointsAreDrawnBeforeTheTrain {
    SKNode *aWaypoint = (SKNode *)[theContainerNode childNodeWithName:WaypointName];
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
        SKShapeNode *letterNode = (SKShapeNode *)[scene childNodeWithName:OutlineNodeName];
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
        SKShapeNode *letterNode = (SKShapeNode *)[scene childNodeWithName:OutlineNodeName];
        CGFloat topGap = scene.frame.size.height - letterNode.frame.size.height - letterNode.frame.origin.y;
        CGFloat bottomGap = letterNode.frame.origin.y;
        XCTAssertEqualWithAccuracy(topGap, bottomGap, GapCheckAccuracy, @"Letter %c Does not meet the Vertical Alignment Standard", unicharRepOfLetter);
        unicharRepOfLetter = (unichar)(unicharRepOfLetter + 1);
    }
}
#endif

@end

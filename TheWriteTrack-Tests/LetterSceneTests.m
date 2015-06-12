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

#import "CGMatchers.h"
#import "CocoaLumberjack.h"

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

CGFloat const GapCheckAccuracy = 1.0;
CGFloat const ArbitrarySceneWidth = 400;
CGFloat const ArbitrarySceneHeight = 400;
NSString *const CrossbarName = @"Crossbar";
NSString *const WaypointName = @"Waypoint";
NSString *const OutlineNodeName = @"LetterOutlineNode";
NSString *const ContainerNodeName = @"TrackContainerNode";
NSString *const NextButtonNodeName = @"NextButton";
NSString *const PreviousButtonNodeName = @"PreviousButton";

@interface LetterSceneTests : XCTestCase {
    LetterScene *theScene;
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

@implementation LetterSceneTests

- (void)setUp {
    [super setUp];
    letterForTest = @"E";
    arbitrarySceneSize = CGSizeMake(ArbitrarySceneWidth, ArbitrarySceneHeight);
    theScene = [[LetterScene alloc]initWithSize:arbitrarySceneSize andLetter:letterForTest];
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
    LetterScene *anotherScene = [[LetterScene alloc]initWithSize:CGSizeMake(ArbitrarySceneWidth, ArbitrarySceneHeight) andLetter:letterToInitWith];
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
    LetterScene *zScene = [[LetterScene alloc] initWithSize:CGSizeMake(ArbitrarySceneWidth, ArbitrarySceneHeight) andLetter:@"Z"];
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
    LetterScene *zScene = [[LetterScene alloc] initWithSize:CGSizeMake(ArbitrarySceneWidth, ArbitrarySceneHeight) andLetter:@"A"];
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

#define PERFORM_HORIZONTAL_CENTER_TEST    1
#if (PERFORM_HORIZONTAL_CENTER_TEST)
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
#endif

#define PERFORM_VERTICAL_CENTER_TEST    1
#if (PERFORM_VERTICAL_CENTER_TEST)
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
#endif

@end

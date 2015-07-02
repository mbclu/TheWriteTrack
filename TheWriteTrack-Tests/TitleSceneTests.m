//
//  TitleSceneTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/7/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "TitleScene.h"

#import "AttributedStringPath.h"
#import "StartButton.h"
#import "TitleTrain.h"

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "CocoaLumberjack.h"
#import "CGMatchers.h"

@interface TitleSceneTests : XCTestCase {
    TitleScene *theTitleScene;
    SKSpriteNode *backgroundNode;
    SKSpriteNode *trackNode;
    SKSpriteNode *trainNode;
    SKEmitterNode *smokeNode;
    StartButton *startButtonNode;
}

@end

@implementation TitleSceneTests

- (void)setUp {
    [super setUp];
    theTitleScene = [TitleScene sceneWithSize:CGSizeMake(100, 100)];
    backgroundNode = (SKSpriteNode *)[theTitleScene childNodeWithName:@"TitleBackground"];
    trackNode = (SKSpriteNode *)[theTitleScene childNodeWithName:@"TitleTrack"];
    trainNode = (SKSpriteNode *)[theTitleScene childNodeWithName:@"TitleTrain"];
    smokeNode = (SKEmitterNode *)[trainNode childNodeWithName:@"TitleSmoke"];
    startButtonNode = (StartButton *)[theTitleScene childNodeWithName:@"StartButton"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testTheTitleSceneScaleModeIsConfiguredToFill {
    XCTAssertEqual([theTitleScene scaleMode], SKSceneScaleModeAspectFill);
}

- (void)testTheTitleSceneLoadsTheTitleBackground {
    XCTAssertNotNil(backgroundNode);
}

- (void)testTheTitleSceneBackgroundIsTheSameSizeAsTheScene {
    XCTAssertEqualSizes(backgroundNode.size, theTitleScene.size);
}

- (void)testTheTitleBackgroundIsAnchoredAtZeroXZeroY {
    XCTAssertEqual(backgroundNode.anchorPoint.x, 0);
    XCTAssertEqual(backgroundNode.anchorPoint.y, 0);
}

- (void)testThereIsATrack {
    XCTAssertNotNil(trackNode);
}

- (void)testTheTitleTrainIsLoadedOnTheTitleScene {
    XCTAssertNotNil(trainNode);
}

- (void)testTheTitleTrainIsAnchoredAtZero {
    XCTAssertEqual(trainNode.anchorPoint.x, 0);
    XCTAssertEqual(trainNode.anchorPoint.y, 0);
}

- (void)testTheTitleTrainStartsHalfwayOffTheScreenAtTheHeightOfTheTrack {
    XCTAssertEqualPoints(trainNode.position, CGPointMake(-trainNode.size.width * 0.5, trackNode.frame.size.height));
}

- (void)testAnActionCanMoveTheTrainWithDurationFourSeconds {
    XCTAssertNotNil(theTitleScene.moveLeftToRightAction);
    XCTAssertNotEqual([theTitleScene.moveLeftToRightAction.description rangeOfString:@"SKMove"].location, NSNotFound);
    XCTAssertEqual(theTitleScene.moveLeftToRightAction.duration, 3);
}

- (void)testAnActionCanCauseAnObjectToGrowLargerOverFourSeconds {
    XCTAssertNotNil(theTitleScene.scaleUpAction);
    XCTAssertNotEqual([theTitleScene.scaleUpAction.description rangeOfString:@"SKScale"].location, NSNotFound);
    XCTAssertEqual(theTitleScene.scaleUpAction.duration, 3);
}

- (void)testTheMoveAndGrowActionsHaveTheSameDuration {
    XCTAssertEqual(theTitleScene.moveLeftToRightAction.duration, theTitleScene.scaleUpAction.duration);
}

- (void)testWhenMovingToTheViewThenTheTrainRunsTheMoveAndGrowActions {
    id mockView = OCMClassMock([SKView class]);
    [theTitleScene didMoveToView:mockView];
    XCTAssertTrue(trainNode.hasActions);
    XCTAssertNotNil([trainNode actionForKey:@"ScaleUp"]);
    XCTAssertNotNil([trainNode actionForKey:@"MoveLeftToRight"]);
    XCTAssertNotNil([startButtonNode actionForKey:@"FlashyLights"]);
}

- (void)testThereIsAButtonToBeginWritingPractice {
    XCTAssertNotNil(startButtonNode);
}

- (void)testTheZOrderIs_Background_Track_SignalLight_Train {
    XCTAssertLessThan(backgroundNode.zPosition, trackNode.zPosition);
    XCTAssertLessThan(trackNode.zPosition, startButtonNode.zPosition);
    XCTAssertLessThan(startButtonNode.zPosition, trainNode.zPosition);
}

- (void)testTheStartButtonIsPositionedCorrectlyInRelationToTheScene {
    TitleScene *sizeConstrainedTitleScene = [[TitleScene alloc] initWithSize:CGSizeMake(100, 100)];
    StartButton *startButton = (StartButton *)[sizeConstrainedTitleScene childNodeWithName:@"StartButton"];
    XCTAssertEqualPoints(startButton.position, CGPointMake(85, 45));
}

- (void)testPressingAnywhereOnTheSreenHooksToATransitionToTheAScene {
    id mockTitleScene = OCMPartialMock(theTitleScene);
    [theTitleScene touchesEnded:nil withEvent:nil];
    OCMVerify([mockTitleScene transitionToAScene]);
}

@end

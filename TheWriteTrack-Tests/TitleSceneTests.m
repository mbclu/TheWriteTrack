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

- (void)testTheTitleTrainIsLoadedOnTheTitleScene {
    XCTAssertNotNil(trainNode);
}

- (void)testTheTitleTrainIsAnchoredAtZero {
    XCTAssertEqual(trainNode.anchorPoint.x, 0);
    XCTAssertEqual(trainNode.anchorPoint.y, 0);
}

- (void)testTheTrainIsLoadedOnTopOfTheBackground {
    XCTAssertGreaterThan(trainNode.zPosition, backgroundNode.zPosition);
}

- (void)testTheTitleTrainStartsOffTheScreenAtAHeightOfSixtyPercent {
    XCTAssertEqualPoints(trainNode.position, CGPointMake(-trainNode.size.width, theTitleScene.frame.size.height * 0.5));
}

- (void)testAnActionCanMoveTheTrainWithDurationFourSeconds {
    XCTAssertNotNil(theTitleScene.moveLeftToRightAction);
    XCTAssertNotEqual([theTitleScene.moveLeftToRightAction.description rangeOfString:@"SKMove"].location, NSNotFound);
    XCTAssertEqual(theTitleScene.moveLeftToRightAction.duration, 4);
}

- (void)testAnActionCanCauseAnObjectToGrowLargerOverFourSeconds {
    XCTAssertNotNil(theTitleScene.scaleUpAction);
    XCTAssertNotEqual([theTitleScene.scaleUpAction.description rangeOfString:@"SKScale"].location, NSNotFound);
    XCTAssertEqual(theTitleScene.scaleUpAction.duration, 4);
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
}

- (void)testThereIsAButtonToBeginWritingPractice {
    XCTAssertNotNil(startButtonNode);
}

- (void)testTheStartButtonIsTheHighestZOrder {
    NSArray *children = [theTitleScene children];
    for (NSUInteger i; i < children.count; i++) {
        XCTAssertGreaterThanOrEqual(startButtonNode.zPosition, ((SKNode *)[children objectAtIndex:i]).zPosition);
    }
}

- (void)testTheStartButtonIsPositionedCorrectlyInRelationToTheScene {
    TitleScene *sizeConstrainedTitleScene = [[TitleScene alloc] initWithSize:CGSizeMake(100, 100)];
    StartButton *startButton = (StartButton *)[sizeConstrainedTitleScene childNodeWithName:@"StartButton"];
    XCTAssertEqualPoints(startButton.position, CGPointMake(85, 55));
}

- (void)testPressingTheStartButtonHooksToATransitionToTheAScene {
    id mockTitleScene = OCMPartialMock(theTitleScene);
    StartButton *startButton = (StartButton *)startButtonNode;
    [startButton evaluateTouchAtPoint:startButtonNode.position];
    OCMVerify([mockTitleScene transitionToAScene]);
}

@end

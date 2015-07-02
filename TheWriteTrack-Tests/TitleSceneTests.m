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
    SKEmitterNode *startButtonNode;
}

@end

@implementation TitleSceneTests

- (void)setUp {
    [super setUp];
    theTitleScene = [TitleScene sceneWithSize:CGSizeMake(100, 100)];
    backgroundNode = (SKSpriteNode *)[theTitleScene childNodeWithName:@"TitleBackground"];
    trainNode = (SKSpriteNode *)[theTitleScene childNodeWithName:@"TitleTrain"];
    smokeNode = (SKEmitterNode *)[trainNode childNodeWithName:@"TitleSmoke"];
    startButtonNode = (SKEmitterNode *)[theTitleScene childNodeWithName:@"StartButton"];
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
    XCTAssertEqualPoints(trainNode.position, CGPointMake(-trainNode.size.width, theTitleScene.frame.size.height * 0.6));
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

- (void)testTheStartButtonIsHorizontallyCentered {
    XCTAssertEqual([UIScreen mainScreen].bounds.origin.x, 0);
    
    CGFloat leftSpan = startButtonNode.position.x - [UIScreen mainScreen].bounds.origin.x;
    CGFloat rightSpan = [UIScreen mainScreen].bounds.size.width -
                            (startButtonNode.position.x + startButtonNode.frame.size.width);

    XCTAssertEqual(leftSpan, rightSpan);
}

- (void)testTheStartButtonIsVeritcallyPlacedTwentyPixelsUnderTheTopOfTheScreen {
    CGFloat topOffset = [UIScreen mainScreen].bounds.size.height - startButtonNode.frame.size.height - 20;
    XCTAssertEqual(startButtonNode.position.y, topOffset);
}

- (void)testPressingTheStartButtonHooksToATransitionToTheAScene {
    id mockTitleScene = OCMPartialMock(theTitleScene);
    StartButton *startButton = (StartButton *)startButtonNode;
    [startButton evaluateTouchAtPoint:startButtonNode.position];
    OCMVerify([mockTitleScene transitionToAScene]);
}

@end

//
//  TitleSceneTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/7/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TitleScene.h"
#import "TitleTrain.h"
#import "AttributedStringPath.h"
#import "CocoaLumberjack.h"

@interface TitleSceneTests : XCTestCase {
    TitleScene *scene;
    SKSpriteNode *backgroundNode;
    SKSpriteNode *foregroundNode;
    SKSpriteNode *trainNode;
    SKEmitterNode *smokeNode;
    SKEmitterNode *startButtonNode;
}

@end

@implementation TitleSceneTests

- (void)setUp {
    [super setUp];
    scene = [TitleScene sceneWithSize:CGSizeMake(100, 100)];
    backgroundNode = (SKSpriteNode *)[scene childNodeWithName:TITLE_BACKGROUND];
    foregroundNode = (SKSpriteNode *)[scene childNodeWithName:TITLE_FOREGROUND];
    trainNode = (SKSpriteNode *)[scene childNodeWithName:TITLE_TRAIN];
    smokeNode = (SKEmitterNode *)[trainNode childNodeWithName:ORANGE_SMOKE];
    startButtonNode = (SKEmitterNode *)[scene childNodeWithName:START_BUTTON];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testTheTitleSceneScaleModeIsConfiguredToFill {
    XCTAssertEqual([scene scaleMode], SKSceneScaleModeAspectFill);
}

- (void)testTheTitleSceneLoadsTheTitleBackground {
    XCTAssertNotNil(backgroundNode);
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

- (void)testTheTrainStartsAtTheCorrectPoint {
    XCTAssertEqualWithAccuracy(trainNode.position.x, 123, 1.0);
    XCTAssertEqualWithAccuracy(trainNode.position.y, 138, 1.0);
}

- (void)testTheTitleSceneLoadsTheForeground {
    XCTAssertNotNil(foregroundNode);
}

- (void)testTheTitleForegroundIsAnchoredAtZero {
    XCTAssertEqual(foregroundNode.anchorPoint.x, 0);
    XCTAssertEqual(foregroundNode.anchorPoint.y, 0);
}

- (void)testTheTitleForegroundIsLoadedOnTopOfTheTrain {
    XCTAssertGreaterThan(foregroundNode.zPosition, trainNode.zPosition);
}

- (void)testTheTitleTrainHasAnOrangeSmokeEmitter {
    XCTAssertNotNil([trainNode childNodeWithName:ORANGE_SMOKE]);
}

- (void)testTheTrainSmokeIsAtFivePixelsDownFromTheTopCornerOfTheTrain {
    XCTAssertEqual(smokeNode.position.y, trainNode.size.height - 5);
}

- (void)testTheTrainSmokeIsAtTenPixelsLeftOfTheRightSideOfTheTrain {
    XCTAssertEqual(smokeNode.position.x, trainNode.size.width - 10);
}

- (void)testThereIsAButtonToBeginWritingPractice {
    XCTAssertNotNil(startButtonNode);
}

- (void)testTheStartButtonIsTheHighestZOrder {
    NSArray *children = [scene children];
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
    XCTAssertTrue(NO, @"Kid woke up... write me next!");
}

@end

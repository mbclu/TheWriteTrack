//
//  TitleSceneTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/7/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TitleScene.h"
#import "Train.h"

@interface TitleSceneTests : XCTestCase {
    TitleScene *scene;
    SKSpriteNode *backgroundNode;
    SKSpriteNode *trainNode;
}

@end

@implementation TitleSceneTests

- (void)setUp {
    [super setUp];
    scene = [TitleScene sceneWithSize:CGSizeMake(100, 100)];
    backgroundNode = (SKSpriteNode*)[scene childNodeWithName:@"TitleBackground"];
    trainNode = (SKSpriteNode*)[scene childNodeWithName:TRAIN_NODE];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThatTheTitleSceneScaleModeIsConfiguredToFill {
    XCTAssertEqual([scene scaleMode], SKSceneScaleModeAspectFill);
}

- (void)testThatTheTitleSceneLoadsTheTitleBackground {
    XCTAssertNotNil(backgroundNode);
}

- (void)testThatTheTitleBackgroundIsAnchoredAtZeroXZeroY {
    XCTAssertEqual(backgroundNode.anchorPoint.x, 0);
    XCTAssertEqual(backgroundNode.anchorPoint.y, 0);
}

- (void)testThatTheTitleTrainIsLoadedOnTheTitleScene {
    XCTAssertNotNil(trainNode);
}

- (void)testThatTheTitleTrainIsAnchoredAtAPoint {
    XCTAssertEqual(trainNode.anchorPoint.x, 0);
    XCTAssertEqual(trainNode.anchorPoint.y, 0);
}

- (void)testThatTheTrainIsLoadedOnTopOfTheBackground {
    XCTAssertGreaterThan(trainNode.zPosition, backgroundNode.zPosition);
}

- (void)testThatTheTrainStartsAtPoint123x148y {
    XCTAssertEqualWithAccuracy(trainNode.position.x, 123, 1.0);
    XCTAssertEqualWithAccuracy(trainNode.position.y, 138, 1.0);
}

@end

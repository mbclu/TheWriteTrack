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
    SKEmitterNode *startButtonSmoke;
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
    startButtonSmoke = (SKEmitterNode *)[scene childNodeWithName:START_SMOKE_TEXT];
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

- (void)testThatTheTrainStartsAtTheCorrectPoint {
    XCTAssertEqualWithAccuracy(trainNode.position.x, 123, 1.0);
    XCTAssertEqualWithAccuracy(trainNode.position.y, 138, 1.0);
}

- (void)testThatTheTitleSceneLoadsTheForeground {
    XCTAssertNotNil(foregroundNode);
}

- (void)testThatTheTitleForegroundIsAnchoredAtZero {
    XCTAssertEqual(foregroundNode.anchorPoint.x, 0);
    XCTAssertEqual(foregroundNode.anchorPoint.y, 0);
}

- (void)testThatTheTitleForegroundIsLoadedOnTopOfTheTrain {
    XCTAssertGreaterThan(foregroundNode.zPosition, trainNode.zPosition);
}

- (void)testThatTheStartButtonSmokeStringIsCreatedOutOfAParticleEmitter {
    XCTAssertNotNil(startButtonSmoke);
    XCTAssertTrue([startButtonSmoke isKindOfClass:[SKEmitterNode class]]);
}

- (void)testThatTheTitleStringEmitterRepeatsAnAction {
    XCTAssertNotNil(startButtonSmoke.particleAction);
    XCTAssertNotEqual([startButtonSmoke.particleAction.description rangeOfString:@"<SKRepeat:"].location, NSNotFound);
}

- (void)testThatTheTitleTrainHasAnOrangeSmokeEmitter {
    XCTAssertNotNil([trainNode childNodeWithName:ORANGE_SMOKE]);
}

- (void)testThatTheTitleTrainSmokeIsAtFivePixelsDownFromTheTopCornerOfTheTrain {
    XCTAssertEqual(smokeNode.position.y, trainNode.size.height - 5);
}

- (void)testThatTheTitleTrainSmokeIsAtTenPixelsLeftOfTheRightSideOfTheTrain {
    XCTAssertEqual(smokeNode.position.x, trainNode.size.width - 10);
}

//- (void)testThatTheTitleStringEmitterStartsAtTheUpperLeftCorner {
//    AttributedStringPath *stringPath = [[AttributedStringPath alloc] initWithString:TITLE];
//    CGRect stringPathBounds = CGPathGetPathBoundingBox(stringPath.path);
//    CGFloat originX = 0;
//    CGFloat originY = scene.frame.size.height - stringPathBounds.size.height;
//    
//    XCTAssertEqualWithAccuracy(titleNode.position.x, originX, 0.1);
//    XCTAssertEqualWithAccuracy(titleNode.position.y, originY, 0.1);
//}

- (void)testThereIsAButtonToBeginWritingPractice {
    XCTAssertNotNil(startButtonSmoke);
}

- (void)testTheStartButtonSmokeIsTheHighestZOrder {
    NSArray *children = [scene children];
    for (NSUInteger i; i < children.count; i++) {
        XCTAssertGreaterThanOrEqual(startButtonSmoke.zPosition, ((SKNode *)[children objectAtIndex:i]).zPosition);
    }
}

@end

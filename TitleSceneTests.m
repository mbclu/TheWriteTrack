//
//  TitleSceneTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/7/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TitleScene.h"

@interface TitleSceneTests : XCTestCase {
    TitleScene *scene;
}

@end

@implementation TitleSceneTests

- (void)setUp {
    [super setUp];
    scene = [TitleScene sceneWithSize:CGSizeMake(100, 100)];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThatTheTitleSceneScaleModeIsConfiguredToFill {
    XCTAssertEqual([scene scaleMode], SKSceneScaleModeAspectFill);
}

- (void)testThatTheTitleSceneLoadsTheTitleBackground {
    SKSpriteNode *expectedNode = (SKSpriteNode*)[scene childNodeWithName:@"TitleBackground"];
    XCTAssertNotNil(expectedNode);
}

- (void)testThatTheTitleBackgroundIsAnchoredAtZeroXZeroY {
    SKSpriteNode *expectedNode = (SKSpriteNode*)[scene childNodeWithName:@"TitleBackground"];
    XCTAssertEqual(expectedNode.anchorPoint.x, 0);
    XCTAssertEqual(expectedNode.anchorPoint.y, 0);
}

@end

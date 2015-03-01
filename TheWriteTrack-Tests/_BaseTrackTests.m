//
//  _BaseTrackTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/11/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "_BaseTrackScene.h"

@interface _BaseTrackTests : XCTestCase

@property SKView* skView;
@property SKSpriteNode* backgroundNode;
@property SKSpriteNode* trainNode;

@end

@implementation _BaseTrackTests


- (void)setUp {
    [super setUp];
    [self setSkView:(SKView*)[UIApplication sharedApplication].delegate.window.rootViewController.view];
    [self setBackgroundNode:(SKSpriteNode*)[[_skView scene] childNodeWithName:@"_BaseBackground"]];
    [self setTrainNode:(SKSpriteNode*)[[_skView scene] childNodeWithName:@"_BaseTrain"]];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThatTheBaseSceneDoesNotShowFPS {
    XCTAssertFalse([[self skView] showsFPS]);
}

- (void)testThatTheBaseSceneDoesNotTheNumberOfNodes {
    XCTAssertFalse([[self skView] showsNodeCount]);
}

- (void)testThatTheBaseSceneIsComprisedOfARockyBackground {
    XCTAssertNotNil([self backgroundNode]);
}

- (void)testThatTheBaseSceneBackgroundIsAnchoredAtZero {
    XCTAssertEqual([self backgroundNode].anchorPoint.x, CGPointZero.x, @"Actual x: %f != Expected x: %f", [self backgroundNode].anchorPoint.x, CGPointZero.x);
    XCTAssertEqual([self backgroundNode].anchorPoint.y, CGPointZero.y, @"Actual y: %f != Expected y: %f", [self backgroundNode].anchorPoint.y, CGPointZero.y);
}

- (void)testThatTheBaseSceneHasATrainOnIt {
    XCTAssertNotNil([self trainNode]);
}

@end

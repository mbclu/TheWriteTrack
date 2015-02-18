//
//  _BaseTrackTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/11/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "../TheWriteTrack/_BaseTrackScene.h"
#import <XCTest/XCTest.h>

@interface _BaseTrackTests : XCTestCase

@property SKView* skView;
@property SKSpriteNode* skNode;

@end

@implementation _BaseTrackTests


- (void)setUp {
    [super setUp];
    [self setSkView:(SKView*)[UIApplication sharedApplication].delegate.window.rootViewController.view];
    [self setSkNode:(SKSpriteNode*)[[_skView scene] childNodeWithName:@"_BaseBackground"]];
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
    XCTAssertNotNil([self skNode]);
}

- (void)testThatTheBaseSceneBackgroundIsAnchoredAtZero {
    XCTAssertEqual([self skNode].anchorPoint.x, CGPointZero.x, @"Actual x: %f != Expected x: %f", [self skNode].anchorPoint.x, CGPointZero.x);
    XCTAssertEqual([self skNode].anchorPoint.y, CGPointZero.y, @"Actual y: %f != Expected y: %f", [self skNode].anchorPoint.y, CGPointZero.y);
}

@end

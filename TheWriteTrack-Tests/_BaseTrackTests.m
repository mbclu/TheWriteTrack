//
//  _BaseTrackTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/11/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "_BaseTrackScene.h"
#import "CocoaLumberjack.h"

static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

@interface _BaseTrackTests : XCTestCase {
    _BaseTrackScene *scene;
    SKSpriteNode *rockyBackground;
}

@end

@implementation _BaseTrackTests

- (void)setUp {
    [super setUp];
    scene = [_BaseTrackScene sceneWithSize:CGSizeMake(100, 100)];
    rockyBackground = [scene childNodeWithName:@"RockyBackground"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThatTheBaseSceneIsComprisedOfARockyBackground {
    XCTAssertNotNil(rockyBackground);
}

- (void)testThatTheBaseSceneBackgroundIsAnchoredAtZero {
    XCTAssertEqual(rockyBackground.anchorPoint.x, CGPointZero.x);
    XCTAssertEqual(rockyBackground.anchorPoint.y, CGPointZero.y);
}

- (void)testThatTheSceneUsesTheFillAspectScaleMode {
    SKScene *scene = [_BaseTrackScene sceneWithSize:CGSizeMake(100, 100)];
    XCTAssertEqual(scene.scaleMode , SKSceneScaleModeAspectFill);
}

- (void)testThatInitAndSceneWithAreTheSameThing {
    SKScene *initWith = [[_BaseTrackScene alloc] initWithSize:CGSizeMake(100, 100)];
    SKScene *sceneWith = [_BaseTrackScene sceneWithSize:CGSizeMake(100, 100)];
    XCTAssertEqualObjects(initWith, sceneWith);
}

@end

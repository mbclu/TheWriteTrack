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

@interface _BaseTrackTests : XCTestCase {
    _BaseTrackScene *scene;
    SKSpriteNode *rockyBackground;
}

@end

@implementation _BaseTrackTests

- (void)setUp {
    [super setUp];
    scene = [_BaseTrackScene sceneWithSize:CGSizeMake(100, 100)];
    rockyBackground = (SKSpriteNode*)[scene childNodeWithName:ROCKY_BACKGROUND];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testTheBaseSceneIsComprisedOfARockyBackground {
    XCTAssertNotNil(rockyBackground);
}

- (void)testTheBaseSceneBackgroundIsAnchoredAtZero {
    XCTAssertEqual(rockyBackground.anchorPoint.x, CGPointZero.x);
    XCTAssertEqual(rockyBackground.anchorPoint.y, CGPointZero.y);
}

- (void)testTheSceneUsesTheFillAspectScaleMode {
    XCTAssertEqual(scene.scaleMode , SKSceneScaleModeAspectFill);
}

@end

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
#import "CGMatchers.h"

NSString *const RockyBackground = @"RockyBackground";
NSString *const NextButton = @"NextButton";

@interface _BaseTrackSceneTests : XCTestCase {
    _BaseTrackScene *scene;
    SKSpriteNode *rockyBackground;
    SKSpriteNode *nextButtonNode;
}

@end

@implementation _BaseTrackSceneTests

- (void)setUp {
    [super setUp];
    scene = [_BaseTrackScene sceneWithSize:CGSizeMake(200, 200)];
    rockyBackground = (SKSpriteNode*)[scene childNodeWithName:RockyBackground];
    nextButtonNode = (SKSpriteNode *)[scene childNodeWithName:NextButton];
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

- (void)testTheRockyBackgroundIsComprisedOfTheRockyBackgroundPNG {
    XCTAssertTrue([rockyBackground.texture.description containsString:RockyBackground]);
}

- (void)testForANextLetterButton {
    XCTAssertNotNil(nextButtonNode);
}

- (void)testTheNextButtonIsComprisedOfTheNextButtonImage {
    XCTAssertTrue([nextButtonNode.texture.description containsString:NextButton]);
}

- (void)testTheNextButtonIsAnchoredAtZero {
    XCTAssertEqualPoints(nextButtonNode.anchorPoint, CGPointZero);
}

- (void)testTheNextButtonsXPositionIsAtTenLessThanTheDifferenceInWidth {
    XCTAssertEqual(nextButtonNode.position.x, scene.size.width - nextButtonNode.size.width - 10);
}

- (void)testTheNextButtonsYPositionIsAtHalfOfTheSceneHeight {
    XCTAssertEqual(nextButtonNode.position.y, scene.size.height * 0.5);
}

@end

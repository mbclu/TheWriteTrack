//
//  StartButtonTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/30/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "StartButton.h"
#import <XCTest/XCTest.h>
#import "CGMatchers.h"

@interface StartButtonTests : XCTestCase {
    StartButton *theStartButton;
}

@end

@implementation StartButtonTests

- (void)setUp {
    [super setUp];
    theStartButton = [[StartButton alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testTheStartButtonUsesTheSignalLightTopImage {
    SKSpriteNode* top = (SKSpriteNode *)theStartButton.signalTopHalfNode;
    XCTAssertNotNil(top);
    XCTAssertTrue([top.texture.description containsString:@"SignalLightTop"]);
}

- (void)testTheStartButtonUsesTheSignalLightBottomImage {
    SKSpriteNode *bottom = (SKSpriteNode *)theStartButton.signalBottomHalfNode;
    XCTAssertNotNil(bottom);
    XCTAssertTrue([bottom.texture.description containsString:@"SignalLightBottom"]);
}

- (void)testUserInteractionIsDisabledForTheStartButton {
    XCTAssertFalse(theStartButton.userInteractionEnabled);
}

- (void)testTheTopHalfHasAGreenYellowAndRedLight {
    XCTAssertEqual(theStartButton.redLightNode.parent, theStartButton.signalTopHalfNode);
    XCTAssertEqual(theStartButton.yellowLightNode.parent, theStartButton.signalTopHalfNode);
    XCTAssertEqual(theStartButton.greenLightNode.parent, theStartButton.signalTopHalfNode);
}

- (void)testEachLightHasTheSameXPosition {
    XCTAssertEqual(theStartButton.redLightNode.frame.origin.x, theStartButton.yellowLightNode.frame.origin.x);
    XCTAssertEqual(theStartButton.yellowLightNode.frame.origin.x, theStartButton.greenLightNode.frame.origin.x);
}

- (void)testTheYellowLightIsPositionedInTheCenterOfTheTopHalfOfTheSignalLight {
    CGPoint convertedPoint = [theStartButton.signalTopHalfNode convertPoint:theStartButton.yellowLightNode.position
                                                                     toNode:theStartButton.signalTopHalfNode];
    XCTAssertEqual(theStartButton.yellowLightNode.position.y, convertedPoint.y);
}

- (void)testTheGreenLightIsPositionedAboveTheYellowNode {
    XCTAssertGreaterThan(theStartButton.greenLightNode.position.y, theStartButton.yellowLightNode.frame.size.height);
}

- (void)testTheRedLightIsPositionedBelowTheYellowNode {
    XCTAssertLessThan(theStartButton.redLightNode.position.y, theStartButton.yellowLightNode.frame.size.height);
}

@end

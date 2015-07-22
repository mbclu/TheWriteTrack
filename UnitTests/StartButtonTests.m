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
    SKSpriteNode *topHalf;
}

@end

@implementation StartButtonTests

- (void)setUp {
    [super setUp];
    theStartButton = [[StartButton alloc] init];
    topHalf = (SKSpriteNode *)[theStartButton childNodeWithName:@"SignalTopHalf"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testTheStartButtonUsesTheSignalLightTopImage {
    XCTAssertNotNil(topHalf);
    XCTAssertTrue([topHalf.texture.description containsString:@"SignalLightTop"]);
}

- (void)testTheStartButtonUsesTheSignalLightBottomImage {
    SKSpriteNode *bottom = (SKSpriteNode *)[theStartButton childNodeWithName:@"SignalBottomHalf"];
    XCTAssertNotNil(bottom);
    XCTAssertTrue([bottom.texture.description containsString:@"SignalLightBottom"]);
}

- (void)testUserInteractionIsDisabledForTheStartButton {
    XCTAssertFalse(theStartButton.userInteractionEnabled);
}

- (void)testTheTopHalfHasAGreenYellowAndRedLight {
    XCTAssertNotNil([topHalf childNodeWithName:@"GreenLight"]);
    XCTAssertNotNil([topHalf childNodeWithName:@"YellowLight"]);
    XCTAssertNotNil([topHalf childNodeWithName:@"RedLight"]);
}

@end

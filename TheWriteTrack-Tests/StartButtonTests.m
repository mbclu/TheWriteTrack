//
//  StartButtonTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/30/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "StartButton.h"
#import <XCTest/XCTest.h>

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

- (void)testTheStartButtonUsesTheSignalLightImage {
    XCTAssertTrue([theStartButton.texture.description containsString:@"SignalLight"]);
}

- (void)testUserInteractionIsEnabledForTheStartButton {
    XCTAssertTrue(theStartButton.userInteractionEnabled);
}

@end

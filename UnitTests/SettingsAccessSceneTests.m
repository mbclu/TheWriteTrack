//
//  SettingsAccessSceneTests.m
//  TheWriteTrack
//
//  Created by Mitch Clutter on 12/31/15.
//  Copyright © 2015 Mitch Clutter. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SettingsAccessScene.h"
#import "GenericSpriteButton.h"
#import "Constants.h"
#import "CGMatchers.h"

@interface SettingsAccessSceneTests : XCTestCase {
    SettingsAccessScene *theScene;
    SKNode *settingsAccessButton;
}

@end

@implementation SettingsAccessSceneTests

- (void)setUp {
    [super setUp];
    theScene = [[SettingsAccessScene alloc] initWithSize:CGSizeMake(100, 100)];
    settingsAccessButton = [theScene childNodeWithName:SettingsAccessNode];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testTheSettingsAccessSceneHasASettingsAccessButton {
    XCTAssertNotNil(settingsAccessButton);
}

- (void)testTheSceneHasAClearBackground {
    XCTAssertEqualRGBColors(theScene.backgroundColor, [SKColor clearColor]);
}

- (void)testTheSettingsAccessButtonIsTheLowerRightHandCornerOfTheScreen {
    XCTAssertEqualSizes(theScene.frame.size, CGSizeMake(100, 100));
    XCTAssertEqual(settingsAccessButton.position.y, 10);
    XCTAssertEqual(settingsAccessButton.position.x,
                   theScene.frame.size.width - settingsAccessButton.frame.size.width - 10);
}

@end

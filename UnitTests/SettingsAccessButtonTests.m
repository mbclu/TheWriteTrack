//
//  SettingsAccessButtonTests.m
//  TheWriteTrack
//
//  Created by Mitch Clutter on 12/31/15.
//  Copyright © 2015 Mitch Clutter. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "SettingsAccessButton.h"
#import "Constants.h"

@interface SettingsAccessButtonTests : XCTestCase {
    SettingsAccessButton *theButton;
}

@end

@implementation SettingsAccessButtonTests

- (void)setUp {
    [super setUp];
    theButton = [[SettingsAccessButton alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testIsAGenericSpriteButton {
    XCTAssertTrue([theButton isKindOfClass:[GenericSpriteButton class]]);
}

- (void)testIsComprisedOfTheSettingsButtonImage {
    XCTAssertTrue([theButton.texture.description containsString:SettingsButtonImageName]);
}

- (void)testHasTheNameSettingsAccessButton {
    XCTAssertEqual(theButton.name, SettingsAccessNode);
}

- (void)testThatUserInteractionIsEnabledForTheThisButton {
    XCTAssertTrue(theButton.isUserInteractionEnabled);
}

- (void)testTheButtonIsAccessibleByLabel {
    XCTAssertEqual(theButton.accessibilityLabel, SettingsAccessLabel);
}

@end

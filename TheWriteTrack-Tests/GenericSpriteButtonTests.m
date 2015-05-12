//
//  GenericSpriteButtonTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/11/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "GenericSpriteButton.h"
#import "TargetFake.h"
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface GenericSpriteButtonTests : XCTestCase {
    GenericSpriteButton *genericButton;
    TargetFake *fakeTarget;
}
@end

@implementation GenericSpriteButtonTests

- (void)setUp {
    genericButton = [[GenericSpriteButton alloc] init];
    genericButton.size = CGSizeMake(1, 1); // Can't press a button of size zero
    fakeTarget = [[TargetFake alloc] init];
    [genericButton setTouchUpInsideTarget:fakeTarget action:@selector(expectedSelector)];
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThatUserInteractionIsEnabled {
    XCTAssertTrue([genericButton isUserInteractionEnabled]);
}

- (void)testPressingTheButtonSendsAMessageToTheTarget {
    [genericButton evaluateTouchAtPoint:genericButton.position];
    XCTAssertTrue([fakeTarget didReceiveMessage]);
}

- (void)testPressingAnAreaOutsideTheButtonDoesNotSendAMessageToTheTarget {
    [genericButton evaluateTouchAtPoint:CGPointMake(genericButton.size.width + 1, 0)];
    XCTAssertFalse([fakeTarget didReceiveMessage]);
}

@end

//
//  GenericSpriteButtonTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/11/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "GenericSpriteButton.h"
#import "FakeTargetScene.h"
#import "CGMatchers.h"
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface GenericSpriteButtonTests : XCTestCase {
    GenericSpriteButton *genericButton;
    FakeTargetScene *fakeScene;
}
@end

@implementation GenericSpriteButtonTests

- (void)setUp {
    [super setUp];
    fakeScene = [[FakeTargetScene alloc] initWithSize:CGSizeMake(100, 100)];
    genericButton = [[GenericSpriteButton alloc] init];
    genericButton.position = CGPointZero;
    genericButton.size = CGSizeMake(10, 10); // Can't press a button of size zero
    [genericButton setTouchUpInsideTarget:fakeScene action:@selector(expectedSelector)];
    [fakeScene addChild:genericButton];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThatUserInteractionIsEnabled {
    XCTAssertTrue([genericButton isUserInteractionEnabled]);
}

- (void)testPressingTheButtonSendsAMessageToTheTarget {
    [genericButton evaluateTouchAtPoint:genericButton.position];
    XCTAssertTrue([fakeScene didReceiveMessage]);
}

- (void)testPressingAnAreaOutsideTheButtonDoesNotSendAMessageToTheTarget {
    [genericButton evaluateTouchAtPoint:CGPointMake(genericButton.size.width + 1, 0)];
    XCTAssertFalse([fakeScene didReceiveMessage]);
}

- (void)testAnchorIsZero {
    XCTAssertEqualPoints(genericButton.anchorPoint, CGPointZero);
}

@end

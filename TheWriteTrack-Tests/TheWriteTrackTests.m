//
//  The_Write_TrackTests.m
//  The Write TrackTests
//
//  Created by Mitch Clutter on 2/7/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "GameViewController.h"

@interface TheWriteTrackTests : XCTestCase

/* Note that the common purpose of these tests was to learn how to access basic/"global" components
 of the application */

@property id<UIApplicationDelegate> app;
@property UIViewController* viewController;

@end

@implementation TheWriteTrackTests

- (void)setUp {
    [self setApp:[UIApplication sharedApplication].delegate];
    [self setViewController:[[self app] window].rootViewController];
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testAppHasANonNilAppDelegate {
    XCTAssertNotNil([UIApplication sharedApplication].delegate);
}

- (void)testAppHasANonNilGameViewController {
    XCTAssertNotNil([[self app] window].rootViewController);
}

- (void)testAppHasAVisibleView {
    XCTAssertTrue([[self viewController] isKindOfClass:[GameViewController class]]);
    XCTAssertNotNil([self viewController].view);
    XCTAssertFalse([[self viewController].view isHidden]);
}

@end

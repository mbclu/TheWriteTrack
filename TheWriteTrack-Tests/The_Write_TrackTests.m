//
//  The_Write_TrackTests.m
//  The Write TrackTests
//
//  Created by Mitch Clutter on 2/7/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "../TheWriteTrack/GameScene.h"
#import "../TheWriteTrack/GameViewController.h"

@interface The_Write_TrackTests : XCTestCase

@end

@implementation The_Write_TrackTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testAppHasANonNilAppDelegate {
    XCTAssertNotEqual([UIApplication sharedApplication].delegate, (id <UIApplicationDelegate>)nil);
}

@end

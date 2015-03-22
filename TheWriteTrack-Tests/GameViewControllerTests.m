//
//  GameViewControllerTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 3/22/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "GameViewController.h"
#import "LetterView.h"

@interface GameViewControllerTests : XCTestCase

@end

@implementation GameViewControllerTests {
    GameViewController *gvc;
    LetterView *letterview;
}

- (void)setUp {
    [super setUp];
    gvc = [[GameViewController alloc] init];
    letterview = [[[gvc view] subviews] objectAtIndex:0];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThatTheLetterViewIsASubviewOfTheGameController {
    XCTAssertTrue([letterview isKindOfClass:[LetterView class]]);
}

- (void)testThatTheFirstLetterViewLoadedIsForTheLetterA {
    XCTAssertEqualObjects([letterview attrString].string, @"A");
}

@end

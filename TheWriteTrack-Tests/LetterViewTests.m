//
//  LetterViewTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 3/1/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <GameViewController.h>

@interface LetterViewTests : XCTestCase

@end

@implementation LetterViewTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThatTheLetterViewIsASubviewOfTheGameController {
    GameViewController *controller = [[GameViewController alloc] init];
    XCTAssertTrue([[[[controller view] subviews] objectAtIndex:0] isKindOfClass:[LetterView class]]);
}

- (void)testThatTheLetterViewIsDrawnInTheRect {
    GameViewController *controller = [[GameViewController alloc] init];
    LetterView* view = [[[controller view] subviews] objectAtIndex:0];
    XCTAssertEqualWithAccuracy([view frame].origin.x, 100, 1);
    XCTAssertEqualWithAccuracy([view frame].origin.y, 50, 1);
    XCTAssertEqualWithAccuracy([view frame].size.height, 50, 1);
    XCTAssertEqualWithAccuracy([view frame].size.width, 50, 1);
}

@end

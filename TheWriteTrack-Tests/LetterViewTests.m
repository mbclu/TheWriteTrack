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

@implementation LetterViewTests {
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

- (void)testThatTheLetterViewHasAClearBackground {
    XCTAssertEqualObjects(letterview.backgroundColor, [UIColor clearColor]);
}

- (void)testThatWhenTheRailIsDrawThenTheContextUsesTheIdentityTransformAsItsMatrix {
    // Check out this blog post: http://eng.wealthfront.com/2014/03/unit-testing-drawrect.html
}

@end

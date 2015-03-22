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

//- (void)testThatTheLetterViewIsCreatedInTheMiddleOfTheScreen {
//    id mockView = OCMClassMock([LetterView class]);
//    [[mockView expect] initWithFrame:[UIScreen mainScreen].bounds];
//    [gvc viewDidLoad];
//    OCMVerifyAll(mockView);
//}

//- (void)testThatDrawRectIsCalledWithARectangleInTheMiddleOfTheScreen {
//    id mockView = OCMClassMock([LetterView class]);
//    [[[mockView expect] ignoringNonObjectArgs] drawRect:[UIScreen mainScreen].bounds];
//    OCMVerifyAll(mockView);
//}

//- (void)testThatTheLetterViewIsDrawnInTheRect {
//    GameViewController *controller = [[GameViewController alloc] init];
//    LetterView* view = [[[controller view] subviews] objectAtIndex:0];
//    XCTAssertEqualWithAccuracy([view frame].origin.x, 100, 1);
//    XCTAssertEqualWithAccuracy([view frame].origin.y, 50, 1);
//    XCTAssertEqualWithAccuracy([view frame].size.height, 50, 1);
//    XCTAssertEqualWithAccuracy([view frame].size.width, 50, 1);
//}

@end

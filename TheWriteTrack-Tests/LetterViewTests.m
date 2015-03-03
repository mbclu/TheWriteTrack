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

- (void)testThatTheLetterIsMovedToTheCenterOfTheView {
    GameViewController *controller = [[GameViewController alloc] init];
    id mockView = OCMClassMock([LetterView class]);
    
    CGMutablePathRef path;
    OCMStub([mockView drawRect:CGRectMake(0, 0, 0, 0)]).andReturn(path);
    
    // Notably this test has no assert right now....
}

@end

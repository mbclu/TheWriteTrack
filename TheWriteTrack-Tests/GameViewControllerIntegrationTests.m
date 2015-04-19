//
//  GameViewControllerIntegrationTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/1/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "GameViewController.h"
#import "LetterView.h"
#import "TitleScene.h"

@interface GameViewControllerIntegrationTests : XCTestCase

@end

@implementation GameViewControllerIntegrationTests {
    GameViewController *gvc;
    SKView *titleView;
}

- (void)setUp {
    [super setUp];
    gvc = (GameViewController*)[UIApplication sharedApplication].delegate.window.rootViewController;
    titleView = (SKView*)gvc.view;
}

- (void)tearDown {
    [super tearDown];
}


- (void)testAppHasANonNilAppDelegate {
    XCTAssertNotNil([UIApplication sharedApplication].delegate);
}

- (void)testAppHasANonNilGameViewController {
    XCTAssertNotNil(gvc);
}

- (void)testThatTheGameViewControllerPresentsTheTitleScene {
    SKScene *expectedScene = [TitleScene sceneWithSize:[titleView scene].size];
    XCTAssertEqualObjects([titleView scene], expectedScene);
}

- (void)testThatTheTitleSceneIsPresentedTheSameSizeAsTheMainScreen {
    CGSize expectedSize = [UIScreen mainScreen].bounds.size;
    XCTAssertEqual([titleView frame].size.height, expectedSize.height);
    XCTAssertEqual([titleView frame].size.width, expectedSize.width);
}

@end

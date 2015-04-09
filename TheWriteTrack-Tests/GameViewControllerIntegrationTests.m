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
    SKSpriteNode *titleBackground;
}

- (void)setUp {
    [super setUp];
    gvc = (GameViewController*)[UIApplication sharedApplication].delegate.window.rootViewController;
    titleBackground = (SKSpriteNode*)[(SKScene*)[(SKView*)gvc.view scene] childNodeWithName:@"TitleBackground"];
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
    SKScene *titleScene = [[TitleScene alloc] initWithSize:[UIScreen mainScreen].bounds.size];
    SKSpriteNode *expectedNode = (SKSpriteNode*)[titleScene childNodeWithName:@"TitleBackground"];
    XCTAssertEqualObjects(titleBackground, expectedNode);
}

- (void)testThatTheTitleBackgroundSceneIsPresentedTheSameSizeAsTheMainScreen {
    CGSize expectedSize = [UIScreen mainScreen].bounds.size;
    XCTAssertEqual(titleBackground.size.height, expectedSize.height);
    XCTAssertEqual(titleBackground.size.width, expectedSize.width);
}

@end

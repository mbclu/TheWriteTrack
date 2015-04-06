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
#import "_BaseTrackScene.h"

@interface GameViewControllerIntegrationTests : XCTestCase

@end

@implementation GameViewControllerIntegrationTests {
    GameViewController *gvc;
}

- (void)setUp {
    [super setUp];
    gvc = (GameViewController*)[UIApplication sharedApplication].delegate.window.rootViewController;
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThatTheGVCPresentsThe_BaseBackground_Scene {
    SKSpriteNode *node = (SKSpriteNode*)[(SKScene*)[(SKView*)gvc.view scene] childNodeWithName:@"_BaseBackground"];
    SKScene *_BaseBackgroundScene = [[_BaseTrackScene alloc] initWithSize:[UIScreen mainScreen].bounds.size];
    SKSpriteNode *expectedNode = (SKSpriteNode*)[_BaseBackgroundScene childNodeWithName:@"_BaseBackground"];
    XCTAssertEqualObjects(node, expectedNode);
}

@end

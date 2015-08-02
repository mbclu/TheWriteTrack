//
//  LetterSceneUITest.m
//  TheWriteTrack
//
//  Created by Mitch Clutter on 7/30/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LetterScene.h"

#import <UIKit/UIKit.h>
#import <KIF/KIF.h>
#import <XCTest/XCTest.h>

@interface LetterSceneUITests : KIFTestCase {
    LetterScene *theLetterScene;
}

@end

@implementation LetterSceneUITests

- (void)setUp {
    [super setUp];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    window.rootViewController = [window.rootViewController.storyboard instantiateInitialViewController];
    theLetterScene = [[LetterScene alloc] initWithSize:[UIScreen mainScreen].bounds.size andLetter:@"A"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testWhenLetterSelectButtonIsTappedThenLetterSelectSceneIsLoaded {
    [tester tapViewWithAccessibilityLabel:@"Title Screen"];
    [tester waitForViewWithAccessibilityLabel:@"A"];
    [tester waitForAnimationsToFinishWithTimeout:5.0];
    [tester tapViewWithAccessibilityLabel:@"Letter Select Button"];
    [tester waitForViewWithAccessibilityLabel:@"Letter Select Screen"];
}

@end

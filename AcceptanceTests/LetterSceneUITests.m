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

static const NSTimeInterval animationCompletionTimeout = 5.0;

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

- (void)navigateToASceneAndWaitForAnimationsToFinish {
    [tester tapViewWithAccessibilityLabel:@"Title Screen"];
    [tester waitForViewWithAccessibilityLabel:@"A"];
    [tester waitForAnimationsToFinishWithTimeout:animationCompletionTimeout];
}

- (void)navigateToBSceneAndWaitForAnimationsToFinish {
    [self navigateToASceneAndWaitForAnimationsToFinish];
    [tester tapViewWithAccessibilityLabel:@"Next Button"];
    [tester waitForViewWithAccessibilityLabel:@"B"];
    [tester waitForAnimationsToFinishWithTimeout:animationCompletionTimeout];
}

- (void)testWhenLetterSelectButtonIsTappedThenLetterSelectSceneIsLoaded {
    [self navigateToASceneAndWaitForAnimationsToFinish];
    [tester tapViewWithAccessibilityLabel:@"Letter Select Button"];
    [tester waitForViewWithAccessibilityLabel:@"Letter Select Screen"];
}

- (void)testGivenTheASceneWhenTheNextButtonIsTappedThenTheBSceneIsLoaded {
    [self navigateToASceneAndWaitForAnimationsToFinish];
    [tester tapViewWithAccessibilityLabel:@"Next Button"];
    [tester waitForViewWithAccessibilityLabel:@"B"];
}

- (void)testGivenTheBSceneWhenThePreviousButtonIsTappedThenTheASceneIsLoaded {
    [self navigateToBSceneAndWaitForAnimationsToFinish];
    [tester tapViewWithAccessibilityLabel:@"Previous Button"];
    [tester waitForViewWithAccessibilityLabel:@"A"];
}

@end

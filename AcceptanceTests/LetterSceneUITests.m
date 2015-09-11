//
//  LetterSceneUITest.m
//  TheWriteTrack
//
//  Created by Mitch Clutter on 7/30/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LetterScene.h"
#import "Constants.h"

#import <UIKit/UIKit.h>
#import <KIF/KIF.h>
#import <XCTest/XCTest.h>

static const NSTimeInterval ANIMATION_COMPLETION_TIMEOUT = 5.0;

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
    [self navigateToASceneAndWaitForAnimationsToFinish];
    [tester tapViewWithAccessibilityLabel:LETTER_SELECT_BUTTON_NAME];
    [tester waitForViewWithAccessibilityLabel:@"Letter Select Screen"];
}

- (void)testGivenTheASceneWhenTheNextButtonIsTappedThenTheBSceneIsLoaded {
    [self navigateToASceneAndWaitForAnimationsToFinish];
    [tester tapViewWithAccessibilityLabel:NEXT_BUTTON_NAME];
    [tester waitForViewWithAccessibilityLabel:@"B"];
}

- (void)testGivenTheBSceneWhenThePreviousButtonIsTappedThenTheASceneIsLoaded {
    [self navigateToBSceneAndWaitForAnimationsToFinish];
    [tester tapViewWithAccessibilityLabel:PREVIOUS_BUTTON_NAME];
    [tester waitForViewWithAccessibilityLabel:@"A"];
}

- (void)testGivenTheDemoIsActiveWhenTheSkipDemoButtonIsPressedThenTheDemoIsCancelled {
    [self navigateToASceneAndWaitForAnimationsToFinish];
    TrackContainer *track = (TrackContainer *)[theLetterScene childNodeWithName:LetterSceneTrackContainerNodeName];
    XCTAssertTrue([track isDemoing]);
    [tester tapViewWithAccessibilityLabel:SKIP_DEMO_BUTTON_NAME];
    XCTAssertFalse([track isDemoing]);
}

- (void)navigateToASceneAndWaitForAnimationsToFinish {
    [self tapViewWithLabel:@"Title Screen" andWaitForAnimationsToFinishOnViewWithLabel:@"A"];
}

- (void)navigateToBSceneAndWaitForAnimationsToFinish {
    [self navigateToASceneAndWaitForAnimationsToFinish];
    [self tapViewWithLabel:NEXT_BUTTON_NAME andWaitForAnimationsToFinishOnViewWithLabel:@"B"];
}

- (void)tapViewWithLabel:(NSString *)viewToTap andWaitForAnimationsToFinishOnViewWithLabel:(NSString *)viewToWaitFor {
    [tester tapViewWithAccessibilityLabel:viewToTap];
    [tester waitForViewWithAccessibilityLabel:viewToWaitFor];
    [tester waitForAnimationsToFinishWithTimeout:ANIMATION_COMPLETION_TIMEOUT];
}

@end

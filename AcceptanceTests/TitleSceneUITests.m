//
//  TitleSceneUITests.m
//  TheWriteTrack
//
//  Created by Mitch Clutter on 7/13/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "TitleScene.h"

#import <UIKit/UIKit.h>
#import <KIF/KIF.h>
#import <SpriteKit/SpriteKit.h>
#import "Constants.h"

@interface TitleSceneUITests : KIFTestCase {
    TitleScene *theTitleScene;
}

@end

@implementation TitleSceneUITests

- (void)setUp {
    [super setUp];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    window.rootViewController = [window.rootViewController.storyboard instantiateInitialViewController];
    theTitleScene = [[TitleScene alloc] initWithSize:[UIScreen mainScreen].bounds.size];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testWhenTitleSceneTappedThenASceneIsLoaded {
    [tester tapViewWithAccessibilityLabel:TITLE_SCENE_ACCESSIBILITY_LABEL];
    [tester waitForViewWithAccessibilityLabel:@"A"];
}

// Tests defect behavior that touching the screen at the location of the signal light
// does not allow the transition to the A scene. This was because userInteractionEnabled
// was set to true on the signal light, meaning it was expected to handle it's own touches
// instead of doing what the parent does.
// This test also proves out that KIF opens up a new level of "UI" testing
// Also NOTE: A smaller custom size for the title scene will cause this to pass (assume rounding issue on the signal light point)
// End Novel
- (void)testWhenTheSignalLightAreaIsTappedThenThenTheASceneIsLoaded {
    [tester waitForViewWithAccessibilityLabel:TITLE_SCENE_ACCESSIBILITY_LABEL];
    SKNode *signalLightNode = [theTitleScene childNodeWithName:SIGNAL_LIGHT_NAME];
    [tester tapScreenAtPoint:signalLightNode.position];
    [tester waitForViewWithAccessibilityLabel:@"A"];
}

@end

//
//  TitleSceneUITests.m
//  TheWriteTrack
//
//  Created by Mitch Clutter on 7/13/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KIF/KIF.h>
#import <SpriteKit/SpriteKit.h>

@interface TitleSceneUITests : KIFTestCase

@end

@implementation TitleSceneUITests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testWhenTitleSceneTappedThenASceneIsLoaded {
    [tester tapViewWithAccessibilityLabel:@"TitleScene"];
    [tester waitForViewWithAccessibilityLabel:@"A"];
}

- (void)testWhenTitleSceneIsLoadedThenATrainMovesAcrossTheScreen {
    UIView *view = [tester waitForTappableViewWithAccessibilityLabel:@"TitleScene"];
    UIAccessibilityElement *element = [view accessibilityElements][0];
    XCTAssertGreaterThan([view accessibilityElements].count, 0);
    for (UIAccessibilityElement *e in [view accessibilityElements]) {
        NSLog(@"AE ID: %@\nAE Label: %@", e.accessibilityIdentifier, e.accessibilityLabel);
    }
    [tester waitForAccessibilityElement:&element view:&view withIdentifier:@"TitleScene" tappable:YES];
}

@end

//
//  TitleSceneUITests.m
//  TheWriteTrack
//
//  Created by Mitch Clutter on 7/13/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KIF/KIF.h>

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
    [tester waitForTappableViewWithAccessibilityLabel:@"A"];
}

@end

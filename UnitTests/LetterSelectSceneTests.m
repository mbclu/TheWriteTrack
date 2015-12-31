//
//  LetterSelectSceneTest.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 6/20/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LetterSelectScene.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "CGMatchers.h"
#import "Constants.h"

@interface LetterSelectSceneTest : XCTestCase {
    LetterSelectScene *theLetterSelectScene;
}

@end

@implementation LetterSelectSceneTest

- (void)setUp {
    [super setUp];
    theLetterSelectScene = [[LetterSelectScene alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testScaleModeIsAspectFit {
    XCTAssertEqual(theLetterSelectScene.scaleMode, SKSceneScaleModeAspectFill);
}

- (void)testSceneSizeIsMainScreenSize {
    XCTAssertEqualSizes(theLetterSelectScene.size, [UIScreen mainScreen].bounds.size);
}

- (void)testBlendModeIsAlpha {
    XCTAssertEqual(theLetterSelectScene.blendMode, SKBlendModeAlpha);
}

- (void)testIsASettingsAccessScreenWithSettingsAccessButtonOnTop {
    XCTAssertTrue([theLetterSelectScene isKindOfClass:[SettingsAccessScene class]]);
    
    SKNode *settingsButton = [theLetterSelectScene childNodeWithName:SettingsAccessNode];
    XCTAssertNotNil(settingsButton);
    
    for (SKNode *node in [theLetterSelectScene children]) {
        XCTAssertLessThanOrEqual(node.zPosition, settingsButton.zPosition);
    }
}

@end

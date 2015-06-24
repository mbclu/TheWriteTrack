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

@end
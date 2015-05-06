//
//  ATests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 3/31/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "A.h"

@interface A_Tests : XCTestCase {
    A *a;
}

@end

@implementation A_Tests

- (void)setUp {
    [super setUp];
    a = [[A alloc] initWithSize:CGSizeMake(100, 100)];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testTheSceneUsesAspectScaleMode {
    XCTAssertEqual(a.scene.scaleMode, SKSceneScaleModeAspectFill);
}

- (void)testAUsesTheRockyBackground {
    SKNode *background = [a childNodeWithName:ROCKY_BACKGROUND];
    XCTAssertNotNil(background);
}

- (void)testAIsNamedA {
    XCTAssertEqualObjects(a.name, @"A");
}

- (void)testThereIsAnAttributedStringWithTheLetter_A {
    XCTAssertEqualObjects(a.stringPath.attributedString.string, @"A");
}

- (void)testAViewObjectIsCreatedWithTheLetterA {
    XCTAssertTrue(NO);
}

@end

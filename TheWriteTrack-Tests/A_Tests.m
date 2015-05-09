//
//  ATests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 3/31/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "A.h"

#define XCTAssertEqualRects(rect1, rect2)                   \
{                                                           \
    XCTAssertEqual(rect1.origin.x, rect2.origin.x);         \
    XCTAssertEqual(rect1.origin.y, rect2.origin.y);         \
    XCTAssertEqual(rect1.size.width, rect2.size.width);     \
    XCTAssertEqual(rect1.size.height, rect2.size.height);   \
}

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
    SKNode *background = [a childNodeWithName:@"RockyBackground"];
    XCTAssertNotNil(background);
}

- (void)testAIsNamedA {
    XCTAssertEqualObjects(a.name, @"A");
}

- (void)testAnSKPathNodeExistsAsAChildOfTheScene {
    AttributedStringPath *aspForTest = [[AttributedStringPath alloc] initWithString:@"A"];
    SKNode *letterNode = [a childNodeWithName:@"LetterNode"];
    XCTAssertNotNil(letterNode);
    XCTAssertTrue([letterNode isKindOfClass:[SKShapeNode class]]);
//    XCTAssertEqualObjects((__strong id)aspForTest.letterPath,
//                          (__strong id)a.stringPathView.attributedStringPath.letterPath);
}

@end

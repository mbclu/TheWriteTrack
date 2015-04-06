//
//  ATests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 3/31/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "A.h"

@interface A_Tests : XCTestCase

@end

@implementation A_Tests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThatTheSceneUsesAspectScaleMode {
    CGSize size = [UIScreen mainScreen].bounds.size;
    A *a = [[A alloc] initWithSize:size];
    XCTAssertEqual(a.scene.scaleMode, SKSceneScaleModeAspectFill);
}

- (void)testThatAUsesTheBaseBackground {
    A *a = [[A alloc] initWithSize:[UIScreen mainScreen].bounds.size];
    SKNode *background = [a childNodeWithName:@"_BaseBackground"];
    XCTAssertNotNil(background);
    //    XCTAssertEqualObjects([a scene].view, background);
}

@end

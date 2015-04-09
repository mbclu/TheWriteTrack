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

- (void)testThatTheSceneUsesAspectScaleMode {
    XCTAssertEqual(a.scene.scaleMode, SKSceneScaleModeAspectFill);
}

- (void)testThatAUsesTheRockyBackground {
    SKNode *background = [a childNodeWithName:@"RockyBackground"];
    XCTAssertNotNil(background);
}

@end

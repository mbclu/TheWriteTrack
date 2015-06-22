//
//  LetterSelectButtonTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 6/21/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LetterSelectButton.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "CGMatchers.h"
#import "LayoutMath.h"

@interface LetterSelectButtonTests : XCTestCase {
    LetterSelectButton *theSelectButton;
    SKNode *theANode;
    SKNode *theBNode;
    SKNode *theCNode;
}

@end

@implementation LetterSelectButtonTests

- (void)setUp {
    [super setUp];
    theSelectButton = [[LetterSelectButton alloc] init];
    theANode = [theSelectButton childNodeWithName:@"ANode"];
    theBNode = [theSelectButton childNodeWithName:@"BNode"];
    theCNode = [theSelectButton childNodeWithName:@"CNode"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testTheLetterSelectButtonHasALetter_A_Node {
    XCTAssertNotNil(theANode);
}

- (void)testTheLetterSelectButtonHasALetter_B_Node {
    XCTAssertNotNil(theBNode);
}

- (void)testTheLetterSelectButtonHasALetter_C_Node {
    XCTAssertNotNil(theCNode);
}

- (void)testThe_A_NodeIsPositionedAtOrigin {
    XCTAssertEqualPoints(theANode.position, CGPointZero);
}

- (void)testThe_B_NodeIsPositioned_5_PixelsRightAnd_10_PixelsUpFromThe_A_Node {
    CGPoint expectedPoint = theANode.position;
    INCREMENT_POINT_BY_POINT(expectedPoint, CGPointMake(theANode.frame.size.width + 5, 10));
    XCTAssertEqualPoints(theBNode.position, expectedPoint);
}

- (void)testThe_C_NodeIsPositioned_5_PixelsRightAnd_5_PixelsDownFromThe_B_Node {
    CGPoint expectedPoint = theBNode.position;
    INCREMENT_POINT_BY_POINT(expectedPoint, CGPointMake(theBNode.frame.size.width + 5, -5));
    XCTAssertEqualPoints(theCNode.position, expectedPoint);
}

@end

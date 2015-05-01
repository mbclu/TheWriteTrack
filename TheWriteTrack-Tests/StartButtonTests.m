//
//  StartButtonTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/30/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "StartButton.h"
#import "AttributedStringPath.h"
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

@interface StartButtonTests : XCTestCase

@property StartButton *startButton;

@end

@implementation StartButtonTests

@synthesize startButton;

- (void)setUp {
    [super setUp];
    startButton = [[StartButton alloc] initWithLetterConverter:nil];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testTheStartButtonHasANonNilLetterConverter {
    XCTAssertNotNil([startButton letterConverter]);
}

- (void)testTheNumberOfChildNodesIsEqualToTheNumberLettersInString {
    XCTAssertEqual(startButton.children.count, 5);
}

- (void)testNodesAddedAreOfTypeSKEmitter {
    SKNode *node = [[startButton children] objectAtIndex:0];
    XCTAssertTrue([node isKindOfClass:[SKEmitterNode class]]);
}

- (void)testTheStartButtonEmittersLoadFromTheOrangeSmokePNG {
    SKEmitterNode *node = [[startButton children] objectAtIndex:0];
    XCTAssertNotEqual([node.particleTexture.description rangeOfString:@"OrangeSmoke.png"].location, NSNotFound);
}

- (void)testTheStartButtonEmittersHaveARepeatAction {
    SKEmitterNode *node = [[startButton children] objectAtIndex:0];
    XCTAssertNotEqual([node.particleAction.description rangeOfString:@"SKRepeat"].location, NSNotFound);
}

- (void)testInitWithStringConvertsTheString_s_t_a_r_t_ToAnArray {
    NSString *expectedString = @"start";
    id lcMock = OCMClassMock([LetterConverter class]);
    startButton = [[StartButton alloc] initWithLetterConverter:lcMock];
    OCMVerify([lcMock getLetterArrayFromString:expectedString]);
}

//- (void)testARepeatFollowActionWithFontSizeOneHundredIsCreatedForEachLetter {
//    NSString *expectedString = @"start";
//    id lcMock = OCMClassMock([LetterConverter class]);
//    startButton = [[StartButton alloc] initWithLetterConverter:lcMock];
//    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"s"];
////    [[lcMock stub] andReturnValue:(NSValue *)attrString];
//    OCMVerify([lcMock createAttributedString:@"s" WithFontSizeInPoints:100]);
////    OCMVerify([lcMock createPathAtZeroUsingAttrString:attrString]);
//}

- (void)testARepeatFollowActionWithFontSizeOneHundredIsCreatedForEachLetter {
    NSString *expectedString = @"start";
    id lcMock = OCMClassMock([LetterConverter class]);
    id aspMock = OCMClassMock([AttributedStringPath class]);
    startButton = [[StartButton alloc] initWithLetterConverter:lcMock];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"s"];
    //    [[lcMock stub] andReturnValue:(NSValue *)attrString];
    OCMVerify([aspMock createAttributedString:@"s" WithFontSizeInPoints:100]);
    //    OCMVerify([lcMock createPathAtZeroUsingAttrString:attrString]);
}

@end

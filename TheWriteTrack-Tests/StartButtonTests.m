//
//  StartButtonTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/30/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "StartButton.h"
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
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInitWithStringConvertsTheString_s_t_a_r_t_ToAnArray {
    NSString *expectedString = @"start";
    id lcMock = OCMClassMock([LetterConverter class]);
    startButton = [[StartButton alloc] initWithLetterConverter:lcMock];
    OCMVerify([lcMock getLetterArrayFromString:expectedString]);
}

- (void)testTheStartButtonHasANonNilLetterConverter {
    startButton = [[StartButton alloc] initWithLetterConverter:nil];
    XCTAssertNotNil([startButton letterConverter]);
}

//- (void)testTheNumberOfChildNodesIsEqualToTheNumberLettersInString {
//    StartButton *startButton = start
//}

@end

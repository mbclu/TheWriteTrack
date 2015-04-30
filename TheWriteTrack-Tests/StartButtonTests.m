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

@end

@implementation StartButtonTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInitWithStringConvertsTheString_s_t_a_r_t_ToAnArray {
    NSString *expectedString = @"start";
    id lcMock = OCMClassMock([LetterConverter class]);
    StartButton *startButton = [[StartButton alloc] init];
    startButton.letterConverter = lcMock;
    [startButton create];
    OCMVerify([lcMock getLetterArrayFromString:expectedString]);
}

//- (void)testTheNumberOfChildNodesIsEqualToTheNumberLettersInString

@end

//
//  LetterConverterTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/25/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <OCMock/OCMock.h>
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "LetterConverter.h"

@interface LetterConverterTests : XCTestCase

@end

@implementation LetterConverterTests
{
    LetterConverter *letterConverter;
}

- (void)setUp {
    [super setUp];
    letterConverter = [[LetterConverter alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGivenANonAlphaCharacterThenNoPathIsReturned {
    XCTAssertNil((__strong id)[LetterConverter pathFromFirstCharOfStringRef:@"#"]);
}

- (void)testGivenAnAlphaCharacterThenNoPathIsReturned {
    XCTAssertNotNil((__strong id)[LetterConverter pathFromFirstCharOfStringRef:@"A"]);
}

- (void)testGivenNoDataANilAttributedStringIsReturned {
    XCTAssertNil((__strong id)[letterConverter createAttributedStringRef]);
}

- (void)testThatTheLetterConverterUsesVerdanaFontAsDefault {
    XCTAssertEqualObjects((CFStringRef)[letterConverter namedFont], (CFStringRef)@"Verdana");
}

- (void)testThatTheDefaultFontSizeIsOnePixel {
    XCTAssertEqual([letterConverter fontSize], 1.0);
}

- (void)testThatAUIFontIsCreatedFromTheDefaultFontTypeAndFontSize {
    id mockUIFont = OCMClassMock([UIFont class]);
    [letterConverter createAttributedStringRef];
    OCMVerify([mockUIFont fontWithName:[letterConverter namedFont] size:[letterConverter fontSize]]);
}

@end

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
    NSString* nilString;
    XCTAssertNil((__strong id)[LetterConverter createAttributedStringRef:nilString]);
}

- (void)testThatTheLetterConverterUsesVerdanaFontAsDefault {
    XCTAssertEqualObjects(NAMED_FONT, @"Verdana");
}

- (void)testThatTheDefaultFontSizeIsOnePixel {
    XCTAssertEqual(FONT_SIZE, 1.0);
}

- (void)testThatAUIFontIsCreatedFromTheDefaultFontTypeAndFontSize {
    id mockUIFont = OCMClassMock([UIFont class]);
    [LetterConverter createAttributedStringRef:@"A"];
    OCMVerify([mockUIFont fontWithName:NAMED_FONT size:FONT_SIZE]);
}

- (void)testThatAZeroIntegerIsUsedForTheAttributeDictionary {
    id mockNumber = OCMClassMock([NSNumber class]);
    [LetterConverter createAttributedStringRef:@"a"];
    OCMVerify([mockNumber numberWithInteger:0]);
}

- (void)testThatGivenTheLetter_A_AsAStringThenAnAtrributedStringWithLetter_A_IsReturned {
    CFAttributedStringRef actualRef = [LetterConverter createAttributedStringRef:@"A"];
    XCTAssertNotNil((__bridge NSAttributedString*)actualRef);
    XCTAssertEqualObjects([(__bridge NSAttributedString*)actualRef string], @"A");
}

- (void)testThatGivenTheLetter_B_AsAStringThenAnAtrributedStringWithLetter_B_IsReturned {
    CFAttributedStringRef actualRef = [LetterConverter createAttributedStringRef:@"B"];
    XCTAssertNotNil((__bridge NSAttributedString*)actualRef);
    XCTAssertEqualObjects([(__bridge NSAttributedString*)actualRef string], @"B");
}

@end
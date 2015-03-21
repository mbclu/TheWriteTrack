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
#import "../TheWriteTrack/LetterConverter.h"

@interface LetterConverterTests : XCTestCase

@end

@implementation LetterConverterTests
{
    NSString *nonNilString;
    LetterConverter *letterConverter;
    NSAttributedString *attrString;
    CTFontRef fontRef;
}

- (void)setUp {
    [super setUp];
    nonNilString = @"NonNilString";
    letterConverter = [[LetterConverter alloc] init];
    attrString = [LetterConverter createAttributedString:nonNilString];
    fontRef = (__bridge CTFontRef)[attrString attribute:(NSString *)kCTFontAttributeName atIndex:0 effectiveRange:nil];
}

- (void)tearDown {
    [super tearDown];
}

/// Attributed String Creation

- (void)testThatGivenNoDataANilAttributedStringIsReturned {
    NSString* nilString;
    XCTAssertNil([LetterConverter createAttributedString:nilString]);
}

- (void)testThatGivenANonNullStringANonNullAttributedStringIsReturned {
    XCTAssertNotNil([LetterConverter createAttributedString:nonNilString]);
}

- (void)testThatTheLetterConverterUsesVerdanaFont {
    XCTAssertEqualObjects(NAMED_FONT, @"Verdana");
    CFStringRef stringRef = CTFontCopyFullName(fontRef);
    XCTAssertEqualObjects((__bridge NSString *)stringRef, NAMED_FONT);
}

- (void)testThatTheFontSizeIsFiftyPixelsLessThanTheSmallestEdge {
    CGFloat expectedSize = 163;
    CGFloat accuracy = 1.0;
    CGFloat size = CTFontGetSize(fontRef);
    XCTAssertEqualWithAccuracy(size, expectedSize, accuracy);
}

- (void)testThatTheLetterConverterUsesOnlyTheFirstCharacterOfTheGivenString {
    XCTAssertEqualObjects(attrString.string, @"N");
}

- (void)testThatTheFontForegroundColorIsTransparent {
    UIColor *color = [attrString attribute:(NSString *)kCTForegroundColorAttributeName atIndex:0 effectiveRange:nil];
    XCTAssertEqualObjects(color, (id)[[UIColor clearColor] CGColor]);
}

- (void)testThatTheFontStrokeColorIsBrown {
    UIColor *color = [attrString attribute:(NSString *)kCTStrokeColorAttributeName atIndex:0 effectiveRange:nil];
    XCTAssertEqualObjects(color, (id)[[UIColor brownColor] CGColor]);
}

- (void)testThatTheFontStrokeIsSizeMinusThree {
    NSNumber *number = [attrString attribute:(NSString *)kCTStrokeWidthAttributeName atIndex:0 effectiveRange:nil];
    XCTAssertEqualObjects(number, (id)[NSNumber numberWithFloat:-3.0]);
}

/// Path Creation

- (void)testThatWhenTheAttributedStringIsNilThenThePathIsNil {
    XCTAssertNil([LetterConverter pathFromAttributedString:nil]);
}

- (void)testThatGivenANilPathAnExcpetionIsThrown {
    CTFontRef font;
    CGGlyph glyph;
    CGPoint point;
    CGMutablePathRef path = nil;
    XCTAssertThrows([LetterConverter addLetterFromFont:font andGlyph:glyph toPoint:point ofPath:path]);
}

- (void)testGivenANonAlphaCharacterThenNoPathIsReturned {
    XCTAssertNil((__strong id)[LetterConverter pathFromFirstCharOfStringRef:@"#"]);
}

- (void)testGivenAnAlphaCharacterThenNoPathIsReturned {
    XCTAssertNotNil((__strong id)[LetterConverter pathFromFirstCharOfStringRef:@"A"]);
}
/*
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
*/
@end
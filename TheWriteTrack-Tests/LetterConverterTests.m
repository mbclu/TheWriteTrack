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
#import "../TheWriteTrack/LayoutMath.h"
#import "PathInfo.h"

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
    CGFloat expectedSize = 325.0;
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
    XCTAssertNil((__bridge UIBezierPath *)[LetterConverter pathFromAttributedString:nil]);
}

- (void)testThatGivenANilPathWhenAGlyphIsAddedThenAnExcpetionIsThrown {
    CTFontRef font;
    CGGlyph glyph;
    CGMutablePathRef path = nil;
    XCTAssertThrows([LetterConverter addToCenterOfScreenLetterPath:path WithFont:font AndGlyph:glyph]);
}

- (void)testThatWhenARunFromALineIsEvxaminedAtIndex0ThenASingleGlyphIsReturned {
    // Expected Setup
    CTFontRef font = CTFontCreateWithName((CFStringRef)NAMED_FONT, [LayoutMath maximumViableFontSize], NULL);
    CGGlyph expectedGlyph;
    UniChar characters[] = { [@"N" characterAtIndex:0] };
    CTFontGetGlyphsForCharacters(font, characters, &expectedGlyph, 1);
    
    // Actual Setup
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, 0);
    CGGlyph glyph = [LetterConverter getSingleGlyphInRun:run atIndex:0];
    
    XCTAssertEqual(glyph, expectedGlyph);
}

@end

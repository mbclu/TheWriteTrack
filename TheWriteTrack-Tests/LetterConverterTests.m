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
#import "LayoutMath.h"
#import "PathInfo.h"
#import "CocoaLumberjack.h"

@interface LetterConverterTests : XCTestCase

@end

@implementation LetterConverterTests
{
    NSString *nonNilString;
    NSAttributedString *attrString;
    CTFontRef fontRef;
    CGFloat defaultAccuracy;
}

- (void)setUp {
    [super setUp];
    nonNilString = @"NonNilString";
    attrString = [LetterConverter createAttributedString:nonNilString];
    fontRef = (__bridge CTFontRef)[attrString attribute:(NSString *)kCTFontAttributeName atIndex:0 effectiveRange:nil];
    defaultAccuracy = 1.0;
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

- (void)testThatTheDefaultFontSizeIsFiftyPixelsLessThanTheSmallestEdge {
    CGFloat expectedSize = 325.0;
    CGFloat size = CTFontGetSize(fontRef);
    XCTAssertEqualWithAccuracy(size, expectedSize, defaultAccuracy);
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
    XCTAssertNil((__bridge UIBezierPath *)[LetterConverter createPathAtZeroUsingAttrString:nil]);
}

- (void)testThatWhenARunFromALineIsExaminedAtIndexZeroThenASingleGlyphIsReturned {
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

- (void)testThatWhenAFontSizeIsSuppliedThenItIsUsed {
    CGFloat expectedSize = 40.0;
    
    attrString = [LetterConverter createAttributedString:@"A" WithFontSizeInPoints:expectedSize];
    fontRef = (__bridge CTFontRef)[attrString attribute:(NSString *)kCTFontAttributeName atIndex:0 effectiveRange:nil];
    CGFloat size = CTFontGetSize(fontRef);

    XCTAssertEqualWithAccuracy(size, expectedSize, defaultAccuracy);
}

- (void)testThatWhenAStringAndASizeAreProvidedThenAPathIsProvidedDirectly {
    CGFloat expectedSize = 40.0;
    CGPathRef path = [LetterConverter createPathFromString:@"A" AndSize:expectedSize];

    XCTAssertFalse(CGPathIsEmpty(path));
}

- (void)testThatWhenAStartingPositionIsGivenToTheLetterConverterThenItIsUsed {
    CGPoint startingPoint = CGPointMake(15, 50);

    attrString = [LetterConverter createAttributedString:@"A" WithFontSizeInPoints:100];
    CGPathRef path = [LetterConverter createPathAtLocation:startingPoint UsingAttrString:attrString];
    CGRect fontBoundingBox = CGPathGetBoundingBox(path);
    
    XCTAssertEqualWithAccuracy(fontBoundingBox.origin.x, startingPoint.x, 1.3);
    XCTAssertEqualWithAccuracy(fontBoundingBox.origin.y, startingPoint.y, 1.3);
}

@end

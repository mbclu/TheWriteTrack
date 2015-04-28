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

void getFirstGlyphAndPositionFromAttrString(NSAttributedString *attrString,
                                            CGGlyph *glyph, CGPoint *position)
{
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, 0);
    [LetterConverter getSingleGlyph:glyph AndPosition:position InRun:run atIndex:0];
}

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

- (void)testThatTheDefaultFontTypeIsVerdana {
    CFStringRef stringRef = CTFontCopyFullName(fontRef);
    XCTAssertEqualObjects((__bridge NSString *)stringRef, @"Verdana");
}

- (void)testThatTheDefaultFontSizeIsFiftyPixelsLessThanTheSmallestEdge {
    CGFloat expectedSize = 325.0;
    CGFloat size = CTFontGetSize(fontRef);
    XCTAssertEqualWithAccuracy(size, expectedSize, defaultAccuracy);
}

- (void)testThatWhenAFontSizeIsSuppliedItIsUsedForTheAttributedString {
    CGFloat expectedSize = 40.0;

    attrString = [LetterConverter createAttributedString:nonNilString WithFontSizeInPoints:expectedSize];
    fontRef = (__bridge CTFontRef)[attrString attribute:(NSString *)kCTFontAttributeName atIndex:0 effectiveRange:nil];
    CGFloat size = CTFontGetSize(fontRef);

    XCTAssertEqualWithAccuracy(size, expectedSize, defaultAccuracy);
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
    CTFontRef font = CTFontCreateWithName((CFStringRef)NAMED_FONT, [LayoutMath maximumViableFontSize], NULL);
    CGGlyph expectedGlyph;
    UniChar characters[] = { [@"N" characterAtIndex:0] };
    CTFontGetGlyphsForCharacters(font, characters, &expectedGlyph, 1);
    
    CGGlyph glyph; CGPoint position;
    getFirstGlyphAndPositionFromAttrString(attrString, &glyph, &position);
    
    XCTAssertEqual(glyph, expectedGlyph);
}

- (void)testThatPositionDataIsDeterminedFromTheGlyph {
    CGGlyph glyph; CGPoint position;
    getFirstGlyphAndPositionFromAttrString(attrString, &glyph, &position);
    
    CGPoint expectedPosition = CGPointZero;
    XCTAssertEqualWithAccuracy(position.x, expectedPosition.x, defaultAccuracy);
    XCTAssertEqualWithAccuracy(position.y, expectedPosition.y, defaultAccuracy);
}

@end

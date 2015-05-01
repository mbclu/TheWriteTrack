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

void getGlyphAndPositionFromAttrString(LetterConverter *letterConverter, NSAttributedString *attrString,
                                        CGGlyph *glyph, CGPoint *position, NSInteger index)
{
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, index);
    [letterConverter getSingleGlyph:glyph AndPosition:position InRun:run atIndex:index];
}

@implementation LetterConverterTests
{
    NSString *nonNilString;
    NSAttributedString *attrString;
    CTFontRef fontRef;
    CGFloat defaultAccuracy;
    LetterConverter *letterConverter;
}

- (void)setUp {
    [super setUp];
    nonNilString = @"NonNilString";
    letterConverter = [[LetterConverter alloc] init];
    attrString = [letterConverter createAttributedString:nonNilString WithFontSizeInPoints:100];
    fontRef = (__bridge CTFontRef)[attrString attribute:(NSString *)kCTFontAttributeName atIndex:0 effectiveRange:nil];
    defaultAccuracy = 1.0;
}

- (void)tearDown {
    [super tearDown];
}

/// Attributed String Creation

- (void)testTheDefaultFontTypeIsVerdana {
    CFStringRef stringRef = CTFontCopyFullName(fontRef);
    XCTAssertEqualObjects((__bridge NSString *)stringRef, @"Verdana");
}

- (void)testWhenAFontSizeIsSuppliedItIsUsedForTheAttributedString {
    CGFloat expectedSize = 40.0;

    attrString = [letterConverter createAttributedString:nonNilString WithFontSizeInPoints:expectedSize];
    fontRef = (__bridge CTFontRef)[attrString attribute:(NSString *)kCTFontAttributeName atIndex:0 effectiveRange:nil];
    CGFloat size = CTFontGetSize(fontRef);

    XCTAssertEqualWithAccuracy(size, expectedSize, defaultAccuracy);
}

- (void)testTheFontForegroundColorIsTransparent {
    UIColor *color = [attrString attribute:(NSString *)kCTForegroundColorAttributeName atIndex:0 effectiveRange:nil];
    XCTAssertEqualObjects(color, (id)[[UIColor clearColor] CGColor]);
}

- (void)testTheFontStrokeColorIsBrown {
    UIColor *color = [attrString attribute:(NSString *)kCTStrokeColorAttributeName atIndex:0 effectiveRange:nil];
    XCTAssertEqualObjects(color, (id)[[UIColor brownColor] CGColor]);
}

- (void)testTheFontStrokeIsSizeMinusThree {
    NSNumber *number = [attrString attribute:(NSString *)kCTStrokeWidthAttributeName atIndex:0 effectiveRange:nil];
    XCTAssertEqualObjects(number, (id)[NSNumber numberWithFloat:-3.0]);
}

/// Path Creation

- (void)testWhenTheAttributedStringIsNilThenThePathIsNil {
    XCTAssertNil((__bridge UIBezierPath *)[letterConverter createPathAtZeroUsingAttrString:nil]);
}

- (void)testWhenARunFromALineIsExaminedAtIndexZeroThenASingleGlyphIsReturned {
    CTFontRef font = CTFontCreateWithName((CFStringRef)NAMED_FONT, [LayoutMath maximumViableFontSize], NULL);
    CGGlyph expectedGlyph;
    UniChar characters[] = { [@"N" characterAtIndex:0] };
    CTFontGetGlyphsForCharacters(font, characters, &expectedGlyph, 1);
    
    CGGlyph glyph; CGPoint position;
    getGlyphAndPositionFromAttrString(letterConverter, attrString, &glyph, &position, 0);
    
    XCTAssertEqual(glyph, expectedGlyph);
}

- (void)testPositionDataIsDeterminedFromTheGlyph {
    CGGlyph glyph; CGPoint position;
    getGlyphAndPositionFromAttrString(letterConverter, attrString, &glyph, &position, 0);
    
    CGPoint expectedPosition = CGPointZero;
    XCTAssertEqualWithAccuracy(position.x, expectedPosition.x, defaultAccuracy);
    XCTAssertEqualWithAccuracy(position.y, expectedPosition.y, defaultAccuracy);
}

- (void)testGivenAStringWithMoreThanOneCharacterThenTheSameNumberOfLettersAreInTheAttributedString {
    NSString *sampleString = @"AB";
    attrString = [letterConverter createAttributedString:sampleString WithFontSizeInPoints:[LayoutMath maximumViableFontSize]];
    XCTAssertEqual(attrString.string.length, 2);
    XCTAssertEqualObjects(attrString.string, sampleString);
}

- (void)testGivenAnAttributedStringWithMultipleCharactersThenMoreThanOneLetterIsInThePath {
    CGFloat fontSize = 10;
    CGPathRef aLetterPath = [letterConverter createPathFromString:@"A" AndSize:fontSize];
    CGPathRef bLetterPath = [letterConverter createPathFromString:@"B" AndSize:fontSize];
    CGPathRef multiLetterPath = [letterConverter createPathFromString:@"AB" AndSize:fontSize];
    
    XCTAssertFalse(CGPathEqualToPath(aLetterPath, bLetterPath));
    XCTAssertFalse(CGPathEqualToPath(aLetterPath, multiLetterPath));
    XCTAssertFalse(CGPathEqualToPath(multiLetterPath, bLetterPath));
}

- (void)testTheLetterConverterHasAMethodToConvertAStringIntoAnArrayContainingEachLetterOfTheArrayAsASeparateObject {
    NSString *str = @"abc";
    LetterConverter *lc = [[LetterConverter alloc] init];
    NSArray *array = [lc getLetterArrayFromString:str];
    
    XCTAssertEqual(array.count, 3);
    XCTAssertEqualObjects(array[0], @"a");
    XCTAssertEqualObjects(array[1], @"b");
    XCTAssertEqualObjects(array[2], @"c");
}

@end

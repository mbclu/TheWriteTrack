//
//  AttributedStringPathTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/26/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "AttributedStringPath.h"
#import "LayoutMath.h"
#import "LetterConstants.h"
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <CoreText/CoreText.h>
#import <OCMock/OCMock.h>


NSString *const StringForInvalidUsage = @"?";
CGFloat const DefualtFontSizeComparisonAccuracy = 0.5;

@interface AttributedStringPathTests : XCTestCase

@end

@implementation AttributedStringPathTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testWhenProvidedANilStringTheAQuestionMarkIsUsed {
    NSString *string = nil;
    AttributedStringPath *stringPath = [[AttributedStringPath alloc] initWithString:string];
    XCTAssertEqualObjects(stringPath.attributedString.string, StringForInvalidUsage);
}

- (void)testWhenProvidedAnEmptyStringTheAQuestionMarkIsUsed {
    NSString *string = @"";
    AttributedStringPath *stringPath = [[AttributedStringPath alloc] initWithString:string];
    XCTAssertEqualObjects(stringPath.attributedString.string, StringForInvalidUsage);
}

- (void)testWhenProvidedANumericStringThenAQuestionMarkIsUsed {
    NSString *string = @"1";
    AttributedStringPath *stringPath = [[AttributedStringPath alloc] initWithString:string];
    XCTAssertEqualObjects(stringPath.attributedString.string, StringForInvalidUsage);
}

- (void)testWhenProvidedAWhiteSpaceStringThenAQuestionMarkIsUsed {
    NSString *string = @" ";
    AttributedStringPath *stringPath = [[AttributedStringPath alloc] initWithString:string];
    XCTAssertEqualObjects(stringPath.attributedString.string, StringForInvalidUsage);
}

- (void)testTheAttributedStringHasADefaultFontTypeOf {
    NSString *string = @"";
    AttributedStringPath *stringPath = [[AttributedStringPath alloc] initWithString:string];
    CTFontRef fontRef = (__bridge CTFontRef)[stringPath.attributedString attribute:(NSString *)kCTFontAttributeName atIndex:0 effectiveRange:nil];
    CFStringRef stringRef = CTFontCopyFullName(fontRef);
    XCTAssertEqualObjects((__bridge NSString *)stringRef, @"Thonburi");
}

- (void)testANonNilNonEmptyPathIsReturned {
    AttributedStringPath *stringPath = [[AttributedStringPath alloc] initWithString:@""];
    XCTAssertNotNil((__strong id)stringPath.letterPath);
    XCTAssertFalse(CGPathIsEmpty(stringPath.letterPath));
}

- (void)testTheFontSizeCanBeSuppliedToTheString {
    CGFloat expectedSize = 40.0;

    AttributedStringPath *stringPath = [[AttributedStringPath alloc] initWithString:@"" andSize:expectedSize];

    CTFontRef fontRef = (__bridge CTFontRef)[stringPath.attributedString attribute:(NSString *)kCTFontAttributeName atIndex:0 effectiveRange:nil];
    CGFloat size = CTFontGetSize(fontRef);
    
    XCTAssertEqualWithAccuracy(size, expectedSize, DefualtFontSizeComparisonAccuracy);
}

- (void)testTheDefaultFontSizeIsFiftyPixelsLessThanTheSmallestEdge {
    CGFloat expectedSize = 325.0;
    
    AttributedStringPath *stringPath = [[AttributedStringPath alloc] initWithString:@""];

    CTFontRef fontRef = (__bridge CTFontRef)[stringPath.attributedString attribute:(NSString *)kCTFontAttributeName atIndex:0 effectiveRange:nil];
    CGFloat size = CTFontGetSize(fontRef);
    
    XCTAssertEqualWithAccuracy(size, expectedSize, DefualtFontSizeComparisonAccuracy);
}

- (void)testTheLetterConverterIsNotNil {
    AttributedStringPath *stringPath = [[AttributedStringPath alloc] init];
    XCTAssertNotNil(stringPath.letterConverter);
}

- (void)testThePathIsCreatedFromTheAttributedString {
    id lcMock = OCMClassMock([LetterConverter class]);
    AttributedStringPath *stringPath = [[AttributedStringPath alloc] initWithLetterConverter:lcMock];
    CGFloat fontSize = [LayoutMath maximumViableFontSize];
    XCTAssertNotNil(stringPath);
    OCMVerify([lcMock createAttributedString:OCMOCK_ANY withFontType:DefaultLetterFont andSize:fontSize]);
    OCMVerify([lcMock createPathAtZeroUsingAttrString:OCMOCK_ANY]);
}

@end

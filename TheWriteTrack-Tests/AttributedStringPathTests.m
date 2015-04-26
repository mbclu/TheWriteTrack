//
//  AttributedStringPathTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/26/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "AttributedStringPath.h"
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <CoreText/CoreText.h>

#define EXPECTED_STRING_FOR_INVALID_USAGE   @"?"

@interface AttributedStringPathTests : XCTestCase

@end

@implementation AttributedStringPathTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThatWhenProvidedANilStringTheAQuestionMarkIsUsed {
    NSString *string = nil;
    AttributedStringPath *stringPath = [[AttributedStringPath alloc] initWithString:string];
    XCTAssertEqualObjects(stringPath.attributedString.string, EXPECTED_STRING_FOR_INVALID_USAGE);
}

- (void)testThatWhenProvidedAnEmptyStringTheAQuestionMarkIsUsed {
    NSString *string = @"";
    AttributedStringPath *stringPath = [[AttributedStringPath alloc] initWithString:string];
    XCTAssertEqualObjects(stringPath.attributedString.string, EXPECTED_STRING_FOR_INVALID_USAGE);
}

- (void)testThatWhenProvidedANumericStringThenAQuestionMarkIsUsed {
    NSString *string = @"1";
    AttributedStringPath *stringPath = [[AttributedStringPath alloc] initWithString:string];
    XCTAssertEqualObjects(stringPath.attributedString.string, EXPECTED_STRING_FOR_INVALID_USAGE);
}

- (void)testThatWhenProvidedAWhiteSpaceStringThenAQuestionMarkIsUsed {
    NSString *string = @" ";
    AttributedStringPath *stringPath = [[AttributedStringPath alloc] initWithString:string];
    XCTAssertEqualObjects(stringPath.attributedString.string, EXPECTED_STRING_FOR_INVALID_USAGE);
}

- (void)testThatTheAttributedStringHasADefaultFontTypeOfVerdana {
    NSString *string = @"";
    AttributedStringPath *stringPath = [[AttributedStringPath alloc] initWithString:string];
    CTFontRef fontRef = (__bridge CTFontRef)[stringPath.attributedString attribute:(NSString *)kCTFontAttributeName atIndex:0 effectiveRange:nil];
    CFStringRef stringRef = CTFontCopyFullName(fontRef);
    XCTAssertEqualObjects((__bridge NSString *)stringRef, @"Verdana");
}

- (void)testThatANonNilPathIsReturned {
    AttributedStringPath *stringPath = [[AttributedStringPath alloc] initWithString:@""];
    XCTAssertNotNil(stringPath.path);
}

@end

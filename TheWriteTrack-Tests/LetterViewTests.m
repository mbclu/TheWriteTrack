//
//  LetterViewTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 3/1/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "LetterView.h"
#import "LetterConverter.h"
#import "TestPathUtils.h"

@interface LetterViewTests : XCTestCase

@end

@implementation LetterViewTests {
    LetterView *letterView;
    NSMutableArray *paths;
    CGColorSpaceRef colorSpace;
    CGContextRef context;
}

- (void)setUp {
    [super setUp];
    paths = [[NSMutableArray alloc] init];
    letterView = [[LetterView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [letterView setAttrString:[LetterConverter createAttributedString:@"A"]];
    
    // Added this content according to blog post: http://eng.wealthfront.com/2014/03/unit-testing-drawrect.html
    CGFloat scaleFactor = [[UIScreen mainScreen] scale];
    colorSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate(NULL,
                                    letterView.bounds.size.width * scaleFactor,
                                    letterView.bounds.size.height * scaleFactor,
                                    8,
                                    letterView.bounds.size.width * scaleFactor * 4,
                                    colorSpace,
                                    (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    
    UIGraphicsPushContext(context);
}

- (void)tearDown {
    // Clean up from blog post
    UIGraphicsPopContext();
    CFRelease(colorSpace);
    CFRelease(context);
    [super tearDown];
}
//
//- (CGMutablePathRef)fakeCreatePath {
//    UIBezierPath *p = [[UIBezierPath alloc] init];
//    CGMutablePathRef pRef = [LetterConverter pathFromAttributedString:[LetterConverter createAttributedString:@"A"]];
//    p = (__bridge UIBezierPath *)pRef;
//    [paths addObject:p];
//    return p;
//}

- (void)testThatTheLetterViewHasAClearBackground {
    XCTAssertEqualObjects(letterView.backgroundColor, [UIColor clearColor]);
}

//- (void)testThatDrawRectCreatesABezierPath {
//    id mockLetterView = [OCMockObject partialMockForObject:letterView];
//    [[[mockLetterView expect] andCall:@selector(fakeCreatePath) onObject:self] createBezierPath];
//    
//    [letterView drawRect:letterView.bounds];
//    
//    OCMVerifyAll(mockLetterView);
//}

/*
#define AssertPathElementMatchesElement(EXPECTED, ACTUAL) STAssertTrue([EXPECTED isEqual:ACTUAL], @"Element mismatch:\n%@\n%@", EXPECTED, ACTUAL)
#define AssertPathElementsMatchElements(EXPECTED, ACTUAL) \
({ \
STAssertTrue([EXPECTED isKindOfClass:[NSArray class]], @"EXPECTED must be an NSArray: %@", EXPECTED); \
STAssertTrue([ACTUAL isKindOfClass:[NSArray class]], @"ACTUAL must be an NSArray: %@", ACTUAL); \
STAssertTrue(EXPECTED.count == ACTUAL.count, @"Wrong number of elements: %lu / %lu", (unsigned long)EXPECTED.count, (unsigned long)ACTUAL.count); \
for (NSUInteger i=0; i < EXPECTED.count; i++) { \
AssertPathElementMatchesElement([EXPECTED objectAtIndex:i], [ACTUAL objectAtIndex:i]); \
} \
})

- (void)testDrawRectCreatesTheCorrectPath {
    id mockLetterView = [OCMockObject partialMockForObject:letterView];
    [[[mockLetterView expect] andCall:@selector(fakeCreatePath) onObject:self] createBezierPath];

    [letterView drawRect:letterView.bounds];
    OCMVerifyAll(mockLetterView);
    
//    NSLog(letterView.attrString.string);
    
    NSArray *elements = [TestPathUtils createArrayOfElementsInPath:paths[0]];
    
    NSArray *expectedElements = @[[TestPathElement pathElementWithType:kCGPathElementMoveToPoint
                                                                points:@[[NSValue valueWithCGPoint:CGPointMake(0.0f, 84.0f)]]],
                                  [TestPathElement pathElementWithType:kCGPathElementAddLineToPoint
                                                                points:@[[NSValue valueWithCGPoint:CGPointMake(11.0f, 76.333328f)]]]
                                  ];
    XCTAssertEqualObjects(elements[0], expectedElements[0]);
}

- (void)testThatWhenTheRailIsDrawThenTheContextUsesTheIdentityTransformAsItsMatrix {
    XCTAssertTrue(NO);
}
*/
@end

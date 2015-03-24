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
#import <GameViewController.h>
#import <LetterConverter.h>

@interface LetterViewTests : XCTestCase

@end

@implementation LetterViewTests {
    GameViewController *gvc;
    LetterView *letterview;
    NSMutableArray *paths;
}

- (void)setUp {
    [super setUp];
    gvc = [[GameViewController alloc] init];
    letterview = [[[gvc view] subviews] objectAtIndex:0];
    paths = [[NSMutableArray alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (UIBezierPath *)fakeCreatePath {
    UIBezierPath *p = [[UIBezierPath alloc] init];
    [paths addObject:p];
    return p;
}

- (void)testThatTheLetterViewHasAClearBackground {
    XCTAssertEqualObjects(letterview.backgroundColor, [UIColor clearColor]);
}

- (void)testThatWhenTheRailIsDrawThenTheContextUsesTheIdentityTransformAsItsMatrix {
    XCTAssertTrue(NO);
}

- (void)testDrawRect {
    // Class Setup
    LetterView *lv = [[LetterView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [lv setAttrString:[LetterConverter createAttributedString:@"A"]];
    
    // Added this content according to blog post: http://eng.wealthfront.com/2014/03/unit-testing-drawrect.html
    CGFloat scaleFactor = [[UIScreen mainScreen] scale];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGRect bounds = lv.bounds;
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 bounds.size.width * scaleFactor,
                                                 bounds.size.height * scaleFactor,
                                                 8,
                                                 bounds.size.width * scaleFactor * 4,
                                                 colorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    UIGraphicsPushContext(context);

    // Mock setup
    id mockLetterView = [OCMockObject partialMockForObject:lv];
    [[[mockLetterView expect] andCall:@selector(fakeCreatePath) onObject:self] createBezierPath];
    
    // Method invocation
    [lv drawRect:lv.bounds];
    
    OCMVerifyAll(mockLetterView);
    
    // Clean up from blog post
    UIGraphicsPopContext();
    CFRelease(colorSpace);
    CFRelease(context);
}

@end

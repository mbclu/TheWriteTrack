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
#import "PathInfo.h"

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

- (void)testTheLetterViewHasAClearBackground {
    XCTAssertEqualObjects(letterView.backgroundColor, [UIColor clearColor]);
}

//- (void)testTheLetterIsMovedToTheCenterOfTheScreen {
//    XCTAssertEqual(letterView.
//}

@end

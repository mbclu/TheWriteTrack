//
//  TitleTrainTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/21/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TitleTrain.h"

@interface TitleTrainTests : XCTestCase

@end

@implementation TitleTrainTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThatTheTitleTrainIsLoadedFromTheTitleTrainImage {
    TitleTrain *train = [[TitleTrain alloc] initWithImageNamed:TITLE_TRAIN];
    XCTAssertNotNil(train);
    XCTAssertNotNil(train.texture);
    XCTAssertEqualObjects(train.name, TITLE_TRAIN);
}

@end

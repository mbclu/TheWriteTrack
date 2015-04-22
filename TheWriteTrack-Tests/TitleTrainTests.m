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
#import "CocoaLumberjack.h"

@interface TitleTrainTests : XCTestCase

@property TitleTrain *train;
@property SKAction *exitRightAction;

@end

@implementation TitleTrainTests

@synthesize train;
@synthesize exitRightAction;

- (void)setUp {
    train = [[TitleTrain alloc] initWithImageNamed:TITLE_TRAIN];
    exitRightAction = [train actionForKey:EXIT_SCENE_RIGHT];
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThatTheTitleTrainIsLoadedFromTheTitleTrainImage {
    XCTAssertNotNil(train);
    XCTAssertNotNil(train.texture);
    XCTAssertEqualObjects(train.name, TITLE_TRAIN);
}

- (void)testThatTheTitleTrainStartsAtTheCorrectPosition {
    XCTAssertEqual(train.position.x, TITLE_TRAIN_START_POSITION.x);
    XCTAssertEqual(train.position.y, TITLE_TRAIN_START_POSITION.y);
}

- (void)testThatTheTitleTrainHasAnActionToMove {
    XCTAssertNotNil(exitRightAction);
    XCTAssertNotEqual([exitRightAction.description rangeOfString:@"SKMove"].location, NSNotFound);
}

- (void)testThatTheTitleTrainMoveActionHasADurationOfEight {
    XCTAssertEqual(exitRightAction.duration, 8);
}

@end

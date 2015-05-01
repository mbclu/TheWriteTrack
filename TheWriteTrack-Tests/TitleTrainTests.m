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

- (void)testTheTitleTrainIsLoadedFromTheTitleTrainImage {
    XCTAssertNotNil(train);
    XCTAssertNotNil(train.texture);
    XCTAssertEqualObjects(train.name, TITLE_TRAIN);
}

- (void)testTheTitleTrainStartsAtTheCorrectPosition {
    XCTAssertEqual(train.position.x, TITLE_TRAIN_START_POSITION.x);
    XCTAssertEqual(train.position.y, TITLE_TRAIN_START_POSITION.y);
}

- (void)testTheTitleTrainHasAnActionToMove {
    XCTAssertNotNil(exitRightAction);
    XCTAssertNotEqual([exitRightAction.description rangeOfString:@"SKMove"].location, NSNotFound);
}

- (void)testTheTitleTrainMoveActionHasADurationOfEight {
    XCTAssertEqual(exitRightAction.duration, 8);
}

- (void)testASmokeEmitterCanBeCreatedWithTheOrangeSmokePng {
    SKEmitterNode *emitter = [TitleTrain createTrainSmokeEmitter];
    SKTexture *texture = [SKTexture textureWithImageNamed:@"OrangeSmoke.png"];
    XCTAssertEqual(emitter.particleTexture.size.height, texture.size.height);
    XCTAssertEqual(emitter.particleTexture.size.width, texture.size.width);
}

- (void)testWhenAppliedAtALocationThenTheTrainHasAChildSmokeEmitter {
    CGFloat xPoint = 10;
    CGFloat yPoint = 20;
    [train applySmokeEmitterAtPosition:CGPointMake(xPoint, yPoint)];
    SKEmitterNode *emitter = (SKEmitterNode *)[train childNodeWithName:ORANGE_SMOKE];
    XCTAssertEqual(emitter.position.x, xPoint);
    XCTAssertEqual(emitter.position.y, yPoint);
}

@end

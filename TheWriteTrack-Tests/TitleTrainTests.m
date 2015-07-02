//
//  TitleTrainTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/21/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "TitleTrain.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "CGMatchers.h"

NSString *const TitleTrainName = @"TitleTrain";
NSString *const TitleTrainImageName = @"LaunchTrain";

@interface TitleTrainTests : XCTestCase {
    TitleTrain *theTitleTrain;
    SKNode *theSmokeEmitter;
    SKAction *moveAction;
    SKAction *growAction;
}

@end

@implementation TitleTrainTests

- (void)setUp {
    theTitleTrain = [[TitleTrain alloc] init];
    theSmokeEmitter = [theTitleTrain childNodeWithName:@"SmokeEmitter"];
    moveAction = [theTitleTrain actionForKey:@"MoveLeftToRight"];
    growAction = [theTitleTrain actionForKey:@"ScaleUp"];
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testTheTitleTrainIsNameTitleTrain {
    XCTAssertNotNil(theTitleTrain);
    XCTAssertEqualObjects(theTitleTrain.name, @"TitleTrain");
}

- (void)testTheTitleTrainIsLoadedFromThePassedInImage {
    XCTAssertNotNil(theTitleTrain.texture);
    XCTAssertTrue([theTitleTrain.texture.description containsString:TitleTrainImageName]);
}

- (void)testASmokeEmitterExistsOnTheTrainWithOrangeSmokeTexture {
    XCTAssertNotNil(theSmokeEmitter);
    XCTAssertTrue([theSmokeEmitter isKindOfClass:[SKEmitterNode class]]);
}

- (void)testTheSmokeEmitterLoadsTheOrangeSmokeTexture {
    SKEmitterNode *smokeEmitter = (SKEmitterNode *)theSmokeEmitter;
    XCTAssertTrue([smokeEmitter.particleTexture.description containsString:@"OrangeSmoke"]);
    XCTAssertEqualSizes(smokeEmitter.particleTexture.size, [SKTexture textureWithImageNamed:@"OrangeSmoke"].size);
}

- (void)testTheSmokeEmitterIsLocatedAtCorrectPosition {
    XCTAssertEqualPoints(theSmokeEmitter.position, CGPointMake(theTitleTrain.size.width, theTitleTrain.size.height));
}

@end

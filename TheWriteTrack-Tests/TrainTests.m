//
//  TrainTests.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/19/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "Train.h"
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface TrainTests : XCTestCase {
    Train *theTrain;
}

@end

@implementation TrainTests

- (void)setUp {
    [super setUp];
    theTrain = [[Train alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testTrainNodeForMagicTrainTexture {
    XCTAssertTrue([theTrain.description containsString:@"MagicTrain"]);
}

- (void)testTrainNodeHasNameTrain {
    XCTAssertEqualObjects(theTrain.name, @"Train");
}

- (void)testWhenNoAttributedStringPathIsProvidedItIsNil {
    XCTAssertNil(theTrain.letterPath);
}

- (void)testWhenAnAttributedStringPathIsProvidedThenThatStringPathIsUsedAsTheTrainsLetterPath {
    AttributedStringPath *letterPath = [[AttributedStringPath alloc] initWithString:@"M"];
    Train *aTrain = [[Train alloc] initWithAttributedStringPath:letterPath];
    XCTAssertNotNil(aTrain.letterPath);
    XCTAssertEqualObjects(aTrain.letterPath, letterPath);
}

@end

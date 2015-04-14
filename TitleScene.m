//
//  TitleScene.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/7/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "TitleScene.h"
#import "Train.h"

#define TITLE_BACKGROUND @"TitleBackground"

@implementation TitleScene

- (void)addBackground {
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:TITLE_BACKGROUND];
    background.name = TITLE_BACKGROUND;
    background.anchorPoint = CGPointZero;
    background.zPosition = 0;
    [self addChild:background];
}

- (void)addTrain {
    Train *train = [Train spriteNodeWithImageNamed:TITLE_TRAIN_IMAGE_NAME];
    train.name = TRAIN_NODE;
    train.anchorPoint = CGPointZero;
    train.zPosition = 1;
    [self addChild:train];
}

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self setScaleMode:SKSceneScaleModeAspectFill];
        [self addBackground];
        [self addTrain];
    }
    return self;
}

@end

//
//  TitleScene.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/7/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "TitleScene.h"

#define TITLE_BACKGROUND @"TitleBackground"
#define TITLE_TRAIN @"TitleTrain"

@implementation TitleScene

- (void)addBackground {
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:TITLE_BACKGROUND];
    background.name = TITLE_BACKGROUND;
    background.anchorPoint = CGPointZero;
    background.zPosition = 0;
    [self addChild:background];
}

- (void)addTrain {
    SKSpriteNode *train = [SKSpriteNode spriteNodeWithImageNamed:TITLE_TRAIN];
    train.name = TITLE_TRAIN;
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

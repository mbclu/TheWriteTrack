//
//  TitleScene.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/7/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "TitleScene.h"
#import "Train.h"
#import "CocoaLumberjack.h"

#define TITLE_BACKGROUND @"TitleBackground"

@implementation TitleScene

- (void)addBackground {
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:TITLE_BACKGROUND];
    background.name = TITLE_BACKGROUND;
    background.anchorPoint = CGPointZero;
    background.zPosition = TitleBackgroundZOrder;
    [self addChild:background];
}

- (void)addTrain {
    Train *train = [Train spriteNodeWithImageNamed:TITLE_TRAIN_IMAGE_NAME];
    train.name = TRAIN_NODE;
    train.anchorPoint = CGPointZero;
    train.zPosition = TitleTrainZOrder;
    train.position = CGPointMake(123, 138);
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

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    SKSpriteNode *node = (SKSpriteNode*)[self childNodeWithName:TRAIN_NODE];
    UITouch *touch = [touches anyObject];
    node.position = [touch locationInNode:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    SKSpriteNode *node = (SKSpriteNode*)[self childNodeWithName:TRAIN_NODE];
    DDLogDebug(@"Train Node position: %@", NSStringFromCGPoint(node.position));
}

@end

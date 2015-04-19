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
#define TITLE_FOREGROUND @"TitleForeground"

@implementation TitleScene

- (void)AddNodeWithName:(NSString*)name AndImageNamed:(NSString*)imageName AndZOrder:(NSInteger)zOrder {
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:imageName];
    background.name = name;
    background.accessibilityLabel = name;
    background.anchorPoint = CGPointZero;
    background.zPosition = zOrder;
    [self addChild:background];
}

- (void)addBackground {
    [self AddNodeWithName:TITLE_BACKGROUND AndImageNamed:TITLE_BACKGROUND AndZOrder:TitleBackgroundZOrder];
}

- (void)addTrain {
    [self AddNodeWithName:TRAIN_NODE AndImageNamed:TITLE_TRAIN_IMAGE_NAME AndZOrder:TitleTrainZOrder];
    [self childNodeWithName:TRAIN_NODE].position = CGPointMake(123, 138);
}

- (void)addForeground {
    [self AddNodeWithName:TITLE_FOREGROUND AndImageNamed:TITLE_FOREGROUND AndZOrder:TitleForegroundZOrder];
}

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self setScaleMode:SKSceneScaleModeAspectFill];
        [self addBackground];
        [self addTrain];
        [self addForeground];
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

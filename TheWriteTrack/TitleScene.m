//
//  TitleScene.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/7/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "TitleScene.h"

#import "AttributedStringPath.h"
#import "LayoutMath.h"
#import "LetterScene.h"
#import "StartButton.h"
#import "TitleTrain.h"

#import "CocoaLumberjack.h"

@implementation TitleScene

- (void) anchorNode:(SKSpriteNode*)node atZeroAndZPosition:(NSInteger)zPosition {
    node.anchorPoint = CGPointZero;
    node.zPosition = zPosition;
    [self addChild:node];
}

- (void)addBackground {
    SKTexture *texture = [SKTexture textureWithImageNamed:TITLE_BACKGROUND];
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:texture size:self.size];
    background.name = TITLE_BACKGROUND;
    [self anchorNode:background atZeroAndZPosition:TitleBackgroundZOrder];
}

- (void)addTrain {
    TitleTrain *train = [[TitleTrain alloc] initWithImageNamed:TITLE_TRAIN];
    [train applySmokeEmitterAtPosition:CGPointMake(train.size.width + SMOKE_HORIZONTAL_OFFSET,
                                                   train.size.height + SMOKE_VERTICAL_OFFSET)];
    [self anchorNode:train atZeroAndZPosition:TitleTrainZOrder];
}

- (void)addForeground {
    SKSpriteNode *foreground = [[SKSpriteNode alloc] initWithImageNamed:TITLE_FOREGROUND];
    foreground.name = TITLE_FOREGROUND;
    [self anchorNode:foreground atZeroAndZPosition:TitleForegroundZOrder];
}

- (void)transitionToAScene {
    SKScene *aScene = [[LetterScene alloc] initWithSize:self.size andLetter:@"A"];
    SKTransition *transition = [SKTransition revealWithDirection:SKTransitionDirectionLeft duration:0.8];
    [self.view presentScene:aScene transition:transition];
    [self.view setIsAccessibilityElement:YES];
    [self.view setAccessibilityIdentifier:aScene.name];
}

- (void)addStartButtonSmoke {
    StartButton *startButton = [[StartButton alloc] init];
    startButton.name = START_BUTTON;
    startButton.zPosition = StartButtonZOrder;
    CGFloat xPoint = ([UIScreen mainScreen].bounds.size.width - startButton.frame.size.width) * 0.5;
    CGFloat yPoint = [UIScreen mainScreen].bounds.size.height - (startButton.frame.size.height + START_BUTTON_VERTICAL_OFFSET);
    startButton.position = CGPointMake(xPoint, yPoint);
    
    [startButton setTouchUpInsideTarget:self action:@selector(transitionToAScene)];
    
    [self addChild:startButton];
}

- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self setName:TITLE_SCENE];
        [self setScaleMode:SKSceneScaleModeAspectFill];
        [self addBackground];
        [self addTrain];
        [self addForeground];
        [self addStartButtonSmoke];
    }
    return self;
}

@end
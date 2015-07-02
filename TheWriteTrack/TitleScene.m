//
//  TitleScene.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/7/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "TitleScene.h"

#import "AttributedStringPath.h"
#import "Constants.h"
#import "LayoutMath.h"
#import "LetterScene.h"
#import "StartButton.h"
#import "TitleTrain.h"

#import "CocoaLumberjack.h"

#if (DEBUG)
NSString *const defaultStartLetter = @"M";
#else
NSString *const defaultStartLetter = @"A";
#endif

CGFloat const SmokeHorizontalOffset = -10;
CGFloat const SmokeVerticalOffset = -5;
NSTimeInterval const TransitionToASceneTimeInSeconds = 0.8;

@implementation TitleScene

- (void) anchorNode:(SKSpriteNode*)node atZeroAndZPosition:(NSInteger)zPosition {
    node.anchorPoint = CGPointZero;
    node.zPosition = zPosition;
    [self addChild:node];
}

- (void)addBackground {
    SKTexture *texture = [SKTexture textureWithImageNamed:@"LaunchScreen667x375"];
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:texture size:self.size];
    background.name = @"TitleBackground";
    [self anchorNode:background atZeroAndZPosition:BackgroundZOrder];
}

- (void)addTrain {
    TitleTrain *train = [[TitleTrain alloc] init];
    train.position = CGPointMake(-train.size.width, self.frame.size.height * 0.6);
    [self anchorNode:train atZeroAndZPosition:TrainZOrder];
}

- (void)addSignalLight {
    StartButton *startButton = [[StartButton alloc] init];
    startButton.name = @"SingalLight";
    startButton.zPosition = SignalLightZOrder;
    CGFloat xPoint = ([UIScreen mainScreen].bounds.size.width - startButton.frame.size.width) * 0.5;
    CGFloat yPoint = [UIScreen mainScreen].bounds.size.height - (startButton.frame.size.height + START_BUTTON_VERTICAL_OFFSET);
    startButton.position = CGPointMake(xPoint, yPoint);
    
    [startButton setTouchUpInsideTarget:self action:@selector(transitionToAScene)];
    
    [self addChild:startButton];
}

- (void)transitionToAScene {
    SKScene *aScene = [[LetterScene alloc] initWithSize:self.size andLetter:defaultStartLetter];
    SKTransition *transition = [SKTransition revealWithDirection:SKTransitionDirectionLeft duration:TransitionToASceneTimeInSeconds];
    [self.view presentScene:aScene transition:transition];
    [self.view setIsAccessibilityElement:YES];
    [self.view setAccessibilityIdentifier:aScene.name];
}

- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self setName:@"TitleScene"];
        [self setScaleMode:SKSceneScaleModeAspectFill];
        [self addBackground];
        [self addTrain];
        [self addSignalLight];
    }
    return self;
}

@end

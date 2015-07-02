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

- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self setName:@"TitleScene"];
        [self setScaleMode:SKSceneScaleModeAspectFill];
        [self addBackground];
        [self addTrain];
        [self createTrainActions];
        [self addSignalLight];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [self runTrainActions];
}

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
    train.position = CGPointMake(-train.size.width, HALF_OF(self.frame.size.height));
    [self anchorNode:train atZeroAndZPosition:TrainZOrder];
}

- (void)addSignalLight {
    StartButton *startButton = [[StartButton alloc] init];
    startButton.name = @"SingalLight";
    startButton.zPosition = SignalLightZOrder;
    startButton.position = CGPointMake(self.size.width * 0.85, self.size.height * 0.55);
    
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

- (void)createTrainActions {
    CGPoint exitEndPosition = CGPointMake([UIScreen mainScreen].bounds.size.width + self.size.width * 0.6, self.size.height * -0.2);
    _moveLeftToRightAction = [SKAction moveTo:exitEndPosition duration:4];
    _scaleUpAction = [SKAction scaleTo:2.5 duration:4];
}

- (void)runTrainActions {
    SKNode *train = [self childNodeWithName:@"TitleTrain"];
    [train runAction:_scaleUpAction withKey:@"ScaleUp"];
    [train runAction:_moveLeftToRightAction withKey:@"MoveLeftToRight"];
}


@end

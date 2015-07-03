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

NSString *const defaultStartLetter = @"A";
NSTimeInterval const TransitionToASceneTimeInSeconds = 0.8;
NSTimeInterval const SceneActionTimeInSeconds = 3;

@implementation TitleScene

- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self setName:@"TitleScene"];
        [self setScaleMode:SKSceneScaleModeAspectFill];
        [self addBackground];
        [self addTrack];
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
    SKTexture *texture = [SKTexture textureWithImageNamed:@"LaunchScreen"];
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:texture size:self.size];
    background.name = @"TitleBackground";
    [self anchorNode:background atZeroAndZPosition:BackgroundZOrder];
}

- (void)addTrack {
    SKTexture *texture = [SKTexture textureWithImageNamed:@"LaunchScreenTrack"];
    SKSpriteNode *track = [SKSpriteNode spriteNodeWithTexture:texture size:CGSizeMake(self.size.width, HALF_OF(self.size.height))];
    track.name = @"TitleTrack";
    [self anchorNode:track atZeroAndZPosition:TrackZOrder];
}

- (void)addTrain {
    TitleTrain *train = [[TitleTrain alloc] init];
    train.position = CGPointMake(-HALF_OF(train.size.width), [self getTrack].frame.size.height);
    [self anchorNode:train atZeroAndZPosition:TrainZOrder];
}

- (void)addSignalLight {
    StartButton *startButton = [[StartButton alloc] init];
    startButton.name = @"SignalLight";
    startButton.zPosition = SignalLightZOrder;
    startButton.position = CGPointMake(self.size.width * 0.85, self.size.height * 0.45);
    
    [startButton setTouchUpInsideTarget:self action:@selector(transitionToAScene)];
    
    [self addChild:startButton];
}

- (void)transitionToAScene {
    SKScene *aScene = [[LetterScene alloc] initWithSize:self.size andLetter:defaultStartLetter];
    SKTransition *transition = [SKTransition flipHorizontalWithDuration:TransitionToASceneTimeInSeconds];
    [self.view presentScene:aScene transition:transition];
    [self.view setIsAccessibilityElement:YES];
    [self.view setAccessibilityIdentifier:aScene.name];
}

- (void)createTrainActions {
    SKNode *train = [self getTrain];
    SKNode *track = [self getTrack];
    CGPoint exitEndPosition = CGPointMake(HALF_OF(track.frame.size.width) - HALF_OF(train.frame.size.width),
                                          HALF_OF(track.frame.size.height) - HALF_OF(train.frame.size.height));
    _moveLeftToRightAction = [SKAction moveTo:exitEndPosition duration:SceneActionTimeInSeconds];
    _scaleUpAction = [SKAction scaleTo:1.5 duration:SceneActionTimeInSeconds];
}

- (void)runTrainActions {
    SKNode *train = [self childNodeWithName:@"TitleTrain"];
    [train runAction:_scaleUpAction withKey:@"ScaleUp"];
    [train runAction:_moveLeftToRightAction withKey:@"MoveLeftToRight"];
    
    StartButton *signal = (StartButton *)[self childNodeWithName:@"SignalLight"];
    [signal runAction:[SKAction customActionWithDuration:SceneActionTimeInSeconds actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        [self flashLight:[signal getRedLight] on:0.5 off:1.0 glow:8.0 elapsed:elapsedTime];
        [self flashLight:[signal getYellowLight] on:1.0 off:1.5 glow:8.0 elapsed:elapsedTime];
        [self flashLight:[signal getGreenLight] on:1.5 off:2.0 glow:8.0 elapsed:elapsedTime];
        [self flashLight:[signal getGreenLight] on:2.5 off:(SceneActionTimeInSeconds + 1) glow:15.0 elapsed:elapsedTime];
    }] withKey:@"FlashyLights"];
}

- (TitleTrain *)getTrain {
    return (TitleTrain *)[self childNodeWithName:@"TitleTrain"];
}

- (SKSpriteNode *)getTrack {
    return (SKSpriteNode *)[self childNodeWithName:@"TitleTrack"];
}

- (void)flashLight:(SKShapeNode *)light on:(CGFloat)onTime off:(CGFloat)offTime glow:(CGFloat)glowWidth elapsed:(CGFloat)elapsedTime {
    if (elapsedTime > onTime && elapsedTime < offTime) {
        light.glowWidth = glowWidth;
    }
    if (elapsedTime > offTime) {
        light.glowWidth = 2.0;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self transitionToAScene];
}

@end

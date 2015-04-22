//
//  TitleScene.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/7/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "TitleScene.h"
#import "TitleTrain.h"
#import "CocoaLumberjack.h"

#define TRAIN_MOVE_DURATION         6
#define TRAIN_MOVE_END_Y_POSITION   132
#define TRAIN_START_POSITION        CGPointMake(123, 138)

@implementation TitleScene

- (void)AddNodeWithImageNamed:(NSString*)imageName AndZOrder:(NSInteger)zOrder {
    SKSpriteNode *node = [[SKSpriteNode alloc] initWithImageNamed:imageName];
    node.name = imageName;
    node.anchorPoint = CGPointZero;
    node.zPosition = zOrder;
    [self addChild:node];
}

- (SKAction*)createExitSceneRightActionForTrain:(SKSpriteNode*)train {
    CGFloat nodeMovePositionX = [self size].width + train.size.width;
    SKAction * actionMove = [SKAction moveTo:CGPointMake(nodeMovePositionX, TRAIN_MOVE_END_Y_POSITION) duration:TRAIN_MOVE_DURATION];
    return actionMove;
}

- (void)addBackground {
    [self AddNodeWithImageNamed:TITLE_BACKGROUND AndZOrder:TitleBackgroundZOrder];
}

- (void)addTrain {
    [self AddNodeWithImageNamed:TITLE_TRAIN AndZOrder:TitleTrainZOrder];
    SKSpriteNode *train = (SKSpriteNode *)[self childNodeWithName:TITLE_TRAIN];
    train.position = TRAIN_START_POSITION;
    [train runAction:[self createExitSceneRightActionForTrain:train] withKey:ACTION_EXIT_SCENE_RIGHT];
}

- (void)addForeground {
    [self AddNodeWithImageNamed:TITLE_FOREGROUND AndZOrder:TitleForegroundZOrder];
}

- (SKEmitterNode *)spikeTrainSmokeEmitter {
    NSString *orangeSmokePath = [[NSBundle mainBundle] pathForResource:@"TitleSmoke" ofType:@"sks"];
    SKEmitterNode *orangeSmokeEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:orangeSmokePath];
    orangeSmokeEmitter.position = CGPointMake(100, 100);
    [self addChild:orangeSmokeEmitter];
    return orangeSmokeEmitter;
}

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self setName:TITLE_SCENE];
        [self setScaleMode:SKSceneScaleModeAspectFill];
        [self addBackground];
        [self addTrain];
        [self addForeground];
    }
    return self;
}

-(void)didMoveToView:(SKView *)view {
//    SKSpriteNode* trainNode = (SKSpriteNode*)[self childNodeWithName:TITLE_TRAIN];
//    CGFloat trainMoveX = [self size].width + trainNode.size.width;
//    SKAction * actionMove = [SKAction moveTo:CGPointMake(trainMoveX, 132) duration:10];
//    [trainNode runAction:actionMove withKey:ACTION_EXIT_SCENE_RIGHT];
}

//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    SKSpriteNode *node = (SKSpriteNode*)[self childNodeWithName:TITLE_TRAIN];
//    UITouch *touch = [touches anyObject];
//    node.position = [touch locationInNode:self];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    SKSpriteNode *node = (SKSpriteNode*)[self childNodeWithName:TITLE_TRAIN];
//    DDLogDebug(@"Train Node position: %@", NSStringFromCGPoint(node.position));
//}

@end

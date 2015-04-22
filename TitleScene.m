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
#import "LetterConverter.h"

@implementation TitleScene

- (void) anchorNode:(SKSpriteNode*)node atZeroAndZPosition:(NSInteger)zPosition {
    node.anchorPoint = CGPointZero;
    node.zPosition = zPosition;
    [self addChild:node];
}

- (void)addBackground {
    SKSpriteNode *background = [[SKSpriteNode alloc] initWithImageNamed:TITLE_BACKGROUND];
    background.name = TITLE_BACKGROUND;
    [self anchorNode:background atZeroAndZPosition:TitleBackgroundZOrder];
}

- (void)addTrain {
    TitleTrain *train = [[TitleTrain alloc] initWithImageNamed:TITLE_TRAIN];
    [self anchorNode:train atZeroAndZPosition:TitleTrainZOrder];
}

- (void)addForeground {
    SKSpriteNode *foreground = [[SKSpriteNode alloc] initWithImageNamed:TITLE_FOREGROUND];
    foreground.name = TITLE_FOREGROUND;
    [self anchorNode:foreground atZeroAndZPosition:TitleForegroundZOrder];
}

- (SKEmitterNode *)spikeTrainSmokeEmitter {
    SKEmitterNode *orangeSmokeEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:
                                         [[NSBundle mainBundle] pathForResource:@"TitleSmoke" ofType:@"sks"]];
    TitleTrain *train = [self childNodeWithName:TITLE_TRAIN];
//    orangeSmokeEmitter.position = CGPointMake(train.size.width - 10, train.size.height);
    orangeSmokeEmitter.position = CGPointMake(0, 0);
    NSAttributedString *attrString = [LetterConverter createAttributedString:@"T"];
    CGPathRef pathRef = [LetterConverter pathFromAttributedString:attrString];
    SKAction *followTrack = [SKAction followPath:pathRef asOffset:NO orientToPath:YES duration:1.0];
    SKAction *forever = [SKAction repeatActionForever:followTrack];
    orangeSmokeEmitter.particleAction = forever;
//    [orangeSmokeEmitter runAction:forever];
    
//    [train addChild:orangeSmokeEmitter];
    [self addChild:orangeSmokeEmitter];
    return orangeSmokeEmitter;
}

//- (SKEmitterNode *)spike_LetterT_SmokeEmitter {
//    SKEmitterNode *orangeSmokeEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:
//                                         [[NSBundle mainBundle] pathForResource:@"TitleSmoke" ofType:@"sks"]];
//    NSAttributedString *str = [LetterConverter createAttributedString:@"T"];
//    CGPathRef path = [LetterConverter pathFromAttributedString:str];
//    [orangeSmokeEmitter
//    TitleTrain *train = [self childNodeWithName:TITLE_TRAIN];
//    orangeSmokeEmitter.position = CGPointMake(train.size.width - 10, train.size.height);
//    [train addChild:orangeSmokeEmitter];
//    return orangeSmokeEmitter;
//}

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self setName:TITLE_SCENE];
        [self setScaleMode:SKSceneScaleModeAspectFill];
        [self addBackground];
        [self addTrain];
        [self addForeground];
        [self spikeTrainSmokeEmitter];
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

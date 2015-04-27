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
#import "AttributedStringPath.h"

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
    [train applySmokeEmitterAtPosition:CGPointMake(train.size.width - 10, train.size.height - 5)];
    [self anchorNode:train atZeroAndZPosition:TitleTrainZOrder];
}

- (void)addForeground {
    SKSpriteNode *foreground = [[SKSpriteNode alloc] initWithImageNamed:TITLE_FOREGROUND];
    foreground.name = TITLE_FOREGROUND;
    [self anchorNode:foreground atZeroAndZPosition:TitleForegroundZOrder];
}

- (SKEmitterNode *)addTitleString {
    SKEmitterNode *titleStringEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:
                                         [[NSBundle mainBundle] pathForResource:@"TitleSmoke" ofType:@"sks"]];
    titleStringEmitter.name = TITLE_STRING_EMITTER;
    
    AttributedStringPath *stringPath = [[AttributedStringPath alloc] initWithString:@"Anything"];
    SKAction *followTitleString = [SKAction followPath:stringPath.path speed:1.0];
    SKAction *repeatForever = [SKAction repeatActionForever:followTitleString];
    titleStringEmitter.particleAction = repeatForever;
    
    [self addChild:titleStringEmitter];
    
    return titleStringEmitter;
}

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self setName:TITLE_SCENE];
        [self setScaleMode:SKSceneScaleModeAspectFill];
        [self addBackground];
        [self addTrain];
        [self addForeground];
        [self addTitleString];
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

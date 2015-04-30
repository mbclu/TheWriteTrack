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
#import "AttributedStringPath.h"
#import "LayoutMath.h"

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
    [train applySmokeEmitterAtPosition:CGPointMake(train.size.width + SMOKE_HORIZONTAL_OFFSET,
                                                   train.size.height + SMOKE_VERTICAL_OFFSET)];
    [self anchorNode:train atZeroAndZPosition:TitleTrainZOrder];
}

- (void)addForeground {
    SKSpriteNode *foreground = [[SKSpriteNode alloc] initWithImageNamed:TITLE_FOREGROUND];
    foreground.name = TITLE_FOREGROUND;
    [self anchorNode:foreground atZeroAndZPosition:TitleForegroundZOrder];
}

// Spike this out and think about how it can be mocked properly for testing
- (void)addLetterAtIndex:(NSUInteger)index ofStringPath:(AttributedStringPath *)pathToFollow toNode:(SKSpriteNode *)node {
    SKEmitterNode *emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:
                               [[NSBundle mainBundle] pathForResource:START_STRING_SKS ofType:@"sks"]];
    CGPoint moveLocation = [LayoutMath originForUpperLeftPlacementOfPath:pathToFollow.path];
    emitter.position = moveLocation;
    SKAction *followStringPath = [SKAction followPath:pathToFollow.path
                                              asOffset:NO orientToPath:YES duration:FOLLOW_PATH_DURATION];
    SKAction *repeatForever = [SKAction repeatActionForever:followStringPath];
    emitter.particleAction = repeatForever;
    
    [node addChild:emitter];
}

- (void)addStartButtonSmoke:(AttributedStringPath *)pathToFollow {
    SKSpriteNode *startButton = [[SKSpriteNode alloc] init];
    startButton.name = START_SMOKE_TEXT;
    startButton.zPosition = StartButtonZOrder;

//    for (NSUInteger i; i < pathToFollow.attributedString.string.length; i++) {
        [self addLetterAtIndex:1 ofStringPath:pathToFollow toNode:startButton];
//    }
    
    [self addChild:startButton];
}

- (instancetype)initWithSize:(CGSize)size andStringPath:(AttributedStringPath *)stringPath {
    if (self = [super initWithSize:size]) {
        [self setName:TITLE_SCENE];
        [self setScaleMode:SKSceneScaleModeAspectFill];
        [self addBackground];
        [self addTrain];
        [self addForeground];
        [self addStartButtonSmoke:stringPath];
    }
    return self;
}

- (instancetype)initWithSize:(CGSize)size {
    self = [self initWithSize:size
                andStringPath:[[AttributedStringPath alloc] initWithString:START_SMOKE_TEXT andSize:START_SMOKE_SIZE]];
    return self;
}

-(void)didMoveToView:(SKView *)view {
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

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

- (void)addTitleString:(AttributedStringPath *)pathToFollow {
    SKEmitterNode *titleStringEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:
                                         [[NSBundle mainBundle] pathForResource:TITLE_STRING_SMOKE ofType:@"sks"]];
    titleStringEmitter.name = TITLE_STRING_SMOKE;
    
    CGPoint moveLocation = [LayoutMath originForUpperLeftPlacementOfPath:pathToFollow.path];
    titleStringEmitter.position = moveLocation;
    
    SKAction *followTitleString = [SKAction followPath:pathToFollow.path asOffset:NO orientToPath:YES duration:2.5];
    SKAction *repeatForever = [SKAction repeatActionForever:followTitleString];
    titleStringEmitter.particleAction = repeatForever;
    
    [self addChild:titleStringEmitter];
}

- (instancetype)initWithSize:(CGSize)size andStringPath:(AttributedStringPath *)stringPath {
    if (self = [super initWithSize:size]) {
        [self setName:TITLE_SCENE];
        [self setScaleMode:SKSceneScaleModeAspectFill];
        [self addBackground];
        [self addTrain];
        [self addForeground];
        [self addTitleString:stringPath];
    }
    return self;
}

- (instancetype)initWithSize:(CGSize)size {
    self = [self initWithSize:size
                andStringPath:[[AttributedStringPath alloc] initWithString:START_SMOKE andSize:START_SMOKE_SIZE]];
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

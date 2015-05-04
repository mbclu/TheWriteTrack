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
#import "StartButton.h"
#import "A.h"

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

- (void)startButtonAction {
    NSLog(@"Start button pressed!");
    SKScene *sampleScene = [[A alloc] initWithSize:self.size];
    SKTransition *transition = [SKTransition flipVerticalWithDuration:0.5];
    [self.view presentScene:sampleScene transition:transition];
}

- (void)addStartButtonSmoke {
    StartButton *startButton = [[StartButton alloc] init];
    startButton.name = START_BUTTON;
    startButton.zPosition = StartButtonZOrder;
    CGFloat xPoint = ([UIScreen mainScreen].bounds.size.width - startButton.frame.size.width) / 2;
    CGFloat yPoint = [UIScreen mainScreen].bounds.size.height - (startButton.frame.size.height + START_BUTTON_VERTICAL_OFFSET);
    startButton.position = CGPointMake(xPoint, yPoint);
    
    [startButton setTouchUpTarget:self action:@selector(startButtonAction)];
    
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"Touches on Title Scene!");
//    UITouch *touch = [touches anyObject];
//    CGPoint location = [touch locationInNode:self];
//    SKNode *node = [self nodeAtPoint:location];
//    
//    NSLog(@"Node : %@", node.name);
//    if ([node.name isEqualToString:START_BUTTON]) {
//        NSLog(@"Start button pressed!");
//        SKScene *sampleScene = [[A alloc] initWithSize:self.size];
//        SKTransition *transition = [SKTransition flipVerticalWithDuration:0.5];
//        [self.view presentScene:sampleScene transition:transition];
//    }
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

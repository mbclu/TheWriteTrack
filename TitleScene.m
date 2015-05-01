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
- (void)addLetterOfStringPath:(AttributedStringPath *)pathToFollow
                       toNode:(SKSpriteNode *)node
                   atLocation:(CGPoint)location
{
    SKEmitterNode *emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:
                               [[NSBundle mainBundle] pathForResource:START_STRING_SKS ofType:@"sks"]];

    emitter.position = location;
    
    SKAction *followStringPath = [SKAction followPath:pathToFollow.letterPath
                                              asOffset:NO orientToPath:YES duration:FOLLOW_PATH_DURATION];
    SKAction *repeatForever = [SKAction repeatActionForever:followStringPath];
    emitter.particleAction = repeatForever;
    
    [node addChild:emitter];
}

- (void)addStartButtonSmoke {
    SKSpriteNode *startButton = [[SKSpriteNode alloc] init];
    startButton.name = START_SMOKE_TEXT;
    startButton.zPosition = StartButtonZOrder;

    NSString *buttonText = START_SMOKE_TEXT;
//    NSArray *stringArray = [[NSArray alloc] initWithObjects:@"s", @"t", @"a", @"r", @"t"];
    
    AttributedStringPath *S = [[AttributedStringPath alloc] initWithString:
                               [buttonText substringFromIndex:0] andSize:START_SMOKE_SIZE];
    AttributedStringPath *T1 = [[AttributedStringPath alloc] initWithString:
                               [buttonText substringFromIndex:1] andSize:START_SMOKE_SIZE];
    AttributedStringPath *A = [[AttributedStringPath alloc] initWithString:
                               [buttonText substringFromIndex:2] andSize:START_SMOKE_SIZE];
    AttributedStringPath *R = [[AttributedStringPath alloc] initWithString:
                               [buttonText substringFromIndex:3] andSize:START_SMOKE_SIZE];
    AttributedStringPath *T2 = [[AttributedStringPath alloc] initWithString:
                               [buttonText substringFromIndex:4] andSize:START_SMOKE_SIZE];
    
    NSArray *stringArray = [[NSArray alloc] initWithObjects:S, T1, A, R, T2, nil];
    NSString *str = @"start";
    NSMutableArray *mutArray = [[NSMutableArray alloc] initWithCapacity:str.length];
    
    CGPoint firstLocation = [LayoutMath originForUpperLeftPlacementOfPath:S.letterPath];
    [self addLetterOfStringPath:S toNode:startButton atLocation:firstLocation];
    
    CGPoint nextLocation = [LayoutMath originForPath:T1.letterPath adjacentToPathOnLeft:S.letterPath];
    [self addLetterOfStringPath:T1 toNode:startButton atLocation:nextLocation];
    
    nextLocation.x += [LayoutMath originForPath:A.letterPath adjacentToPathOnLeft:T1.letterPath].x;
    [self addLetterOfStringPath:A toNode:startButton atLocation:nextLocation];
    
    nextLocation.x += [LayoutMath originForPath:R.letterPath adjacentToPathOnLeft:A.letterPath].x;
    [self addLetterOfStringPath:R toNode:startButton atLocation:nextLocation];
    
    nextLocation.x += [LayoutMath originForPath:T2.letterPath adjacentToPathOnLeft:R.letterPath].x;
    [self addLetterOfStringPath:T2 toNode:startButton atLocation:nextLocation];
    
    startButton.position = CGPointMake(180, -40);
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

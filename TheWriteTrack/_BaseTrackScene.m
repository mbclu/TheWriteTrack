//
//  _BaseTrack.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/11/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "_BaseTrackScene.h"
#import "Train.h"

#define ROCKY_BACKGROUND @"RockyBackground"

@implementation _BaseTrackScene

-(void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    /* Setup your scene here */
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self setScaleMode:SKSceneScaleModeAspectFill];
        
        SKSpriteNode *rockyBackground = [SKSpriteNode spriteNodeWithImageNamed:ROCKY_BACKGROUND];
        rockyBackground.anchorPoint = CGPointZero;
        rockyBackground.name = ROCKY_BACKGROUND;
        [self addChild:rockyBackground];
        
        Train *train = [Train spriteNodeWithImageNamed:MAGIC_TRAIN_IMAGE_NAME];
        train.position = CGPointMake(self.size.width / 2.0f, self.size.height / 2.0f);
        train.name = @"_BaseTrain";
        [self addChild:train];
    }
    return self;
}

@end

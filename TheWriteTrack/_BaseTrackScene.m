//
//  _BaseTrack.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/11/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "_BaseTrackScene.h"

@implementation _BaseTrackScene

-(void)didMoveToView:(SKView *)view {
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
        SKSpriteNode *rockyBackground = [SKSpriteNode spriteNodeWithImageNamed:@"RockyBackground"];
        rockyBackground.anchorPoint = CGPointZero;
        rockyBackground.name = @"_BaseBackground";
        [self addChild:rockyBackground];
    }
    return self;
}

@end

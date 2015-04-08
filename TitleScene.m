//
//  TitleScene.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/7/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "TitleScene.h"

@implementation TitleScene

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self setScaleMode:SKSceneScaleModeAspectFill];
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"TitleBackground"];
        background.name = @"TitleBackground";
        background.anchorPoint = CGPointZero;
        [self addChild:background];
    }
    return self;
}

@end

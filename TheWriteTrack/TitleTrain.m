//
//  TitleTrain.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/21/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "TitleTrain.h"

@implementation TitleTrain

- (instancetype)init {
    self = [super initWithImageNamed:@"LaunchTrain"];

    self.name = @"TitleTrain";
    
    [self addSmokeEmitter];
    
    [self runActions];
    
    return self;
}

- (void)addSmokeEmitter {
    SKEmitterNode *emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:
                              [[NSBundle mainBundle] pathForResource:@"OrangeSmoke" ofType:@"sks"]];
    emitter.name = @"SmokeEmitter";
    emitter.position = CGPointMake(self.size.width, self.size.height);
    [self addChild:emitter];
}

- (void)runActions {
    CGPoint exitEndPosition = CGPointMake([UIScreen mainScreen].bounds.size.width + self.size.width * 0.6, self.size.height * -0.2);
    SKAction *exitStageRight = [SKAction moveTo:exitEndPosition duration:4];
    SKAction *increaseInSize = [SKAction scaleTo:2.5 duration:4];
    [self runAction:increaseInSize withKey:@"ScaleUp"];
    [self runAction:exitStageRight withKey:@"MoveLeftToRight"];
}

@end

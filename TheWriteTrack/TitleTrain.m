//
//  TitleTrain.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/21/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "TitleTrain.h"

@implementation TitleTrain

- (instancetype)initWithImageNamed:(NSString *)name {
    self = [super initWithImageNamed:name];
    self.name = @"TitleTrain";
    self.position = TITLE_TRAIN_START_POSITION;
    CGPoint exitEndPosition = CGPointMake([UIScreen mainScreen].bounds.size.width + self.size.width, EXIT_RIGHT_END_Y_POSITION);
    SKAction *exitStageRight = [SKAction moveTo:exitEndPosition duration:EXIT_DURATION];
    [self runAction:exitStageRight withKey:EXIT_SCENE_RIGHT];
    return self;
}

- (void)applySmokeEmitterAtPosition:(CGPoint)position {
    SKEmitterNode *emitter = [TitleTrain createTrainSmokeEmitter];
    emitter.name = @"OrageSmoke";
    emitter.position = position;
    [self addChild:emitter];
}

+ (SKEmitterNode *)createTrainSmokeEmitter {
    SKEmitterNode *emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:
                              [[NSBundle mainBundle] pathForResource:@"OrangeSmoke" ofType:@"sks"]];
    return emitter;
}

@end

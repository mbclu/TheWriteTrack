//
//  TitleTrain.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/21/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

//#define TITLE_TRAIN                 @"TitleTrain"
#define TITLE_TRAIN_START_POSITION  CGPointMake(123, 138)
#define EXIT_SCENE_RIGHT            @"actionExitSceneRight"
#define EXIT_DURATION               8
#define EXIT_RIGHT_END_Y_POSITION   132
//#define TITLE_TRAIN_SMOKE           @"TitleTrainSmoke"
//#define ORANGE_SMOKE                @"OrangeSmoke"

@interface TitleTrain : SKSpriteNode

+ (SKEmitterNode *)createTrainSmokeEmitter;
- (void)applySmokeEmitterAtPosition:(CGPoint)position;

@end

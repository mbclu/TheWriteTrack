//
//  TitleTrain.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/21/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "TitleTrain.h"

@implementation TitleTrain

//- (SKAction*)createExitSceneRightActionForTrain:(SKSpriteNode*)train {
//    CGFloat nodeMovePositionX = [self size].width + train.size.width;
//    SKAction * actionMove = [SKAction moveTo:CGPointMake(nodeMovePositionX, TRAIN_MOVE_END_Y_POSITION) duration:TRAIN_MOVE_DURATION];
//    return actionMove;
//}

- (instancetype) initWithImageNamed:(NSString *)name {
    self = [super initWithImageNamed:name];
    self.name = TITLE_TRAIN;
    self.position = TITLE_TRAIN_START_POSITION;
    CGPoint exitEndPosition = CGPointMake([UIScreen mainScreen].bounds.size.width + self.size.width, EXIT_RIGHT_END_Y_POSITION);
    SKAction *exitStageRight = [SKAction moveTo:exitEndPosition duration:EXIT_DURATION];
    [self runAction:exitStageRight withKey:EXIT_SCENE_RIGHT];
    return self;
}

@end

//
//  TitleScene.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/7/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "AttributedStringPath.h"
#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSInteger, ETitleSceneZOrder) {
    BackgroundZOrder,
    SignalLightZOrder,
    TrainZOrder
};

@interface TitleScene : SKScene

@property SKAction *moveLeftToRightAction;
@property SKAction *scaleUpAction;

- (void)transitionToAScene;

@end

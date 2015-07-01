//
//  TitleScene.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/7/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "AttributedStringPath.h"
#import <SpriteKit/SpriteKit.h>

#define START_SMOKE_TEXT        @"start"

#define START_BUTTON_VERTICAL_OFFSET    20

@interface TitleScene : SKScene

typedef NS_ENUM(NSInteger, ETitleSceneZOrder) {
    BackgroundZOrder,
    TrainZOrder,
    SignalLightZOrder
};

- (void)transitionToAScene;

@end

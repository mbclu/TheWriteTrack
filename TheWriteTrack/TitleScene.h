//
//  TitleScene.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/7/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AttributedStringPath.h"
#import "SettingsAccessScene.h"

typedef NS_ENUM(NSInteger, ETitleSceneZOrder) {
    BackgroundZOrder,
    TrackZOrder,
    SignalLightZOrder,
    TrainZOrder
};

@interface TitleScene : SettingsAccessScene

@property SKAction *moveLeftToRightAction;
@property SKAction *scaleUpAction;

- (void)transitionToAScene;

@end

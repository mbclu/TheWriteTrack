//
//  TitleScene.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/7/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#define TITLE_SCENE @"TitleScene"
#define TITLE_BACKGROUND @"TitleBackground"
#define TITLE_FOREGROUND @"TitleForeground"
#define ACTION_EXIT_SCENE_RIGHT @"actionExitSceneRight"

@interface TitleScene : SKScene

//@property (nonatomic) SKSpriteNode *train;
//@property (nonatomic) SKSpriteNode *background;
//@property (nonatomic) SKSpriteNode *foreground;

typedef NS_ENUM(NSInteger, TitleNodeZOrder) {
    TitleBackgroundZOrder,
    TitleTrainZOrder,
    TitleForegroundZOrder
};

@end

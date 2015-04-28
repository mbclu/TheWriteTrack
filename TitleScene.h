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
#define TITLE_STRING_EMITTER @"TitleStringEmitter"
#define SMOKE_HORIZONTAL_OFFSET -10
#define SMOKE_VERTICAL_OFFSET   -5

@interface TitleScene : SKScene

typedef NS_ENUM(NSInteger, TitleNodeZOrder) {
    TitleBackgroundZOrder,
    TitleTrainZOrder,
    TitleForegroundZOrder
};

@end

//
//  TitleScene.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/7/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "AttributedStringPath.h"
#import <SpriteKit/SpriteKit.h>

#define START_SMOKE             @"START"
#define START_SMOKE_SIZE        100.0

#define TITLE_SCENE             @"TitleScene"
#define TITLE_BACKGROUND        @"TitleBackground"
#define TITLE_FOREGROUND        @"TitleForeground"
#define TITLE_STRING_SMOKE      @"TitleStringSmoke"

#define SMOKE_HORIZONTAL_OFFSET -10
#define SMOKE_VERTICAL_OFFSET   -5

@interface TitleScene : SKScene

typedef NS_ENUM(NSInteger, TitleNodeZOrder) {
    TitleBackgroundZOrder,
    TitleTrainZOrder,
    TitleForegroundZOrder,
    StartButtonZOrder
};

- (instancetype)initWithSize:(CGSize)size;

@end

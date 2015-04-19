//
//  TitleScene.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/7/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
 
#define TITLE_LABEL @"titleScene"
#define TITLE_BACKGROUND @"titleBackground"
#define TITLE_FOREGROUND @"titleForeground"

@interface TitleScene : SKScene

typedef NS_ENUM(NSInteger, TitleNodeZOrder) {
    TitleBackgroundZOrder,
    TitleTrainZOrder,
    TitleForegroundZOrder
};

@end

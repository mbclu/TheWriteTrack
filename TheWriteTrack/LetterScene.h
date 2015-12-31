//
//  LetterScene.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/11/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "Constants.h"
#import "GenericSpriteButton.h"
#import "PathSegments.h"
#import "LetterSelectButton.h"
#import "TrackContainer.h"
#import "SettingsAccessScene.h"
#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, ELetterSceneZOrder) {
    LetterSceneBackgroundZPosition,
    LetterSceneTrackContainerZPosition,
    LetterSceneButtonZPosition
};

@interface LetterScene : SettingsAccessScene {
    GenericSpriteButton *nextButton;
    GenericSpriteButton *previousButton;
    GenericSpriteButton *letterSelectButton;
    GenericSpriteButton *skipDemoButton;
}

@property unichar letter;
@property GenericSpriteButton *nextButtonProperty;
@property GenericSpriteButton *previousButtonProperty;
@property GenericSpriteButton *letterSelectButtonProperty;
@property GenericSpriteButton *skipDemoButtonProperty;

- (instancetype)initWithSize:(CGSize)size andLetter:(NSString *)letter;
- (void)transitionToNextScene;
- (void)transitionToPreviousScene;
- (void)transitionToLetterSelectScene;
- (void)connectSceneTransitions;
- (void)connectSkipDemoAction;

@end

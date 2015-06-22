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
#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, ELetterSceneZOrder) {
    LetterSceneBackgroundZPosition,
    LetterSceneTrackContainerZPosition,
    LetterSceneButtonZPosition
};

@interface LetterScene : SKScene {
    GenericSpriteButton *nextButton;
    GenericSpriteButton *previousButton;
    GenericSpriteButton *letterSelectButton;
}

@property unichar letter;
@property GenericSpriteButton *nextButtonProperty;
@property GenericSpriteButton *previousButtonProperty;
@property GenericSpriteButton *letterSelectButtonProperty;

- (instancetype)initWithSize:(CGSize)size andLetter:(NSString *)letter;
- (void)transitionToNextScene;
- (void)transitionToPreviousScene;
- (void)transitionToLetterSelectScene;
- (void)connectSceneTransitions;

@end

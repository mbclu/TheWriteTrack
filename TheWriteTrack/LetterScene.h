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
#import "TrackContainer.h"
#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, ELetterSceneZOrder) {
    LetterSceneBackgroundZPosition,
    LetterSceneTrackContainerZPosition,
    LetterSceneNextButtonZPosition,
    LetterScenePreviousButtonZPosition
};

@interface LetterScene : SKScene {
    GenericSpriteButton *nextButton;
    GenericSpriteButton *previousButton;
}

@property unichar letter;
@property GenericSpriteButton *nextButtonProperty;
@property GenericSpriteButton *previousButtonProperty;


- (instancetype)initWithSize:(CGSize)size andLetter:(NSString *)letter;
- (void)transitionToNextScene;
- (void)transitionToPreviousScene;
- (void)connectSceneTransitions;

@end

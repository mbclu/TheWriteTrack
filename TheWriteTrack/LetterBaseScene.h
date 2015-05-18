//
//  _BaseTrack.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/11/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "GenericSpriteButton.h"
#import "LetterConstants.h"
#import <SpriteKit/SpriteKit.h>

FOUNDATION_EXPORT NSString *const NextButtonName;

@interface LetterBaseScene : SKScene {
    GenericSpriteButton *nextButton;
    GenericSpriteButton *previousButton;
}

@property unichar letter;
@property (nonatomic, readwrite, retain) GenericSpriteButton *nextButtonProperty;
@property (nonatomic, readwrite, retain) GenericSpriteButton *previousButtonProperty;

- (instancetype)initWithSize:(CGSize)size AndLetter:(NSString *)letter;
- (void)transitionToNextScene;
- (void)transitionToPreviousScene;
- (void)connectSceneTransitions;

@end

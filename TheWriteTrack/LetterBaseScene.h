//
//  _BaseTrack.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/11/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "GenericSpriteButton.h"
#import "Constants.h"
#import <SpriteKit/SpriteKit.h>

#ifdef DEBUG
    #define APP_SHOULD_DRAW_DOTS                0
    #define APP_SHOULD_ALLOW_CREATING_WAYPOINTS 0
#endif
#if (APP_SHOULD_ALLOW_CREATING_WAYPOINTS)
    #import "WaypointDropper.h"
#endif

FOUNDATION_EXPORT NSString *const NextButtonName;

@interface LetterBaseScene : SKScene {
    GenericSpriteButton *nextButton;
    GenericSpriteButton *previousButton;
#if (APP_SHOULD_ALLOW_CREATING_WAYPOINTS)
    WaypointDropper *wpDropper;
#endif
}

@property unichar letter;
@property (nonatomic, readwrite, retain) GenericSpriteButton *nextButtonProperty;
@property (nonatomic, readwrite, retain) GenericSpriteButton *previousButtonProperty;

- (instancetype)initWithSize:(CGSize)size AndLetter:(NSString *)letter;
- (void)transitionToNextScene;
- (void)transitionToPreviousScene;
- (void)connectSceneTransitions;
- (void)addCrossbars:(NSArray *)crossbars;

@end

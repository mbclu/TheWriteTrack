//
//  _BaseTrack.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/11/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "Constants.h"
#import "GenericSpriteButton.h"
#import "PathSegments.h"
#import <SpriteKit/SpriteKit.h>

#ifdef DEBUG
    #define APP_SHOULD_DRAW_DOTS                0
    #define APP_SHOULD_ALLOW_CREATING_WAYPOINTS 0
#endif
#if (APP_SHOULD_ALLOW_CREATING_WAYPOINTS)
    #import "WaypointDropper.h"
#endif

FOUNDATION_EXPORT NSString *const NextButtonName;

typedef NS_ENUM(NSUInteger, ELetterBaseSceneZOrder) {
    LetterBaseSceneBackgroundZPosition,
    LetterBaseSceneTrackOutlineZPosition,
    LetterBaseSceneCrossbarZPosition,
    LetterBaseSceneWaypointZPosition,
    LetterBaseSceneTrainZPosition,
    LetterBaseSceneNextButtonZPosition,
    LetterBaseScenePreviousButtonZPosition
};

@interface LetterBaseScene : SKScene {
    GenericSpriteButton *nextButton;
    GenericSpriteButton *previousButton;
#if (APP_SHOULD_ALLOW_CREATING_WAYPOINTS)
    WaypointDropper *wpDropper;
#endif
}

@property unichar letter;
@property GenericSpriteButton *nextButtonProperty;
@property GenericSpriteButton *previousButtonProperty;
@property PathSegments *pathSegments;

- (instancetype)initWithSize:(CGSize)size andLetter:(NSString *)letter;
- (instancetype)initWithSize:(CGSize)size letter:(NSString *)letter andPathSegments:(PathSegments *)pathSegments;
- (void)transitionToNextScene;
- (void)transitionToPreviousScene;
- (void)connectSceneTransitions;
- (void)createSpritesForCrossbars:(NSArray *)crossbars withTransform:(CGAffineTransform)translateToZero;
- (void)createSpritesForWaypoints:(NSArray *)waypoints withOffset:(CGPoint)offsetFromZero;

@end

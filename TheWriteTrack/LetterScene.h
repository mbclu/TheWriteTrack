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
#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, ELetterBaseSceneZOrder) {
    LetterBaseSceneBackgroundZPosition,
    LetterBaseSceneTrackOutlineZPosition,
    LetterBaseSceneCrossbarZPosition,
    LetterBaseSceneWaypointZPosition,
    LetterBaseSceneTrainZPosition,
    LetterBaseSceneNextButtonZPosition,
    LetterBaseScenePreviousButtonZPosition
};

@interface LetterScene : SKScene {
    GenericSpriteButton *nextButton;
    GenericSpriteButton *previousButton;
}

@property unichar letter;
@property GenericSpriteButton *nextButtonProperty;
@property GenericSpriteButton *previousButtonProperty;
@property PathSegments *pathSegments;
@property SKNode *trackContainerNode;
@property CGPoint centeringPoint;

- (instancetype)initWithSize:(CGSize)size andLetter:(NSString *)letter;
- (instancetype)initWithSize:(CGSize)size letter:(NSString *)letter andPathSegments:(PathSegments *)pathSegments;
- (void)transitionToNextScene;
- (void)transitionToPreviousScene;
- (void)connectSceneTransitions;
- (void)createSpritesForCrossbars:(NSArray *)crossbars;
- (void)createSpritesForWaypoints:(NSArray *)waypoints;

@end
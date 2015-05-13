//
//  A.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 3/31/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "AttributedStringPath.h"
#import "BaseTrackScene.h"
#import "BaseTrackProperties.h"
#import "LetterView.h"
#import <SpriteKit/SpriteKit.h>

FOUNDATION_EXPORT CGFloat const LetterLineWidth;
FOUNDATION_EXPORT NSString *const TrainNodeName;
FOUNDATION_EXPORT NSString *const LetterNodeName;

@interface A : BaseTrackScene

- (void)transitionToNextScene;
- (void)connectSceneTransition;

@end

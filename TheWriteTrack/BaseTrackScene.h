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

@interface BaseTrackScene : SKScene {
    GenericSpriteButton *nextButton;
}

@property (nonatomic, readwrite, retain) GenericSpriteButton *nextButtonProperty;

@end

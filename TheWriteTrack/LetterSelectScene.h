//
//  LetterSelectScene.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 6/20/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "GenericSpriteButton.h"
#import <SpriteKit/SpriteKit.h>

@interface LetterSelectScene : SKScene {
    GenericSpriteButton *chosenLetterButton;
}

@property GenericSpriteButton *chosenLetterButtonProperty;

@end

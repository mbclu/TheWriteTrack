//
//  SettingsAccessScene.h
//  TheWriteTrack
//
//  Created by Mitch Clutter on 12/31/15.
//  Copyright © 2015 Mitch Clutter. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GenericSpriteButton.h"

@interface SettingsAccessScene : SKScene {
    GenericSpriteButton *settingsButton;
}

@property GenericSpriteButton *settingsButtonProperty;

- (void) connectSceneTransitions;
- (void) transitionToSettings;

@end

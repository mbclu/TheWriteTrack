//
//  FakeTargetScene.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/4/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface FakeTargetScene : SKScene

@property bool didReceiveMessage;

- (void)expectedSelector;

@end

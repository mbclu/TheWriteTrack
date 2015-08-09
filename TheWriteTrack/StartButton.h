//
//  StartButton.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/30/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "GenericSpriteButton.h"

@interface StartButton : GenericSpriteButton

- (SKSpriteNode *)signalBottomHalfNode;
- (SKSpriteNode *)signalTopHalfNode;
- (SKShapeNode *)redLightNode;
- (SKShapeNode *)yellowLightNode;
- (SKShapeNode *)greenLightNode;

@end

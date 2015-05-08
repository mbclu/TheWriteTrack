//
//  A.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 3/31/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "_BaseTrackScene.h"
#import "AttributedStringPath.h"
#import "LetterView.h"

@interface A : _BaseTrackScene

@property AttributedStringPath *stringPath;
@property LetterView *stringPathView;

@end

//
//  A.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 3/31/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "AttributedStringPath.h"
#import "LetterBaseScene.h"
#import "LetterView.h"
#import <SpriteKit/SpriteKit.h>

@interface A : LetterBaseScene

@property unichar letter;

- (instancetype)initWithSize:(CGSize)size AndLetter:(NSString *)letter;
- (void)transitionToNextScene;
- (void)connectSceneTransition;

@end

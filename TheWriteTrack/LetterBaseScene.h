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

@interface LetterBaseScene : SKScene {
    GenericSpriteButton *nextButton;
}

@property unichar letter;
@property (nonatomic, readwrite, retain) GenericSpriteButton *nextButtonProperty;

- (instancetype)initWithSize:(CGSize)size AndLetter:(NSString *)letter;
- (void)transitionToNextScene;
- (void)connectSceneTransition;

- (SKSpriteNode *)createBackground;
- (GenericSpriteButton *)createNextButton;
- (SKShapeNode *)createLetterPathNode;
- (SKNode *)createTrainNode;
- (void)moveNodeToCenter:(SKNode *)node;

@end

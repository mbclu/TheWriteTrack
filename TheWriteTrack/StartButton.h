//
//  StartButton.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/30/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LetterConverter.h"
#import <SpriteKit/SpriteKit.h>

@interface StartButton : SKSpriteNode

@property(retain) LetterConverter *letterConverter;

- (void)createFromString:(NSString *)string;

@end

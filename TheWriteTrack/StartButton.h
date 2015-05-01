//
//  StartButton.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/30/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LetterConverter.h"
#import <SpriteKit/SpriteKit.h>

FOUNDATION_EXPORT NSString *const StartText;

@interface StartButton : SKSpriteNode

@property (readonly) NSString *startText;
@property (retain) LetterConverter *letterConverter;

- (instancetype)initWithLetterConverter:(LetterConverter *)converter;

@end

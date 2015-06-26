//
//  ChosenLetterButton.h
//  TheWriteTrack
//
//  Created by Mitch Clutter on 6/25/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "GenericSpriteButton.h"
#import "LetterConverter.h"

@interface ChosenLetterButton : SKSpriteNode {
    LetterConverter *letterConverter;
}

@property unichar letter;
@property NSString * letterAsString;

- (instancetype)initWithLetter:(unichar)letter;

@end

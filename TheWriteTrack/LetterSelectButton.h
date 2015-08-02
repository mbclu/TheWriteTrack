//
//  LetterSelectButton.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 6/21/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "GenericSpriteButton.h"

#import "LetterConverter.h"

static const float LETTER_SELECT_BUTTON_X_PADDING = 5.0;
static const float LETTER_SELECT_BUTTON_Y_PADDING = 5.0;

@interface LetterSelectButton : GenericSpriteButton {
    LetterConverter *letterConverter;
}

@end

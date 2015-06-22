//
//  LetterSelectButton.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 6/21/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "GenericSpriteButton.h"

#import "LetterConverter.h"

@interface LetterSelectButton : GenericSpriteButton {
    LetterConverter *letterConverter;
}

@end

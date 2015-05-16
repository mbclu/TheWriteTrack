//
//  StartButton.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/30/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "AttributedStringPath.h"
#import "GenericSpriteButton.h"

@interface StartButton : GenericSpriteButton

@property (readonly) NSString *startText;
@property (retain) AttributedStringPath *attributedStringPath;
@property (nonatomic, retain) NSMutableArray *letterArray;
@property (readwrite) CGPoint nextLetterPosition;

- (instancetype)initWithAttributedStringPath:(AttributedStringPath *)strPath;

@end

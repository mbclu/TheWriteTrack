//
//  StartButton.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/30/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "AttributedStringPath.h"
#import "StartButtonConstants.h"

@interface StartButton : SKSpriteNode

@property (readonly) NSString *startText;
@property (retain) AttributedStringPath *stringPath;
@property (nonatomic, retain) NSMutableArray *letterArray;
@property (readwrite) CGPoint nextLetterPosition;

@property (nonatomic, readonly) SEL actionTouchUpInside;
@property (nonatomic, readonly, weak) id targetTouchUpInside;

- (void)setTouchUpInsideTarget:(id)target action:(SEL)action;
- (void)evaluateTouchAtPoint:(CGPoint)touchPoint;
- (instancetype)initWithAttributedStringPath:(AttributedStringPath *)strPath;

@end

//
//  StartButton.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/30/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "AttributedStringPath.h"
#import <SpriteKit/SpriteKit.h>

FOUNDATION_EXPORT NSString *const StartText;
FOUNDATION_EXPORT NSString *const StartStringSmokeSKS;
FOUNDATION_EXPORT CGFloat const StartStringSize;

@interface StartButton : SKSpriteNode

@property (readonly) NSString *startText;
@property (retain) AttributedStringPath *stringPath;
@property (nonatomic, retain) NSMutableArray *letterArray;
@property (readwrite) CGPoint nextLetterPosition;

- (instancetype)initWithAttributedStringPath:(AttributedStringPath *)strPath;

@end

//
//  LetterView.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/28/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "AttributedStringPath.h"
#import <SpriteKit/SpriteKit.h>
#import <CoreText/CoreText.h>

@interface LetterView : SKView

@property AttributedStringPath *stringPath;

//- (void) drawRailInContext:(CGContextRef)context;
- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame andString:(NSString*)string;
- (void) setupContextForHumanReadableText:(CGContextRef)context;
- (void) movePathToCenter:(CGMutablePathRef)path;
//- (CGMutablePathRef) createPathInContext:(CGContextRef)context;

@end

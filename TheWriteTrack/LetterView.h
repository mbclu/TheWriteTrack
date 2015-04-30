//
//  LetterView.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/28/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreText/CoreText.h>

@interface LetterView : SKView

- (void) drawRailInContext:(CGContextRef)context;
- (void) setupContextForHumanReadableText:(CGContextRef)context;
- (void) movePathToCenter:(CGMutablePathRef)path;
- (CGMutablePathRef) createPathInContext:(CGContextRef)context;

@end

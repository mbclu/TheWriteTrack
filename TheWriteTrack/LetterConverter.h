//
//  LetterConverter.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/25/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

#define NAMED_FONT              @"Verdana"

@interface LetterConverter : NSObject

+ (NSAttributedString *)createAttributedString:(NSString *)attributelessString;
+ (UIBezierPath *)pathFromAttributedString:(NSAttributedString *)attrString;
+ (void)addLetterFromFont:(CTFontRef)font andGlyph:(CGGlyph)glyph toPoint:(CGPoint)position ofPath:(CGMutablePathRef)path;
+ (CGPathRef)pathFromFirstCharOfStringRef:(NSString *)stringRef;

@end

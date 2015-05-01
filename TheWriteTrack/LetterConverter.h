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

- (NSAttributedString *)createAttributedString:(NSString *)attributelessString WithFontSizeInPoints:(CGFloat)pointSize;

- (CGMutablePathRef)createPathFromString:(NSString *)string AndSize:(CGFloat)size;
- (CGMutablePathRef)createPathAtLocation:(CGPoint)location UsingAttrString:(NSAttributedString *)attrString;
- (CGMutablePathRef)createPathAtZeroUsingAttrString:(NSAttributedString *)attrString;

- (void)getSingleGlyph:(CGGlyph *)glyph AndPosition:(CGPoint *)position InRun:(CTRunRef)run atIndex:(CFIndex)index;

- (NSArray *)getLetterArrayFromString:(NSString *)string;

@end

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

//#define NAMED_FONT              @"Verana"
//#define NAMED_FONT              @"Farah"
//#define NAMED_FONT              @"KohinoorDevanagari-Book"
//#define NAMED_FONT              @"Symbol"

@interface LetterConverter : NSObject

- (NSAttributedString *)createAttributedString:(NSString *)attributelessString withFontType:(CFStringRef)fontType andSize:(CGFloat)fontSize;

- (CGMutablePathRef)createPathFromString:(NSString *)string AndSize:(CGFloat)size;
- (CGMutablePathRef)createPathAtLocation:(CGPoint)location UsingAttrString:(NSAttributedString *)attrString;
- (CGMutablePathRef)createPathAtZeroUsingAttrString:(NSAttributedString *)attrString;

- (void)getSingleGlyph:(CGGlyph *)glyph AndPosition:(CGPoint *)position InRun:(CTRunRef)run atIndex:(CFIndex)index;

- (NSMutableArray *)getLetterArrayFromString:(NSString *)string;

@end

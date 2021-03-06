//
//  LetterConverter.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/25/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LetterConverter.h"
#import "LayoutMath.h"
#import "Constants.h"
#import <UIKit/UIKit.h>

@implementation LetterConverter

- (NSAttributedString *)createAttributedString:(NSString *)attributelessString withFontType:(CFStringRef)fontType andSize:(CGFloat)fontSize {
    NSAttributedString *attrString = nil;
    if (attributelessString != (id)[NSNull null] && attributelessString.length != 0)
    {
        CTFontRef fontRef = CTFontCreateWithName(fontType, fontSize, NULL);
        
        NSDictionary *attrDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        (__bridge id)fontRef, (NSString *)kCTFontAttributeName,
                                        (id)[[UIColor clearColor] CGColor], (NSString *)kCTForegroundColorAttributeName,
                                        (id)[[UIColor darkGrayColor] CGColor], (NSString *)kCTStrokeColorAttributeName,
                                        (id)[NSNumber numberWithFloat:-3.0], (NSString *)kCTStrokeWidthAttributeName,
                                        nil];
        
        attrString = [[NSAttributedString alloc] initWithString:attributelessString attributes:attrDictionary];
        
        CFRelease(fontRef);
    }
    return attrString;
}

- (void)getSingleGlyph:(CGGlyph *)glyph AndPosition:(CGPoint *)position InRun:(CTRunRef)run atIndex:(CFIndex)index {
    CFRange glyphRange = CFRangeMake(index, 1);
    CTRunGetGlyphs(run, glyphRange, glyph);
}

- (void)addToLocation:(CGPoint)location LetterPath:(CGMutablePathRef)path WithFont:(CTFontRef)font AndGlyph:(CGGlyph)glyph {
    CGPathRef letter = CTFontCreatePathForGlyph(font, glyph, NULL);
    CGAffineTransform transform = CGAffineTransformMakeTranslation(location.x, location.y);
    CGPathAddPath(path, &transform, letter);
    CGPathRelease(letter);
}

- (CGPoint)originAtCenterForFont:(CTFontRef)font AndGlyph:(CGGlyph)glyph {
    CGPathRef letter = CTFontCreatePathForGlyph(font, glyph, NULL);
    CGRect bounds = CGPathGetPathBoundingBox(letter);
    CGPoint origin = CGPointMake([LayoutMath findStartingXValueForRect:bounds],
                                 [LayoutMath findStartingYValueForRect:bounds]);
    return origin;
}

- (CGMutablePathRef)createPathAtLocation:(CGPoint)location UsingAttrString:(NSAttributedString *)attrString {
    if (attrString == nil) {
        return nil;
    }
    
    // Create path from text
    // See: http://www.codeproject.com/KB/iPhone/Glyph.aspx
    // License: The Code Project Open License (CPOL) 1.02 http://www.codeproject.com/info/cpol10.aspx
    // - refactored by me.
    CGMutablePathRef letterPath = CGPathCreateMutable();

    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);

    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
    {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);

        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            CGGlyph glyph;
            CGPoint position;
            
            [self getSingleGlyph:&glyph
                     AndPosition:&position
                           InRun:run
                         atIndex:runIndex];
            
            [self addToLocation:location
                     LetterPath:letterPath
                       WithFont:runFont
                       AndGlyph:glyph];
        }
    }
    
    CFRelease(line);
    
    return letterPath;
}

- (CGMutablePathRef)createPathAtZeroUsingAttrString:(NSAttributedString *)attrString {
    return [self createPathAtLocation:CGPointZero UsingAttrString:attrString];
}

- (CGMutablePathRef)createPathFromString:(NSString *)string andSize:(CGFloat)size {
    NSAttributedString *attrString = [self createAttributedString:string withFontType:DefaultLetterFont andSize:size];
    return [self createPathAtZeroUsingAttrString:attrString];
}

- (NSMutableArray *)getLetterArrayFromString:(NSString *)string {
    NSMutableArray *letterArray = [[NSMutableArray alloc] initWithCapacity:string.length];
    for (NSUInteger i = 0; i < string.length; i++) {
        [letterArray addObject:[string substringWithRange:NSMakeRange(i, 1)]];
    }
    return letterArray;
}

@end

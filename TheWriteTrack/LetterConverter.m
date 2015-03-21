//
//  LetterConverter.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/25/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LetterConverter.h"
#import "LayoutMath.h"
#import <UIKit/UIKit.h>

@implementation LetterConverter

+ (NSAttributedString *)createAttributedString:(NSString *)attributelessString {
    NSAttributedString *attrString = nil;
    if (attributelessString != (id)[NSNull null] && attributelessString.length != 0)
    {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)NAMED_FONT, [LayoutMath maximumViableFontSize], NULL);
        
        NSDictionary *attrDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        (__bridge id)fontRef, (NSString *)kCTFontAttributeName,
                                        (id)[[UIColor clearColor] CGColor], (NSString *)kCTForegroundColorAttributeName,
                                        (id)[[UIColor brownColor] CGColor], (NSString *)kCTStrokeColorAttributeName,
                                        (id)[NSNumber numberWithFloat:-3.0], (NSString *)kCTStrokeWidthAttributeName,
                                        nil];
        
        attrString = [[NSAttributedString alloc] initWithString:[attributelessString substringWithRange:NSMakeRange(0, 1)] attributes:attrDictionary];
        
        CFRelease(fontRef);
    }
    return attrString;
}

+ (void)addLetterFromFont:(CTFontRef)font andGlyph:(CGGlyph)glyph toPoint:(CGPoint)position ofPath:(CGMutablePathRef)path {
    if ((__bridge UIBezierPath *)path == nil)
    {
        [NSException raise:@"Nil Path used in addLetterFrom..." format:@""];
    }
    CGPathRef letter = CTFontCreatePathForGlyph(font, glyph, NULL);
    CGAffineTransform transform = CGAffineTransformMakeTranslation(position.x, position.y);
    CGPathAddPath(path, &transform, letter);
    CGPathRelease(letter);
}

+ (UIBezierPath *)pathFromAttributedString:(NSAttributedString *)attrString {
    if (attrString == nil) {
        return nil;
    }
    
     // Create path from text
     // See: http://www.codeproject.com/KB/iPhone/Glyph.aspx
     // License: The Code Project Open License (CPOL) 1.02 http://www.codeproject.com/info/cpol10.aspx
     CGMutablePathRef letters = CGPathCreateMutable();
     
     CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
     CFArrayRef runArray = CTLineGetGlyphRuns(line);
     
     // for each RUN
     for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
     {
         // Get FONT for this run
         CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
         CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
         
         // for each GLYPH in run
         for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
         {
             // get Glyph & Glyph-data
             CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
             CGGlyph glyph;
             CGPoint position;
             CTRunGetGlyphs(run, thisGlyphRange, &glyph);
             CTRunGetPositions(run, thisGlyphRange, &position);
             
             [LetterConverter addLetterFromFont:runFont andGlyph:glyph toPoint:position ofPath:letters];
             // Get PATH of outline
             {
                 CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                 CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                 CGPathAddPath(letters, &t, letter);
                 CGPathRelease(letter);
             }
         }
    }
    CFRelease(line);
     
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
     
    CGPathRelease(letters);
    return nil;
}

+ (CGPathRef)pathFromFirstCharOfStringRef:(NSString *)stringRef {
    CGPathRef path = Nil;
    
    unichar firstChar = [[stringRef uppercaseString] characterAtIndex:0];
    
    if (firstChar >= 'A' && firstChar <= 'Z')
    {
        CTFontRef font = CTFontCreateWithName((CFStringRef)NAMED_FONT, 1, NULL);
        UniChar *character = (UniChar *)malloc(sizeof(UniChar));
        CGGlyph *glyph = (CGGlyph *)malloc(sizeof(CGGlyph));
        CTFontGetGlyphsForCharacters(font, character, glyph, 1);
        
        path = CTFontCreatePathForGlyph(font, *glyph, NULL);
        
        CFRelease(font);
        free(character);
        free(glyph);
    }
    
    return path;
}

@end

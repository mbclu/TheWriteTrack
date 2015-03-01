//
//  exampleTextRender.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/28/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <Foundation/Foundation.h>

//CTLineRef line = CTLineCreateWithAttributedString( attStr ) ;

//CFArrayRef runArray = CTLineGetGlyphRuns(line);

// for each RUN
/*
for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
{
    // Get FONT for this run
    CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
    CTFontRef runFont =
    CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
    
    // for each GLYPH in run
    for (CFIndex runGlyphIndex = 0;
         runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
    {
        // get Glyph & Glyph-data
        CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
        CGGlyph glyph;
        CGPoint position;
        CTRunGetGlyphs(run, thisGlyphRange, &glyph);
        CTRunGetPositions(run, thisGlyphRange, &position);
        
        // Render it
        {
            CGFontRef cgFont = CTFontCopyGraphicsFont(runFont, NULL);
            
            CGAffineTransform textMatrix = CTRunGetTextMatrix(run);
            CGContextSetTextMatrix(X, textMatrix);
            
            CGContextSetFont(X, cgFont);
            CGContextSetFontSize(X, CTFontGetSize(runFont));
            CGContextSetRGBFillColor(X, 1.0, 1.0, 1.0, 0.5);
            CGContextShowGlyphsAtPositions(X, &glyph, &position, 1);
            CFRelease(cgFont);
        }
        
        // Get PATH of outline & stroke outline
        {
            CGPathRef path = CTFontCreatePathForGlyph(runFont, glyph, NULL);
            CGMutablePathRef pT = CGPathCreateMutable();
            CGAffineTransform T =
            CGAffineTransformMakeTranslation(position.x, position.y);
            CGPathAddPath(pT, &T, path);
            
            CGContextAddPath(X, pT);
            CGContextSetStrokeColorWithColor(X, [UIColor yellowColor].CGColor);
            CGContextSetLineWidth(X, atLeastOnePixel);
            CGContextStrokePath(X);
            CGPathRelease(path);
            CGPathRelease(pT);
        }
        
        // draw blue bounding box
        {
            CGRect glyphRect = CTRunGetImageBounds(run, X, thisGlyphRange);
            
            CGContextSetLineWidth(X, atLeastOnePixel);
            CGContextSetStrokeColorWithColor(X, [UIColor blueColor ].CGColor);
            CGContextStrokeRect(X, glyphRect);
        }
        
        // release things
        CFRelease(line);
    }
}
*/
//
//  LetterView.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/28/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LetterView.h"
#import "LetterConverter.h"

@implementation LetterView

@synthesize attrString;
@synthesize attrStringRails;

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
//    attrString = [[NSAttributedString alloc] init];
    return self;
}

- (void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (attrString != nil) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // Flip the co-ordinate system
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, 0, self.bounds.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
        
        // Set text position and draw the line into the graphic context
//        CGContextSetTextPosition(context, 30.0, 100.0);
        CTLineDraw(line, context);
        CFRelease(line);
    }

    /*
    CFAttributedStringRef cfStringRef = [LetterConverter createAttributedStringRef:@"A"];
    CTLineRef line = CTLineCreateWithAttributedString(cfStringRef);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);

    CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, 0);
    CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
    
    // Get glyph and glyph-data
    CFRange glyphRange = CFRangeMake(0, 1);
    CGGlyph glyph;
    CGPoint position;
    CTRunGetGlyphs(run, glyphRange, &glyph);
    CTRunGetPositions(run, glyphRange, &position);

    // Render the glyph data
    CGFontRef cgFont = CTFontCopyGraphicsFont(runFont, NULL);
    CGAffineTransform textMatrix = CTRunGetTextMatrix(run);
//    CGContextSetTextMatrix(X, textMatrix);
    
    CGPathRef letterPath = [LetterConverter pathFromFirstCharOfStringRef:@"A"];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(letterPath, NULL, 50, 50);
//    CGPathAddLineToPoint(letterPath, NULL, 200, 200);
    
//    CGPathRef thickPath = CGPathCreateCopyByStrokingPath(letterPath, NULL, 10, kCGLineCapButt, kCGLineJoinBevel, 0);
//    CGContextAddPath(context, thickPath);
    
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextSetLineWidth(context, 10);
    CGContextDrawPath(context, kCGPathFillStroke);
    
//    CGPathRelease(thickPath);
    CGPathRelease(letterPath);
     */
}

@end

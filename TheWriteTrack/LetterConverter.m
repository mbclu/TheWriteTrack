//
//  LetterConverter.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/25/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LetterConverter.h"

@implementation LetterConverter

@synthesize namedFont;

- (instancetype) init {
    self = [super init];
    [self setNamedFont:(CFStringRef)@"Verdana"];
    return self;
}

+ (CGMutablePathRef)pathFromFirstCharOfStringRef:(NSString *)stringRef {
    CGMutablePathRef path = Nil;
    
    unichar firstChar = [[stringRef uppercaseString] characterAtIndex:0];
    
    if (firstChar >= 'A' && firstChar <= 'Z') {
        CTFontRef font = CTFontCreateWithName((CFStringRef)@"Helvetica", 12.0f, NULL);
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

+ (CFAttributedStringRef)createAttributedStringRef {
    CFAttributedStringRef stringRef = nil;
    return stringRef;
}

@end

//
//  LetterConverter.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/25/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LetterConverter.h"
#import <UIKit/UIKit.h>

@implementation LetterConverter

@synthesize namedFont;
@synthesize fontSize;

- (instancetype) init {
    self = [super init];
    [self setNamedFont:(CFStringRef)@"Verdana"];
    [self setFontSize:1.0];
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

- (CFAttributedStringRef)createAttributedStringRef {
    CFAttributedStringRef stringRef = nil;
    UIFont* font = [UIFont fontWithName:[self namedFont] size:[self fontSize]];
    return stringRef;
}

@end

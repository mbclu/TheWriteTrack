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

+ (CGPathRef)pathFromFirstCharOfStringRef:(NSString *)stringRef {
    CGPathRef path = Nil;
    
    unichar firstChar = [[stringRef uppercaseString] characterAtIndex:0];
    
    if (firstChar >= 'A' && firstChar <= 'Z') {
        CTFontRef font = CTFontCreateWithName((CFStringRef)NAMED_FONT, FONT_SIZE, NULL);
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

+ (CFAttributedStringRef)createAttributedStringRef:(NSString *)string {
    CFAttributedStringRef stringRef = nil;
    if (string != (id)[NSNull null] && string.length != 0) {
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)NAMED_FONT, FONT_SIZE, NULL);
//        UIFont* font = [UIFont fontWithName:NAMED_FONT size:FONT_SIZE];
//        CTFontRef ctFontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
        NSDictionary *attrDictionary = @{ (NSString *)kCTFontAttributeName : (id)CFBridgingRelease(font) };
//        NSNumber* nsNumber_0 = [NSNumber numberWithInteger:0];
//        NSDictionary *attributeDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                             (__bridge id) ctFontRef, kCTFontAttributeName,
//                                             (id) nsNumber_0, kCTLigatureAttributeName,
//                                             nil];
//        assert(attributeDictionary != nil);
        NSAttributedString* nsAttrString = [[NSAttributedString alloc] initWithString:string attributes:attrDictionary];
        stringRef = (__bridge CFAttributedStringRef) nsAttrString;
    }
    return stringRef;
}

@end

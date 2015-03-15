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

#define NAMED_FONT @"Verdana"
#define FONT_SIZE 1.0

@interface LetterConverter : NSObject

+ (CGPathRef)pathFromFirstCharOfStringRef:(NSString *)stringRef;
+ (CFAttributedStringRef)createAttributedStringRef:(NSString *)string;

@end

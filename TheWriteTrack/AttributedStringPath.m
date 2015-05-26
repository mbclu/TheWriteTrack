//
//  AttributedStringPath.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/26/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "AttributedStringPath.h"
#import "LayoutMath.h"
#import "Constants.h"

@implementation AttributedStringPath
@synthesize letterConverter;
@synthesize letterPath;

- (instancetype)initWithString:(NSString *)str andSize:(CGFloat)size {
    self = [super init];
    
    if ((str == nil) ||
        (NSNotFound == [str rangeOfCharacterFromSet:NSCharacterSet.letterCharacterSet].location)) {
        str = @"?";
    }
    
    if (letterConverter == nil) {
        [self setLetterConverter:[[LetterConverter alloc] init]];
    }

    [self setAttributedString:[letterConverter createAttributedString:str withFontType:DefaultLetterFont andSize:size]];
    [self setLetterPath:[letterConverter createPathAtZeroUsingAttrString:self.attributedString]];
    
    return self;
}

- (instancetype)initWithString:(NSString *)str {
    self = [self initWithString:str andSize:[LayoutMath maximumViableFontSize]];
    return self;
}

- (instancetype)init {
    self = [self initWithString:@""];
    return self;
}

- (instancetype)initWithLetterConverter:(LetterConverter *)converter {
    self.letterConverter = converter;
    self = [self init];
    return self;
}

- (CGMutablePathRef)createPathWithString:(NSString *)string andSize:(CGFloat)size {
    letterPath = [letterConverter createPathFromString:string AndSize:size];
    return letterPath;
}

@end

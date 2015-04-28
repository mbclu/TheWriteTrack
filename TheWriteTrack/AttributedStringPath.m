//
//  AttributedStringPath.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/26/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "AttributedStringPath.h"

@implementation AttributedStringPath

- (instancetype)initWithString:(NSString *)str andSize:(CGFloat)size {
    self = [super init];
    
    if ((str == nil) ||
        (NSNotFound == [str rangeOfCharacterFromSet:NSCharacterSet.letterCharacterSet].location)) {
        str = @"?";
    }
    
    [self setAttributedString:[LetterConverter createAttributedString:str WithFontSizeInPoints:size]];
    [self setPath:[LetterConverter createPathAtZeroUsingAttrString:self.attributedString]];
    
    return self;
}

- (instancetype)initWithString:(NSString *)str andLocation:(CGPoint)location {
    self = [super init];
    
    if ((str == nil) ||
        (NSNotFound == [str rangeOfCharacterFromSet:NSCharacterSet.letterCharacterSet].location)) {
        str = @"?";
    }
    
    [self setAttributedString:[LetterConverter createAttributedString:str]];
    [self setPath:[LetterConverter createPathAtLocation:location UsingAttrString:self.attributedString]];
    
    return self;
}

- (instancetype)initWithString:(NSString *)str {
    self = [super init];

    if ((str == nil) ||
        (NSNotFound == [str rangeOfCharacterFromSet:NSCharacterSet.letterCharacterSet].location)) {
        str = @"?";
    }

    [self setAttributedString:[LetterConverter createAttributedString:str]];
    [self setPath:[LetterConverter createPathAtZeroUsingAttrString:self.attributedString]];
    
    return self;
}

@end

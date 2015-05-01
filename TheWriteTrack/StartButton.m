//
//  StartButton.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/30/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "StartButton.h"

@implementation StartButton

NSString *const StartText = @"start";

@synthesize startText;
@synthesize letterConverter;

- (instancetype)initWithLetterConverter:(LetterConverter *)converter {
    self = [super init];
    
    letterConverter = converter;
    if (letterConverter == nil) {
        letterConverter = [[LetterConverter alloc] init];
    }
    
    [letterConverter getLetterArrayFromString:StartText];
    
    return self;
}

@end

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
NSString *const StartStringSmokeSKS = @"StartStringSmoke";

@synthesize startText;
@synthesize letterConverter;

- (void)addEmittersFromLetterArray:(NSArray *)letterArray {
    for (NSUInteger i = 0; i < letterArray.count; i++) {
        SKEmitterNode *node = [NSKeyedUnarchiver unarchiveObjectWithFile:
                               [[NSBundle mainBundle] pathForResource:StartStringSmokeSKS ofType:@"sks"]];
        [self addChild:node];
    }
}

- (instancetype)initWithLetterConverter:(LetterConverter *)converter {
    self = [super init];
    
    letterConverter = converter;
    if (letterConverter == nil) {
        letterConverter = [[LetterConverter alloc] init];
    }
    
    NSArray *letterArray = [letterConverter getLetterArrayFromString:StartText];
    [self addEmittersFromLetterArray:letterArray];
    
    return self;
}

@end

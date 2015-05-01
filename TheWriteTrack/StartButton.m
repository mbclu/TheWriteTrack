//
//  StartButton.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/30/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "StartButton.h"
#import "AttributedStringPath.h"

@implementation StartButton

NSString *const StartText = @"start";
NSString *const StartStringSmokeSKS = @"StartStringSmoke";

@synthesize startText;
@synthesize letterConverter;

- (SKAction *)createRepeatFollowActionForPath:(AttributedStringPath *)stringPath {
    SKAction *followStringPath = [SKAction followPath:stringPath.path
                                             asOffset:NO
                                         orientToPath:YES
                                             duration:1.0];
    SKAction *repeatForever = [SKAction repeatActionForever:followStringPath];
    return repeatForever;
}

- (void)addEmittersFromLetterArray:(NSArray *)letterArray {
    for (NSUInteger i = 0; i < letterArray.count; i++) {
        SKEmitterNode *node = [NSKeyedUnarchiver unarchiveObjectWithFile:
                               [[NSBundle mainBundle] pathForResource:StartStringSmokeSKS ofType:@"sks"]];
        
        AttributedStringPath *stringPath = [[AttributedStringPath alloc]
                                            initWithString:@"s" andSize:100.0];
        node.particleAction = [self createRepeatFollowActionForPath:stringPath];
        
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

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
CGFloat const StartStringSize = 100.0;

@synthesize startText;
@synthesize stringPath;

- (SKAction *)createRepeatFollowActionForPath:(CGPathRef)path {
    SKAction *followStringPath = [SKAction followPath:path
                                             asOffset:NO
                                         orientToPath:YES
                                             duration:1.0];
    SKAction *repeatForever = [SKAction repeatActionForever:followStringPath];
    return repeatForever;
}

- (void)addEmitters {
    NSArray *letterArray = [[stringPath letterConverter] getLetterArrayFromString:StartText];
    
    for (NSUInteger i = 0; i < letterArray.count; i++) {
        SKEmitterNode *node = [NSKeyedUnarchiver unarchiveObjectWithFile:
                               [[NSBundle mainBundle] pathForResource:StartStringSmokeSKS ofType:@"sks"]];
        
        CGPathRef path = [stringPath createPathWithString:[letterArray objectAtIndex:i] andSize:StartStringSize];
        node.particleAction = [self createRepeatFollowActionForPath:path];
        
        [self addChild:node];
    }
}

- (instancetype)initWithAttributedStringPath:(AttributedStringPath *)strPath {
    self = [super init];
    
    stringPath = strPath;
    if (stringPath == nil) {
        stringPath = [[AttributedStringPath alloc] init];
    }
    
    [self addEmitters];
    
    return self;
}

@end

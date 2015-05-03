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
CGFloat const LetterHoriztontalOffset = 10.0;

- (SKAction *)createRepeatFollowActionForPath:(CGPathRef)path {
    SKAction *followStringPath = [SKAction followPath:path
                                             asOffset:NO
                                         orientToPath:YES
                                             duration:1.0];
    SKAction *repeatForever = [SKAction repeatActionForever:followStringPath];
    return repeatForever;
}

- (void)addEmitters {
    _nextLetterPosition = CGPointZero;
    
    for (NSUInteger i = 0; i < _letterArray.count; i++) {
        SKEmitterNode *node = [NSKeyedUnarchiver unarchiveObjectWithFile:
                               [[NSBundle mainBundle] pathForResource:StartStringSmokeSKS ofType:@"sks"]];
        
        CGPathRef path = [_stringPath createPathWithString:[_letterArray objectAtIndex:i] andSize:StartStringSize];
        [_letterArray replaceObjectAtIndex:i withObject:(__bridge id)(path)];
        node.particleAction = [self createRepeatFollowActionForPath:path];
        if (i > 0) {
            CGRect previousLetterBounds = CGPathGetBoundingBox((CGPathRef)[_letterArray objectAtIndex:(i - 1)]);
            CGFloat nextX = _nextLetterPosition.x + previousLetterBounds.origin.x + previousLetterBounds.size.width + LetterHoriztontalOffset;
            _nextLetterPosition = CGPointMake(nextX, 0);
        }
        node.position = _nextLetterPosition;
        
        [self addChild:node];
    }
}

- (instancetype)initWithAttributedStringPath:(AttributedStringPath *)strPath {
    self = [super init];
    
    _stringPath = strPath;
    if (_stringPath == nil) {
        _stringPath = [[AttributedStringPath alloc] init];
    }
    
    _letterArray = [[_stringPath letterConverter] getLetterArrayFromString:StartText];
    [self addEmitters];
    
    return self;
}

@end

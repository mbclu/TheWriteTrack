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
CGFloat const StartStringSize = 125.0;
CGFloat const LetterHoriztontalOffset = 10.0;
CGFloat const ButtonOffsetMultiplier = 1.5;
CGFloat const FollowPathDuration = 2.0;     // The smaller the number
                                            // the faster the letters get filled in

- (SKAction *)createRepeatFollowActionForPath:(CGPathRef)path {
    SKAction *followStringPath = [SKAction followPath:path
                                             asOffset:NO
                                         orientToPath:YES
                                             duration:FollowPathDuration];
    SKAction *repeatForever = [SKAction repeatActionForever:followStringPath];
    return repeatForever;
}

- (CGPoint)getNextPositionForLetterAtIndex:(NSUInteger)i {
    if (i > 0) {
        CGRect previousLetterBounds = CGPathGetBoundingBox((CGPathRef)[_letterArray objectAtIndex:(i - 1)]);
        CGFloat nextX = _nextLetterPosition.x + previousLetterBounds.origin.x + previousLetterBounds.size.width + LetterHoriztontalOffset;
        _nextLetterPosition = CGPointMake(nextX, 0);
    }
    return _nextLetterPosition;
}

- (void)adjustOverallButtonSizeForLetterPath:(CGPathRef)path {
    float height = self.size.height;
    float widthSum = self.size.width;
    
    CGRect bounds = CGPathGetBoundingBox(path);
    if (bounds.size.height > height) {
        height = bounds.size.height;
    }
    widthSum += bounds.size.width + (LetterHoriztontalOffset * 1.5);
    
    self.size = CGSizeMake(widthSum, height);
}
    
- (void)addEmitters {
    _nextLetterPosition = CGPointZero;
    
    for (NSUInteger i = 0; i < _letterArray.count; i++) {
        SKEmitterNode *node = [NSKeyedUnarchiver unarchiveObjectWithFile:
                               [[NSBundle mainBundle] pathForResource:StartStringSmokeSKS ofType:@"sks"]];
        
        CGPathRef path = [_attributedStringPath createPathWithString:[_letterArray objectAtIndex:i] andSize:StartStringSize];
        [_letterArray replaceObjectAtIndex:i withObject:(__bridge id)(path)];
        
        node.particleAction = [self createRepeatFollowActionForPath:path];
        node.position = [self getNextPositionForLetterAtIndex:i];
        
        [self adjustOverallButtonSizeForLetterPath:path];
        [self addChild:node];
    }
}

- (instancetype)initWithAttributedStringPath:(AttributedStringPath *)strPath {
    self = [super init];
    
    _attributedStringPath = strPath;
    if (_attributedStringPath == nil) {
        _attributedStringPath = [[AttributedStringPath alloc] init];
    }
    
    _letterArray = [[_attributedStringPath letterConverter] getLetterArrayFromString:StartText];
    [self addEmitters];
    
    self.anchorPoint = CGPointZero;
    
    return self;
}

- (instancetype)init {
    self = [self initWithAttributedStringPath:nil];
    return self;
}

@end

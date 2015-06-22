//
//  LetterSelectScene.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 6/20/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LetterSelectScene.h"

@implementation LetterSelectScene

- (void)didMoveToView:(SKView *)view {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 200, 400);
    CGPathAddLineToPoint(path, nil, 250, 450);
    SKShapeNode *node = [SKShapeNode shapeNodeWithPath:path];
    [self addChild:node];
}

@end

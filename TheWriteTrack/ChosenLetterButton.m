//
//  ChosenLetterButton.m
//  TheWriteTrack
//
//  Created by Mitch Clutter on 6/25/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "ChosenLetterButton.h"

#import "Constants.h"
#import "LayoutMath.h"
#import "LetterConverter.h"

@implementation ChosenLetterButton

- (instancetype)initWithLetter:(unichar)letter {
    self = [super init];
    
    _letter = letter;
    _letterAsString = [NSString stringWithCharacters:&_letter length:1];
    letterConverter = [[LetterConverter alloc] init];

    [self addChild:[self createLetterNode]];
    
    self.name = ChosenLetterOverlay;
    self.accessibilityValue = _letterAsString;
    
    return self;
}

- (SKShapeNode *)createLetterNode {
    SKShapeNode *node = [self createNodeNamed:ChosenLetterNode withLetter:_letterAsString];
    node.position = CGPointZero;
    node.fillColor = [UIColor colorWithRed:0.96 green:0.37 blue:0.37 alpha:1.0];
    
    return node;
}

- (SKShapeNode *)createNodeNamed:(NSString *)name withLetter:(NSString *)letter {
    CGMutablePathRef path = [letterConverter createPathFromString:letter andSize:[LayoutMath letterButtonFontSizeByForDevice]];
    SKShapeNode *node = [SKShapeNode shapeNodeWithPath:path];
    node.name = name;
    node.userInteractionEnabled = NO;
    node.strokeColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    node.lineWidth = 0.5;
    return node;
}

@end

//
//  ChosenLetterButton.m
//  TheWriteTrack
//
//  Created by Mitch Clutter on 6/25/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "ChosenLetterButton.h"

#import "Constants.h"
#import "Colors.h"
#import "LayoutMath.h"
#import "LetterConverter.h"

static const CGFloat CHOSEN_LETTER_LINE_WIDTH = 0.5;

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
    node.fillColor = SALMON_COLOR_FOR_LETTERS;
    
    return node;
}

- (SKShapeNode *)createNodeNamed:(NSString *)name withLetter:(NSString *)letter {
    CGMutablePathRef path = [letterConverter createPathFromString:letter andSize:[LayoutMath letterButtonFontSizeByForDevice]];
    SKShapeNode *node = [SKShapeNode shapeNodeWithPath:path];
    node.name = name;
    node.userInteractionEnabled = NO;
    node.strokeColor = WHITE_COLOR_FOR_LETTER_OUTLINE;
    node.lineWidth = CHOSEN_LETTER_LINE_WIDTH;
    return node;
}

@end

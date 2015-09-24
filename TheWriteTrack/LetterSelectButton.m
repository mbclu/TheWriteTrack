//
//  LetterSelectButton.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 6/21/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LetterSelectButton.h"

#import "Constants.h"
#import "Colors.h"
#import "LayoutMath.h"
#import "LetterConverter.h"

static const int A_Y_POSITION = 5;
static const int B_Y_POSITION = 10;
static const double LINE_WIDTH_FOR_LETTER = 0.5;

@implementation LetterSelectButton

- (instancetype)init {
    self = [super init];
    
    letterConverter = [[LetterConverter alloc] init];
    
    [self add_ABC_Children];
    
    return self;
}

- (void)add_ABC_Children {
    [self addChild:[self create_A_Node]];
    [self addChild:[self create_B_Node]];
    [self addChild:[self create_C_Node]];
    [self setCustomSize];
}

- (void)setCustomSize {
    SKShapeNode *a = (SKShapeNode *)[self childNodeWithName:ANodeName];
    SKShapeNode *b = (SKShapeNode *)[self childNodeWithName:BNodeName];
    SKShapeNode *c = (SKShapeNode *)[self childNodeWithName:CNodeName];
    float width = DOUBLE_THE(LETTER_SELECT_BUTTON_X_PADDING) +
        a.frame.size.width +
        b.frame.size.width +
        c.frame.size.width;
    float height = b.frame.size.height - a.frame.origin.y + LETTER_SELECT_BUTTON_Y_PADDING;
    self.size = CGSizeMake(width, height);
}

- (SKShapeNode *)create_A_Node {
    SKShapeNode *node = [self createNodeNamed:ANodeName withLetter:@"A"];
    node.position = CGPointZero;
    node.fillColor = SALMON_COLOR_FOR_LETTERS;
    return node;
}

- (SKShapeNode *)create_B_Node {
    SKShapeNode *node = [self createNodeNamed:BNodeName withLetter:@"B"];
    CGSize A_size = [[self childNodeWithName:ANodeName] frame].size;
    node.position = CGPointMake(A_size.width + LETTER_SELECT_BUTTON_X_PADDING, B_Y_POSITION);
    node.fillColor = LIME_GREEN_COLOR_FOR_LETTER_B;
    return node;
}

- (SKShapeNode *)create_C_Node {
    SKShapeNode *node = [self createNodeNamed:CNodeName withLetter:@"C"];
    CGSize B_size = [[self childNodeWithName:BNodeName] frame].size;
    CGPoint B_origin = [[self childNodeWithName:BNodeName] frame].origin;
    node.position = CGPointMake(B_origin.x + B_size.width + LETTER_SELECT_BUTTON_X_PADDING, A_Y_POSITION);
    node.fillColor = BLUE_COLOR_FOR_LETTER_C;
    return node;
}

- (SKShapeNode *)createNodeNamed:(NSString *)name withLetter:(NSString *)letter {
    CGMutablePathRef path = [letterConverter createPathFromString:letter andSize:[LayoutMath letterButtonFontSizeByForDevice]];
    SKShapeNode *node = [SKShapeNode shapeNodeWithPath:path];
    node.name = name;
    node.userInteractionEnabled = NO;
    node.strokeColor = WHITE_COLOR_FOR_LETTER_OUTLINE;
    node.lineWidth = LINE_WIDTH_FOR_LETTER;
    return node;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
}

@end

//
//  LetterSelectButton.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 6/21/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LetterSelectButton.h"

#import "Constants.h"
#import "LetterConverter.h"

const CGFloat LetterSelectButtonFontSize = 40.0;

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
}

- (SKShapeNode *)create_A_Node {
    SKShapeNode *node = [self createNodeNamed:ANodeName withLetter:@"A"];

    node.position = CGPointZero;
    
    node.fillColor = [UIColor colorWithRed:0.96 green:0.37 blue:0.37 alpha:1.0];
    
    return node;
}

- (SKShapeNode *)create_B_Node {
    SKShapeNode *node = [self createNodeNamed:BNodeName withLetter:@"B"];

    CGSize A_size = [[self childNodeWithName:ANodeName] frame].size;
    node.position = CGPointMake(A_size.width + 5, 10);
    
    node.fillColor = [UIColor colorWithRed:0.67 green:0.88 blue:0.04 alpha:1.0];
    
    return node;
}

- (SKShapeNode *)create_C_Node {
    SKShapeNode *node = [self createNodeNamed:CNodeName withLetter:@"C"];
    
    CGSize B_size = [[self childNodeWithName:BNodeName] frame].size;
    CGPoint B_origin = [[self childNodeWithName:BNodeName] frame].origin;
    node.position = CGPointMake(B_origin.x + B_size.width + 5, 5);
    
    node.fillColor = [UIColor colorWithRed:0.16 green:0.69 blue:0.93 alpha:1.0];
    
    return node;
}

- (SKShapeNode *)createNodeNamed:(NSString *)name withLetter:(NSString *)letter {
    CGMutablePathRef path = [letterConverter createPathFromString:letter andSize:LetterSelectButtonFontSize];
    SKShapeNode *node = [SKShapeNode shapeNodeWithPath:path];
    node.name = name;
    node.userInteractionEnabled = YES;
    node.strokeColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    node.lineWidth = 0.5;
    return node;
}

@end

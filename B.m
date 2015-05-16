//
//  B.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/13/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "B.h"
#import "AttributedStringPath.h"
#import "LayoutMath.h"
#import <UIKit/UIKit.h>

@implementation B

- (void)moveNodeToCenter:(SKNode *)node {
    CGPoint center = [LayoutMath centerOfMainScreen];
    center.x -= (node.frame.size.width * 0.5) - (LetterLineWidth * 0.1);
    center.y -= (node.frame.size.height - LetterLineWidth) * 0.5;
    node.position = center;
}

- (void)transitionToNextScene {
    
}

- (SKShapeNode *)createLetterPathNode {
    AttributedStringPath *attrStringPath = [[AttributedStringPath alloc] initWithString:@"B"];
    SKShapeNode *letterPathNode = [SKShapeNode shapeNodeWithPath:attrStringPath.letterPath];
    letterPathNode.name = LetterNodeName;
    letterPathNode.lineWidth = LetterLineWidth;
    letterPathNode.strokeColor = [SKColor darkGrayColor];
    letterPathNode.fillTexture = [SKTexture textureWithImageNamed:@"TrackTexture"];
    letterPathNode.fillColor = [SKColor whiteColor];
    [self moveNodeToCenter:letterPathNode];
    return letterPathNode;
}

- (SKNode *)createTrainNode {
    SKSpriteNode *trainNode = [[SKSpriteNode alloc] initWithImageNamed:@"MagicTrain"];
    trainNode.name = TrainNodeName;
    return trainNode;
}

- (void)connectSceneTransition {
    [nextButton setTouchUpInsideTarget:self action:@selector(transitionToNextScene)];
}

- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.scene.scaleMode = SKSceneScaleModeAspectFill;
        self.name = @"B";
        [self addChild:[self createTrainNode]];
        [self addChild:[self createLetterPathNode]];
        [self connectSceneTransition];
    }
    return self;
}

@end
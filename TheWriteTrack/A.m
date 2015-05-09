//
//  A.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 3/31/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "A.h"
#import "LayoutMath.h"
#import <UIKit/UIKit.h>

CGFloat const LetterLineWidth = 10;
NSString *const TrainNodeName = @"TrainNode";
NSString *const LetterNodeName = @"LetterNode";

@implementation A

- (void)moveNodeToCenter:(SKNode *)node {
    CGPoint center = [LayoutMath centerOfMainScreen];
    center.x -= (node.frame.size.width * 0.5) - (LetterLineWidth * 0.1);
    center.y -= (node.frame.size.height - LetterLineWidth) * 0.5;
    node.position = center;
}

-(SKShapeNode *)createLetterPathNode {
    AttributedStringPath *attrStringPath = [[AttributedStringPath alloc] initWithString:@"A"];
    SKShapeNode *letterPathNode = [SKShapeNode shapeNodeWithPath:attrStringPath.letterPath];
    letterPathNode.name = LetterNodeName;
    letterPathNode.lineWidth = LetterLineWidth;
    letterPathNode.strokeColor = [SKColor darkGrayColor];
    letterPathNode.fillTexture = [SKTexture textureWithImageNamed:@"TrackTexture"];
    letterPathNode.fillColor = [SKColor whiteColor];
    [self moveNodeToCenter:letterPathNode];
    return letterPathNode;
}

-(SKNode *)createTrainNode {
    SKSpriteNode *trainNode = [[SKSpriteNode alloc] initWithImageNamed:@"MagicTrain"];
    trainNode.name = TrainNodeName;
    return trainNode;
}

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.scene.scaleMode = SKSceneScaleModeAspectFill;
        self.name = @"A";
        [self addChild:[self createTrainNode]];
        [self addChild:[self createLetterPathNode]];
    }
    return self;
}

@end

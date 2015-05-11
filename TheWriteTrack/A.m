//
//  A.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 3/31/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "A.h"
#import "LayoutMath.h"
#import "PathInfo.h"
#import <UIKit/UIKit.h>

CGFloat const LetterLineWidth = 10;
NSString *const TrainNodeName = @"TrainNode";
NSString *const LetterNodeName = @"LetterNode";

@implementation A

- (CGPoint)moveNodeToCenter:(SKNode *)node {
    CGPoint center = [LayoutMath centerOfMainScreen];
    center.x -= (node.frame.size.width * 0.5) - (LetterLineWidth * 0.1);
    center.y -= (node.frame.size.height - LetterLineWidth) * 0.5;
    node.position = center;
    return center;
}

-(SKShapeNode *)createLetterPathNode {
    AttributedStringPath *attrStringPath = [[AttributedStringPath alloc] initWithString:@"A"];
    SKShapeNode *letterPathNode = [SKShapeNode shapeNodeWithPath:attrStringPath.letterPath];
    letterPathNode.name = LetterNodeName;
    letterPathNode.lineWidth = LetterLineWidth;
    letterPathNode.strokeColor = [SKColor darkGrayColor];
    letterPathNode.fillTexture = [SKTexture textureWithImageNamed:@"TrackTexture"];
    letterPathNode.fillColor = [SKColor whiteColor];
    CGPoint center = [self moveNodeToCenter:letterPathNode];
    [self drawDotsAtCenter:center OfPath:attrStringPath.letterPath];
    return letterPathNode;
}

-(void)drawDotsAtCenter:(CGPoint)center OfPath:(CGPathRef)path {
    PathInfo *pathInfo = [[PathInfo alloc] init];
    NSArray *array = [pathInfo TransformPathToArray:path];
    for (NSUInteger i = 0; i < array.count; ++i) {
        SKShapeNode *node = [SKShapeNode shapeNodeWithCircleOfRadius:5];
        node.fillColor = [SKColor redColor];
        NSValue *pointValue = (NSValue *)[array objectAtIndex:i];
        CGPoint point = [pointValue CGPointValue];
        point.x += center.x;
        point.y += center.y;
        node.position = point;
        node.zPosition = 5;
        [self addChild:node];
    }
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

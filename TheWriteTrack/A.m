//
//  A.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 3/31/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "A.h"
#import "B.h"
#import "LayoutMath.h"

#import "CocoaLumberjack.h"
#import <UIKit/UIKit.h>

@implementation A

- (void)moveNodeToCenter:(SKNode *)node {
    CGPoint center = [LayoutMath centerOfMainScreen];
    center.x -= (node.frame.size.width * 0.5) - (LetterLineWidth * 0.1);
    center.y -= (node.frame.size.height - LetterLineWidth) * 0.5;
    node.position = center;
}

- (void)transitionToNextScene {
    NSLog(@"Transition to the B scene");
    B *b = [[B alloc] initWithSize:self.size];
    SKTransition *transition = [SKTransition revealWithDirection:SKTransitionDirectionLeft duration:0.8];
    [self.view presentScene:b transition:transition];
    [self.view setAccessibilityIdentifier:b.name];
}

- (SKShapeNode *)createLetterPathNode {
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
        self.name = @"A";
        [self addChild:[self createTrainNode]];
        [self addChild:[self createLetterPathNode]];
        [self connectSceneTransition];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self.parent];
    
    DDLogInfo(@"Touches ended at point : %@ for class : %@",
               NSStringFromCGPoint(touchPoint), NSStringFromClass([self class]));
    
    [self.nextButtonProperty touchesEnded:touches withEvent:event];
}

@end

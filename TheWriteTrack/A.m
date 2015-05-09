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

@implementation A

- (void)moveNodeToCenter:(SKNode *)node {
    CGPoint center = [LayoutMath centerOfMainScreen];
    center.x -= node.frame.size.width * 0.5;
    center.y -= node.frame.size.height * 0.5;
    node.position = center;
}

-(SKShapeNode *)createLetterPathNode {
    AttributedStringPath *attrStringPath = [[AttributedStringPath alloc] initWithString:@"A"];
    SKShapeNode *letterPathNode = [SKShapeNode shapeNodeWithPath:attrStringPath.letterPath];
    letterPathNode.name = @"LetterNode";
    [self moveNodeToCenter:letterPathNode];
    return letterPathNode;
}

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.scene.scaleMode = SKSceneScaleModeAspectFill;
        self.name = @"A";
        
        [self addChild:[self createLetterPathNode]];
    }
    return self;
}

-(void)didMoveToView:(SKView *)view {
//    [view addSubview:_stringPathView];
    [super didMoveToView:view];
//    [self.view addSubview:_stringPathView];
//    [self.view bringSubviewToFront:_stringPathView];
}

@end

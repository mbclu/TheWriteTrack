//
//  A.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 3/31/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "A.h"
#import "LetterView.h"
#import <UIKit/UIKit.h>

@implementation A

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.scene.scaleMode = SKSceneScaleModeAspectFill;
        self.name = @"A";
        
        AttributedStringPath *attrStringPath = [[AttributedStringPath alloc] initWithString:@"A"];
        SKShapeNode *letterPathNode = [SKShapeNode shapeNodeWithPath:attrStringPath.letterPath];
        letterPathNode.name = @"LetterNode";
        [self addChild:letterPathNode];
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

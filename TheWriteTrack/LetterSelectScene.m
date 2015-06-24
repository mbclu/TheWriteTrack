//
//  LetterSelectScene.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 6/20/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LetterSelectScene.h"

@implementation LetterSelectScene

- (instancetype)init {
    self = [super init];
    self.scaleMode = SKSceneScaleModeAspectFill;
    return self;
}

- (void)didMoveToView:(SKView *)view {
    self.blendMode = SKBlendModeReplace;
    [self sky];
    [self sun];
//    [self arches];
}

- (void)sky {
    self.backgroundColor = [UIColor colorWithRed:0.46 green:0.61 blue:0.89 alpha:1.0];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, self.size.width * 0, self.size.height * 0.56);
    CGPathAddLineToPoint(path, nil, self.size.width, self.size.height * 0.56);

    SKShapeNode *node = [SKShapeNode shapeNodeWithPath:path];
    node.strokeColor = [UIColor colorWithRed:0.79 green:0.85 blue:0.97 alpha:1.0];
    node.lineWidth = 1.0;
    node.name = @"sky";
    
    CGPathRelease(path);
    [self addChild:node];
}

- (void)sun {
    SKShapeNode *node = [SKShapeNode shapeNodeWithCircleOfRadius:0.20];
    node.fillColor = [UIColor colorWithRed:1.00 green:1.00 blue:0.52 alpha:1.0];
    node.name = @"sun";
    node.lineWidth = 0.0;   // If this is anything other than 0.0,
                            // then we get a blending with the background,
                            // instead of a solid shape
    node.position = CGPointMake(self.size.width * 0.03, self.size.height * 0.80);

    [self addChild:node];
}

- (void)arches {
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"ArchedBridge"];
    node.zPosition = 1;
    node.position = CGPointMake(100, 100);
    [self addChild:node];
}

@end

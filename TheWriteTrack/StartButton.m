//
//  StartButton.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/30/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "StartButton.h"
#import "LayoutMath.h"

static const CGFloat LIGHT_CIRCLE_RADIUS = 9.0;
static const CGFloat LIGHT_LINE_WIDTH = 1.0;
static const CGFloat LIGHT_GLOW_WIDTH = 2.0;

@implementation StartButton

- (instancetype)init {
    self = [super init];
    
    [self addTopHalfSignalLight];
    [self addBottomHalfSignalLight];
    
    [self addLightWithColor:[SKColor redColor] andName:@"RedLight"];
    [self addLightWithColor:[SKColor yellowColor] andName:@"YellowLight"];
    [self addLightWithColor:[SKColor greenColor] andName:@"GreenLight"];
    
    [self positionLights];
    
    self.userInteractionEnabled = NO;
    
    return self;
}

- (void)addTopHalfSignalLight {
    SKSpriteNode *top = [SKSpriteNode spriteNodeWithImageNamed:@"SignalLightTop"];
    top.name = @"SignalTopHalf";
    [self addChild:top];
}

- (void)addBottomHalfSignalLight {
    SKSpriteNode *bottom = [SKSpriteNode spriteNodeWithImageNamed:@"SignalLightBottom"];
    bottom.name = @"SignalBottomHalf";
    [self addChild:bottom];
}

- (void)addLightWithColor:(UIColor *)color andName:(NSString *)name {
    SKShapeNode *light = [SKShapeNode shapeNodeWithCircleOfRadius:LIGHT_CIRCLE_RADIUS];
    light.name = name;
    light.fillColor = color;
    light.strokeColor = color;
    light.lineWidth = LIGHT_LINE_WIDTH;
    light.glowWidth = LIGHT_GLOW_WIDTH;
    
    [[self getTopHalf] addChild:light];
}

- (void)positionLights {
    SKNode *bottom = [self childNodeWithName:@"SignalBottomHalf"];
    SKNode *top = [self getTopHalf];
    SKNode *redLight = [self getRedLight];
    SKNode *yellowLight = [self getYellowLight];
    SKNode *greenLight = [self getGreenLight];
    
    const CGFloat xStart = -2;
    const CGFloat topHeightOffsetToMakeItLineUpWithBottom = -4;
    top.position = CGPointMake(0, bottom.frame.size.height + topHeightOffsetToMakeItLineUpWithBottom);
    greenLight.position = CGPointMake(xStart, ONE_THIRD_OF(top.frame.size.height));
    yellowLight.position = CGPointMake(xStart, 0);
    redLight.position = CGPointMake(xStart, -1 * ONE_THIRD_OF(top.frame.size.height));
}

- (SKSpriteNode *)getTopHalf {
    return (SKSpriteNode *)[self childNodeWithName:@"SignalTopHalf"];
}

- (SKShapeNode *)getRedLight {
    return (SKShapeNode *)[[self getTopHalf] childNodeWithName:@"RedLight"];
}

- (SKShapeNode *)getYellowLight {
    return (SKShapeNode *)[[self getTopHalf] childNodeWithName:@"YellowLight"];
}

- (SKShapeNode *)getGreenLight {
    return (SKShapeNode *)[[self getTopHalf] childNodeWithName:@"GreenLight"];
}

@end

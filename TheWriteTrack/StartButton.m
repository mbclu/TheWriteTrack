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

static NSString *RED_LIGHT_NAME = @"RedLight";
static NSString *YELLOW_LIGHT_NAME = @"YellowLight";
static NSString *GREEN_LIGHT_NAME = @"GreenLight";
static NSString *SIGNAL_TOP_HALF_NAME = @"SignalLightTop";
static NSString *SIGNAL_BOTTOM_HALF_NAME = @"SignalLightBottom";

@implementation StartButton

- (instancetype)init {
    self = [super init];
    
    [self addTopHalfSignalLight];
    [self addBottomHalfSignalLight];
    
    [self positionLights];
    
    self.userInteractionEnabled = NO;
    
    return self;
}

- (void)addTopHalfSignalLight {
    [self addSpriteWithImageNamed:SIGNAL_TOP_HALF_NAME];
    
    [self addLightWithColor:[SKColor redColor] andName:RED_LIGHT_NAME];
    [self addLightWithColor:[SKColor yellowColor] andName:YELLOW_LIGHT_NAME];
    [self addLightWithColor:[SKColor greenColor] andName:GREEN_LIGHT_NAME];
}

- (void)addBottomHalfSignalLight {
    [self addSpriteWithImageNamed:SIGNAL_BOTTOM_HALF_NAME];
}

- (void)addSpriteWithImageNamed:(NSString *)name {
    SKSpriteNode *top = [SKSpriteNode spriteNodeWithImageNamed:name];
    top.name = name;
    [self addChild:top];
}

- (void)addLightWithColor:(UIColor *)color andName:(NSString *)name {
    SKShapeNode *light = [SKShapeNode shapeNodeWithCircleOfRadius:LIGHT_CIRCLE_RADIUS];
    light.name = name;
    light.fillColor = color;
    light.strokeColor = color;
    light.lineWidth = LIGHT_LINE_WIDTH;
    light.glowWidth = LIGHT_GLOW_WIDTH;
    
    [[self signalTopHalfNode] addChild:light];
}

- (void)positionLights {
    SKNode *bottom = [self signalBottomHalfNode];
    SKNode *top = [self signalTopHalfNode];
    SKNode *redLight = [self redLightNode];
    SKNode *yellowLight = [self yellowLightNode];
    SKNode *greenLight = [self greenLightNode];
    
    const CGFloat xStart = -2;
    const CGFloat topHeightOffsetToMakeItLineUpWithBottom = -4;
    top.position = CGPointMake(0, bottom.frame.size.height + topHeightOffsetToMakeItLineUpWithBottom);
    greenLight.position = CGPointMake(xStart, ONE_THIRD_OF(top.frame.size.height));
    yellowLight.position = CGPointMake(xStart, 0);
    redLight.position = CGPointMake(xStart, -1 * ONE_THIRD_OF(top.frame.size.height));
}

- (SKSpriteNode *)signalBottomHalfNode {
    return (SKSpriteNode *)[self childNodeWithName:SIGNAL_BOTTOM_HALF_NAME];
}

- (SKSpriteNode *)signalTopHalfNode {
    return (SKSpriteNode *)[self childNodeWithName:SIGNAL_TOP_HALF_NAME];
}

- (SKShapeNode *)redLightNode {
    return (SKShapeNode *)[[self signalTopHalfNode] childNodeWithName:RED_LIGHT_NAME];
}

- (SKShapeNode *)yellowLightNode {
    return (SKShapeNode *)[[self signalTopHalfNode] childNodeWithName:YELLOW_LIGHT_NAME];
}

- (SKShapeNode *)greenLightNode {
    return (SKShapeNode *)[[self signalTopHalfNode] childNodeWithName:GREEN_LIGHT_NAME];
}

@end

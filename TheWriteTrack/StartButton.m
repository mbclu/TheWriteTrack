//
//  StartButton.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/30/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "StartButton.h"

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
    SKShapeNode *light = [SKShapeNode shapeNodeWithCircleOfRadius:9.0];
    light.name = name;
    light.fillColor = color;
    light.strokeColor = color;
    light.lineWidth = 1.0;
    light.glowWidth = 2.0;
    
    [[self getTopHalf] addChild:light];
}

- (void)positionLights {
    SKNode *bottom = [self childNodeWithName:@"SignalBottomHalf"];
    SKNode *top = [self getTopHalf];
    SKNode *redLight = [self getRedLight];
    SKNode *yellowLight = [self getYellowLight];
    SKNode *greenLight = [self getGreenLight];
    
    top.position = CGPointMake(0, bottom.frame.size.height - 4);
    greenLight.position = CGPointMake(-2, top.frame.size.height * +0.33);
    yellowLight.position = CGPointMake(-2, 0);
    redLight.position = CGPointMake(-2, top.frame.size.height * -0.33);
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

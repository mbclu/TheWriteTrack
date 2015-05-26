//
//  PathDots.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/25/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <SpriteKit/SpriteKit.h>

@interface PathDots : NSObject

- (void)drawDotsAtCenter:(CGPoint)center OfPath:(CGPathRef)path inScene:(SKScene *)scene;
- (CGPoint)adjustPoint:(CGPoint)point forPath:(CGPathRef)path withCenter:(CGPoint)center inScene:(SKScene *)scene;
- (void)addPositionLabelToNode:(SKShapeNode *)node atIndex:(NSUInteger)i;

@end

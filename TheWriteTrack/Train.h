//
//  Train.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/19/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "AttributedStringPath.h"
#import "PathSegments.h"
#import <SpriteKit/SpriteKit.h>

@interface Train : SKSpriteNode {
    CGAffineTransform centeringTransform;
}

@property (nonatomic) PathSegments *pathSegments;
@property CGPathRef touchablePath;
@property BOOL isMoving;

- (instancetype)initWithPathSegments:(PathSegments *)pathSegments;
- (instancetype)init NS_UNAVAILABLE;
- (void)evaluateTouchesBeganAtPoint:(CGPoint)touchPoint;
- (void)evaluateTouchesMovedAtPoint:(CGPoint)touchPoint;
- (void)evaluateTouchesEndedAtPoint:(CGPoint)touchPoint;

@end

//
//  GenericSpriteButton.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/11/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GenericSpriteButton : SKSpriteNode

@property (nonatomic, readonly) SEL actionTouchUpInside;
@property (nonatomic, readonly, weak) id targetTouchUpInside;

+ (instancetype)buttonWithImageNamed:(NSString *)name;
- (void)setTouchUpInsideTarget:(id)target action:(SEL)action;
- (void)evaluateTouchAtPoint:(CGPoint)touchPoint;

@end

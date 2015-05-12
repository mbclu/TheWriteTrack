//
//  GenericSpriteButton.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/11/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "GenericSpriteButton.h"

@implementation GenericSpriteButton

- (instancetype)init {
    self = [super init];
    self.userInteractionEnabled = YES;
    return self;
}

- (void)setTouchUpInsideTarget:(id)target action:(SEL)action {
    _targetTouchUpInside = target;
    _actionTouchUpInside = action;
}

- (void)evaluateTouchAtPoint:(CGPoint)touchPoint {
    if (CGRectContainsPoint(self.frame, touchPoint)) {
        objc_msgSend(_targetTouchUpInside, _actionTouchUpInside);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self.parent];
    
    [self evaluateTouchAtPoint:touchPoint];
}

@end

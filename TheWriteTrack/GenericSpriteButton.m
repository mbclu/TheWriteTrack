//
//  GenericSpriteButton.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/11/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "GenericSpriteButton.h"
#import "CocoaLumberjack.h"

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
    if (CGRectContainsPoint(self.frame, touchPoint) && _actionTouchUpInside) {
        [self.parent performSelectorOnMainThread:_actionTouchUpInside
                                      withObject:_targetTouchUpInside
                                   waitUntilDone:YES];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self.parent];
    
    DDLogInfo(@"Touches ended at point : %@ for class : %@",
               NSStringFromCGPoint(touchPoint), NSStringFromClass([self class]));

    [self evaluateTouchAtPoint:touchPoint];
}

@end
//
//  PathDots.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/25/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "PathDots.h"
#import "PathInfo.h"
#import "CocoaLumberjack.h"
#import "LetterConstants.h"

@implementation PathDots

- (void)drawDotsAtCenter:(CGPoint)center OfPath:(CGPathRef)path inScene:(SKScene *)scene {
    PathInfo *pathInfo = [[PathInfo alloc] init];
    NSArray *array = [pathInfo TransformPathToArray:path];
    for (NSUInteger i = 0; i < array.count; ++i) {
        if (i < array.count) {
            SKShapeNode *node = [SKShapeNode shapeNodeWithCircleOfRadius:5];
            node.fillColor = [SKColor redColor];
            node.zPosition = 5;
            NSValue *pointValue = (NSValue *)[array objectAtIndex:i];
            CGPoint position = [self adjustPoint:[pointValue CGPointValue] forPath:path withCenter:center inScene:scene];
            node.position = position;
            [self addPositionLabelToNode:node atIndex:i];
            if ( ! CGPointEqualToPoint(node.position, CGPointZero)) {
                [scene addChild:node];
            }
        }
    }
    DDLogDebug(@"%@", NSStringFromCGPoint(center));
}

- (CGPoint)adjustPoint:(CGPoint)point forPath:(CGPathRef)path withCenter:(CGPoint)center inScene:(SKScene *)scene {
    SKShapeNode *letter = (SKShapeNode *)[scene childNodeWithName:LetterNodeName];
    /* Make initial adjustment */
    if (point.x >= (letter.frame.size.width * 0.5) + 5) {
        point.x -= 15;
        if ( ! CGPathContainsPoint(path, nil, point, NO)) {
            point.x += 30;
        }
    } else if (point.x < (letter.frame.size.width * 0.5) - 5) {
        point.x += 15;
        if ( ! CGPathContainsPoint(path, nil, point, NO)) {
            point.x -= 30;
        }
    }
    if (point.y >= (letter.frame.size.height * 0.5) + 5) {
        point.y -= 15;
        if ( ! CGPathContainsPoint(path, nil, point, NO)) {
            point.y += 30;
        }
    } else if (point.y < (letter.frame.size.height * 0.5) - 5) {
        point.y += 15;
        if ( ! CGPathContainsPoint(path, nil, point, NO)) {
            point.y -= 30;
        }
    }
    if ( ! CGPathContainsPoint(path, nil, point, NO)) {
        point = CGPointZero;
    }
    else {
        point.x += center.x;
        point.y += center.y;
    }
    
    return point;
}

- (void)addPositionLabelToNode:(SKShapeNode *)node atIndex:(NSUInteger)i {
    SKLabelNode *label = [[SKLabelNode alloc] init];
    label.text = [NSString stringWithFormat:@"%lu <%0.1f, %0.1f>",
                  (unsigned long)i,
                  node.position.x,
                  node.position.y];
    label.fontColor = [SKColor redColor];
    label.fontSize = 15;
    [node addChild:label];
}

@end

//
//  PathInfo.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 3/29/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "PathInfo.h"
#import <UIKit/UIKit.h>
#import "CocoaLumberjack.h"

@implementation PathInfo

void AddPathElementToArray(void* info, const CGPathElement* element) {
    NSMutableArray *pathPoints = (__bridge NSMutableArray *)info;
    if (element != nil) {
        CGPoint *points = element->points;
        if (element->type != kCGPathElementCloseSubpath) {
            [pathPoints addObject:[NSValue valueWithCGPoint:points[0]]];
        }
        if (element->type == kCGPathElementAddQuadCurveToPoint ||
            element->type == kCGPathElementAddCurveToPoint) {
            [pathPoints addObject:[NSValue valueWithCGPoint:points[1]]];
        }
        if (element->type == kCGPathElementAddCurveToPoint) {
            [pathPoints addObject:[NSValue valueWithCGPoint:points[2]]];
        }
        
    }
}

-(NSMutableArray *)TransformPathToArray:(CGPathRef)path {
    NSMutableArray *array = [NSMutableArray array];
    CGPathApply(path, (__bridge void *)(array), AddPathElementToArray);
    return array;
}

void PrintPathElement(void* info, const CGPathElement* element)
{
    NSString *pointsString = @"";
    NSString *typeString = nil;
    
    switch (element->type) {
        case kCGPathElementMoveToPoint: {
            CGPoint pt = element->points[0];
            pointsString = [NSString stringWithFormat:@"\t%f %f",
                            pt.x, pt.y];
            typeString = @"MoveToPoint";
            break;
        }
            
        case kCGPathElementAddLineToPoint: {
            CGPoint pt = element->points[0];
            pointsString = [NSString stringWithFormat:@"\t%f %f",
                            pt.x, pt.y];
            typeString = @"LineToPoint";
            break;
        }
            
        case kCGPathElementAddQuadCurveToPoint: {
            CGPoint pt1 = element->points[0];
            CGPoint pt2 = element->points[1];
            pointsString = [NSString stringWithFormat:@"\t%f %f %f %f",
                            pt1.x, pt1.y, pt2.x, pt2.y];
            typeString = @"QuadCurveToPoint";
            break;
        }
            
        case kCGPathElementAddCurveToPoint: {
            CGPoint pt1 = element->points[0];
            CGPoint pt2 = element->points[1];
            CGPoint pt3 = element->points[2];
            pointsString = [NSString stringWithFormat:@"\t%f %f %f %f %f %f",
                            pt1.x, pt1.y, pt2.x, pt2.y, pt3.x, pt3.y];
            typeString = @"CurveToPoint";
            break;
        }
            
        case kCGPathElementCloseSubpath:
            typeString = @"\tCloseSubpath";
            break;
            
        default:
            typeString = @"--Unknown-Element-Type--";
            break;
    }
    DDLogVerbose(@"%@ %@", pointsString, typeString);
}

void PrintPath(CGPathRef path)
{
    DDLogDebug(@"CGPathRef: <%p>", path);
    CGPathApply(path, nil, PrintPathElement);
}

@end

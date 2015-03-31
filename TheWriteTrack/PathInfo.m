//
//  PathInfo.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 3/29/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "PathInfo.h"
#import <UIKit/UIKit.h>

static void PrintPathElement(void* info, const CGPathElement* element)
{
    PrintElementType(element);
}

static void PrintElementType(const CGPathElement* element)
{
    NSString *pointsString = nil;
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
            typeString = @"CloseSubpath";
            break;
            
        default:
            typeString = @"--Unknown-Element-Type--";
            break;
    }
    NSLog(@"%@ %@", pointsString, typeString);
}

void PrintPath(CGPathRef path)
{
    NSLog(@"CGPathRef: <%p>\n", path);
    CGPathApply(path, nil, PrintPathElement);
}
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

void PrintPathElement(void* info, const CGPathElement* element)
{
    PrintElementType(element);
}

void PrintElementType(const CGPathElement* element)
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
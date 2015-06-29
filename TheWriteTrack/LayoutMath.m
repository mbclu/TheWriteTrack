//
//  LayoutMath.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 3/16/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LayoutMath.h"
#import <UIKit/UIKit.h>

@implementation LayoutMath

+ (CGFloat)sizeOfSmallerDimension {
    CGFloat size = [UIScreen mainScreen].bounds.size.width;
    if (size > [UIScreen mainScreen].bounds.size.height) {
        size = [UIScreen mainScreen].bounds.size.height;
    }
    return size;
}

+ (CGFloat)sizeOfLargerDimension {
    CGFloat size = [UIScreen mainScreen].bounds.size.width;
    if (size < [UIScreen mainScreen].bounds.size.height) {
        size = [UIScreen mainScreen].bounds.size.height;
    }
    return size;
}

+ (CGFloat)maximumViableFontSize {
    return ([LayoutMath sizeOfSmallerDimension] - TOP_PADDING - BOTTOM_PADDING);
}

+ (CGFloat)letterButtonFontSizeByForDevice {
    return ([LayoutMath sizeOfLargerDimension] * 0.80 / 13);
}

+ (CGFloat)xCenterForMainScreen {
    CGFloat center = HALF_OF([[UIScreen mainScreen] bounds].size.width);
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsPortrait(deviceOrientation))
    {
        center = HALF_OF([[UIScreen mainScreen] bounds].size.height);
    }
    return center;
}

+ (CGFloat)yCenterForMainScreen {
    CGFloat center = HALF_OF([[UIScreen mainScreen] bounds].size.height);
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsPortrait(deviceOrientation))
    {
        center = HALF_OF([[UIScreen mainScreen] bounds].size.width);
    }
    return center;
}

+ (CGPoint)centerOfMainScreen {
    return CGPointMake([self xCenterForMainScreen], [self yCenterForMainScreen]);
}

+ (CGFloat)findStartingXValueForRect:(CGRect)pathBounds {
    CGFloat x = HALF_OF(([UIScreen mainScreen].bounds.size.width - pathBounds.size.width));
    return x;
}

+ (CGFloat)findStartingYValueForRect:(CGRect)pathBounds {
    CGFloat y = HALF_OF(([UIScreen mainScreen].bounds.size.height - pathBounds.size.height));
    return y;
}

+ (CGPoint)originForUpperLeftPlacementOfPath:(CGPathRef)path {
    CGRect bounds = CGPathGetPathBoundingBox(path);
    CGPoint position = CGPointZero;
    position.y = [UIScreen mainScreen].bounds.size.height - bounds.size.height;
    return position;
}

+ (CGPoint)originForPath:(CGPathRef)path adjacentToPathOnLeft:(CGPathRef)pathOnLeft {
    CGRect bounds = CGPathGetPathBoundingBox(path);
    CGRect leftBounds = CGPathGetPathBoundingBox(pathOnLeft);
    CGPoint position = CGPointZero;
    position.x += leftBounds.size.width;
    position.y = [UIScreen mainScreen].bounds.size.height - bounds.size.height;
    return position;
}

+ (CGFloat)interpolateLineWithStep:(const CGFloat)step start:(const CGFloat)start end:(const CGFloat)end {
    const CGFloat difference = (end - start);
    return start + difference * (1.0 - step);
}

+ (CGFloat)slopeOfLineWithStartPoint:(const CGPoint)start endPoint:(const CGPoint)end {
    return (end.y - start.y) / (end.x - start.x);
}

+ (CGFloat)interpolateQuadBezierAtStep:(const CGFloat)step start:(const CGFloat)start control:(const CGFloat)control end:(const CGFloat)end {
    const CGFloat percent = (1.0 - step);
    const CGFloat percentSquared = percent * percent;
    const CGFloat stepSquared = step * step;
    
    return start * percentSquared
    + 2.0 *  control * percent * step
    + end * stepSquared;
}

+ (CGFloat)tangentQuadBezierAtStep:(const CGFloat)step start:(const CGFloat)start control:(const CGFloat)control end:(const CGFloat)end {
    const CGFloat percent = (1.0 - step);
    
    return 2.0 * percent * (control - start)
    + 2.0 * step * (end - control);
}

@end

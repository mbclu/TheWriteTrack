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

/*
 With OS X v10.4 and later, you can find out the rectangle required to lay out an attributed string using the method, boundingRectWithSize:options:. 
 Again, there is an analogous method to determine the rectangle required to render an NSString object, given a set of attributes—boundingRectWithSize:options:attributes:.
 */
+ (CGFloat)sizeOfSmallerDimension
{
    CGFloat size = [UIScreen mainScreen].bounds.size.width;
    if (size > [UIScreen mainScreen].bounds.size.height) {
        size = [UIScreen mainScreen].bounds.size.height;
    }
    return size;
}

+ (CGFloat)maximumViableFontSize
{
    return ([LayoutMath sizeOfSmallerDimension] - TOP_PADDING - BOTTOM_PADDING);
}

+ (CGFloat)centerX
{
    CGFloat center = [[UIScreen mainScreen] bounds].size.width / 2.0;
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsPortrait(deviceOrientation))
    {
        center = [[UIScreen mainScreen] bounds].size.height / 2.0;
    }
    return center;
}

+ (CGFloat)centerY {
    CGFloat center = [[UIScreen mainScreen] bounds].size.height / 2.0;
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsPortrait(deviceOrientation))
    {
        center = [[UIScreen mainScreen] bounds].size.width / 2.0;
    }
    return center;
}

+ (CGFloat)findStartingXValueForRect:(CGRect)pathBounds {
    CGFloat x = ([UIScreen mainScreen].bounds.size.width - pathBounds.size.width) / 2;
    return x;
}

+ (CGFloat)findStartingYValueForRect:(CGRect)pathBounds {
    CGFloat y = ([UIScreen mainScreen].bounds.size.height - pathBounds.size.height) / 2;
    return y;
}

+ (CGPoint)originForUpperLeftPlacementOfPath:(CGPathRef)path {
    CGRect bounds = CGPathGetPathBoundingBox(path);
    CGPoint position = CGPointZero;
    position.x = 0;
    position.y = [UIScreen mainScreen].bounds.size.height - bounds.size.height;
    return position;
}

@end

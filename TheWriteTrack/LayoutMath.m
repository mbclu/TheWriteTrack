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
    CGFloat size = [[UIScreen mainScreen] bounds].size.width;
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsPortrait(deviceOrientation))
    {
        size = [[UIScreen mainScreen] bounds].size.height;
    }
    return size;
}

+ (CGFloat)maximumViableFontSize
{
    return ([LayoutMath sizeOfSmallerDimension] - TOP_PADDING - BOTTOM_PADDING) / [UIScreen mainScreen].scale;
}

@end

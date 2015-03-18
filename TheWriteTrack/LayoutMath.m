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
    return [LayoutMath sizeOfSmallerDimension] - TOP_PADDING - BOTTOM_PADDING;
}

@end

//
//  LayoutMath.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 3/16/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#define TOP_PADDING                 25.0
#define BOTTOM_PADDING              25.0
#define FONT_POINTS_IN_ONE_INCH     72.0
#define PIXELS_PER_INCH             326.0

@interface LayoutMath : NSObject

+ (CGFloat)sizeOfSmallerDimension;
+ (CGFloat)maximumViableFontSize;

@end

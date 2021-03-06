//
//  PathInfo.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 3/30/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#include <Foundation/Foundation.h>
#include <CoreGraphics/CoreGraphics.h>

@interface PathInfo : NSObject

- (NSMutableArray *)TransformPathToArray:(CGPathRef)path;
- (NSMutableArray *)TransformPathToElementTypes:(CGPathRef)path;
+ (void)printPath:(CGPathRef)path;

@end

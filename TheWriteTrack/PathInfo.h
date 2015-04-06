//
//  PathInfo.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 3/30/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#ifndef OnTheWriteTrack_PathInfo_h
#define OnTheWriteTrack_PathInfo_h

#include <Foundation/Foundation.h>
#include <CoreGraphics/CoreGraphics.h>

void PrintPathElement(void* info, const CGPathElement* element);
void PrintElementType(const CGPathElement* element);
void PrintPath(CGPathRef path);

#endif

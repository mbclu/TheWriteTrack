//
//  CGMatchers.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/9/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#ifndef OnTheWriteTrack_Header_h
#define OnTheWriteTrack_Header_h

#define XCTAssertEqualPoints(point1, point2)    \
{                                               \
    XCTAssertEqual(point1.x, point2.x);         \
    XCTAssertEqual(point1.y, point2.y);         \
}

#endif

//
//  CGMatchers.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/9/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#ifndef OnTheWriteTrack_Header_h
#define OnTheWriteTrack_Header_h

#define XCTAssertEqualPoints(point1, point2)                \
{                                                           \
    XCTAssertEqualWithAccuracy(point1.x, point2.x, 0.001);  \
    XCTAssertEqualWithAccuracy(point1.y, point2.y, 0.001);  \
}

#define XCTAssertEqualSizes(size1, size2)       \
{                                               \
    XCTAssertEqual(size1.width, size2.width);   \
    XCTAssertEqual(size1.height, size2.height); \
}

#define XCTAssertEqualRects(rect1, rect2)                   \
{                                                           \
    XCTAssertEqual(rect1.origin.x, rect2.origin.x);         \
    XCTAssertEqual(rect1.origin.y, rect2.origin.y);         \
    XCTAssertEqual(rect1.size.height, rect2.size.height);   \
    XCTAssertEqual(rect1.size.width, rect2.size.width);     \
}

#endif

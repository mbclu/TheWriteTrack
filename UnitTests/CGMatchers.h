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

#define XCTAssertEqualRGBColors(color1, color2)                                     \
{                                                                                   \
    CGFloat red1, green1, blue1, alpha1;                                            \
    CGFloat red2, green2, blue2, alpha2;                                            \
    XCTAssertTrue([color1 getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1]);   \
    XCTAssertTrue([color2 getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2]);   \
    XCTAssertEqualWithAccuracy(red1, red2, FLT_EPSILON);                            \
    XCTAssertEqualWithAccuracy(green1, green2, FLT_EPSILON);                        \
    XCTAssertEqualWithAccuracy(blue1, blue2, FLT_EPSILON);                          \
    XCTAssertEqualWithAccuracy(alpha1, alpha2, FLT_EPSILON);                        \
}

#endif

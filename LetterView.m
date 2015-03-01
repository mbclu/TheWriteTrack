//
//  LetterView.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/28/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LetterView.h"

@implementation LetterView

- (void) drawRect:(CGRect)rect {
    //    CGPathRef path = [LetterConverter pathFromFirstCharOfStringRef:@"A"];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 50, 50);
    CGPathAddLineToPoint(path, NULL, 200, 200);
    
    CGPathRef thickPath = CGPathCreateCopyByStrokingPath(path, NULL, 10, kCGLineCapButt, kCGLineJoinBevel, 0);
    CGContextAddPath(context, thickPath);
    
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextSetLineWidth(context, 3);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGPathRelease(thickPath);
    CGPathRelease(path);
}

@end

//
//  LetterView.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/28/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LetterView.h"
#import "LetterConverter.h"

@implementation LetterView

- (void) drawRect:(CGRect)rect {
    CGMutablePathRef letterPath = [LetterConverter pathFromFirstCharOfStringRef:@"A"];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(letterPath, NULL, 50, 50);
//    CGPathAddLineToPoint(letterPath, NULL, 200, 200);
    
//    CGPathRef thickPath = CGPathCreateCopyByStrokingPath(letterPath, NULL, 10, kCGLineCapButt, kCGLineJoinBevel, 0);
//    CGContextAddPath(context, thickPath);
    
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextSetLineWidth(context, 10);
    CGContextDrawPath(context, kCGPathFillStroke);
    
//    CGPathRelease(thickPath);
    CGPathRelease(letterPath);
}

@end

//
//  LetterView.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/28/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LetterView.h"
#import "LetterConverter.h"
#import "LayoutMath.h"

@implementation LetterView

@synthesize attrString;
@synthesize attrStringRails;

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    return self;
}

- (UIBezierPath *) createBezierPath {
    return [[UIBezierPath alloc] init];
}

- (void)setupContextForHumanReadableText:(CGContextRef)context {
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
}

- (void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (attrString != nil) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [self setupContextForHumanReadableText:context];
        
        CGMutablePathRef railPath = (__bridge CGMutablePathRef)[self createBezierPath];
        railPath = (CGMutablePathRef)[LetterConverter pathFromAttributedString:attrString];
//        [self movePathToCenter:railPath];
        CGContextAddPath(context, railPath);
        
        [self drawRailInContext:context];
        
        CGPathRelease(railPath);
    }
}

- (void) drawRailInContext:(CGContextRef)context {
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.400 alpha:1.000].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetLineWidth(context, 10);
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void) movePathToCenter:(CGMutablePathRef)path {
    CGPathMoveToPoint(path, nil, [LayoutMath centerX], [LayoutMath centerY]);
}

@end

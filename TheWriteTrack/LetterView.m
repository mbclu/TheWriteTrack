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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andString:(NSString *)string {
    self = [self initWithFrame:frame];
    _stringPath = [[AttributedStringPath alloc] initWithString:string];
    return self;
}


- (void)setupContextForHumanReadableText:(CGContextRef)context {
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
}

//- (CGMutablePathRef)createPathInContext:(CGContextRef)context {
//    CGMutablePathRef railPath = CGPathCreateMutable();
//    railPath = (CGMutablePathRef)[LetterConverter createPathAtZeroUsingAttrString:attrString];
//    CGContextAddPath(context, railPath);
//    return railPath;
//}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
//    if (attrString != nil) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [self setupContextForHumanReadableText:context];
        
//        CGMutablePathRef railPath;
//        railPath = [self createPathInContext:context];
//        
//        [self drawRailInContext:context];
//        
//        CGPathRelease(railPath);
//    }
}

//- (void)drawRailInContext:(CGContextRef)context {
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.400 alpha:1.000].CGColor);
//    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
//    CGContextSetLineWidth(context, 10);
//    CGContextDrawPath(context, kCGPathFillStroke);
//}

- (void)movePathToCenter:(CGMutablePathRef)path {
    CGPoint center = [LayoutMath centerPoint];
    CGPathMoveToPoint(path, nil, center.x, center.y);
}

@end

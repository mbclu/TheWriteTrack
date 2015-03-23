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

@synthesize attrString;
@synthesize attrStringRails;

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    return self;
}

- (void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (attrString != nil) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // Flip the co-ordinate system
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, 0, self.bounds.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
//        CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
        
        CGMutablePathRef railPath = [LetterConverter pathFromAttributedString:attrString];
        CGPathMoveToPoint(railPath, nil, 0.0, 0.0); /* THIS WILL NEED SOME MORE LOGIC */
        CGContextAddPath(context, railPath);
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.400 alpha:1.000].CGColor);
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        CGContextSetLineWidth(context, 10);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        CGPathRelease(railPath);
    }
}

- (void) drawRailInContext:(CGContextRef)context {
    
}

@end

//
//  AttributedStringPath.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/26/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "LetterConverter.h"

@interface AttributedStringPath : NSObject

@property (nonatomic, retain) NSAttributedString *attributedString;
@property (nonatomic) CGPathRef path;

- (instancetype)initWithString:(NSString *)str;

@end

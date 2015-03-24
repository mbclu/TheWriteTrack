//
//  LetterView.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/28/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface LetterView : UIView {
    NSAttributedString *attrString;
    NSAttributedString *attrStringRails;
}

@property (strong) IBOutlet NSAttributedString *attrString;
@property (strong) IBOutlet NSAttributedString *attrStringRails;

- (UIBezierPath *) createBezierPath;
- (void) drawRailInContext:(CGContextRef)context;

@end

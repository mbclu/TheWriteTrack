//
//  AccessibilityHelper.m
//  TheWriteTrack
//
//  Created by Mitch Clutter on 7/18/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "AccessibilityHelper.h"
#import <SpriteKit/SpriteKit.h>

@implementation AccessibilityHelper

+ (void)setAccessibilityName:(NSString *)name forView:(SKView *)view {
    view.isAccessibilityElement = YES;
    view.accessibilityLabel = name;
    view.accessibilityIdentifier = name;
}

@end

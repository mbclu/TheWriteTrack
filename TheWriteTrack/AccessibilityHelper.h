//
//  AccessibilityHelper.h
//  TheWriteTrack
//
//  Created by Mitch Clutter on 7/18/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface AccessibilityHelper : NSObject

+ (void)setAccessibilityName:(NSString *)name forView:(SKView *)view;

@end

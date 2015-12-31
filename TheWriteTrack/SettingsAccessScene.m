//
//  SettingsAccessScene.m
//  TheWriteTrack
//
//  Created by Mitch Clutter on 12/31/15.
//  Copyright © 2015 Mitch Clutter. All rights reserved.
//

#import "SettingsAccessScene.h"
#import "SettingsAccessButton.h"

@implementation SettingsAccessScene

- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        SettingsAccessButton *settingsButtonNode = [[SettingsAccessButton alloc] init];
        settingsButtonNode.position = CGPointMake(self.frame.size.width - settingsButtonNode.frame.size.width - 10, 10);
        settingsButtonNode.zPosition = 500;
        
        [self addChild:settingsButtonNode];
        
        self.backgroundColor = [SKColor clearColor];
    }
    
    return self;
}

@end

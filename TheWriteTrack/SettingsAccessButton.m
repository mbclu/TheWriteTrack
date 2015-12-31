//
//  SettingsAccessButton.m
//  TheWriteTrack
//
//  Created by Mitch Clutter on 12/31/15.
//  Copyright © 2015 Mitch Clutter. All rights reserved.
//

#import "SettingsAccessButton.h"
#import "Constants.h"

@implementation SettingsAccessButton

- (instancetype)init {
    if ((self = (SettingsAccessButton *)[GenericSpriteButton buttonWithImageNamed:SettingsButtonImageName])) {
        self.name = SettingsAccessNode;
        self.accessibilityLabel = SettingsAccessLabel;

        [self setUserInteractionEnabled:YES];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
}

@end

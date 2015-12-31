//
//  SettingsAccessScene.m
//  TheWriteTrack
//
//  Created by Mitch Clutter on 12/31/15.
//  Copyright © 2015 Mitch Clutter. All rights reserved.
//

#import "SettingsAccessScene.h"
#import "SettingsAccessButton.h"
#import "CocoaLumberjack.h"

static DDLogLevel ddLogLevel = DDLogLevelAll;

@implementation SettingsAccessScene

@synthesize settingsButtonProperty = settingsButton;

- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        settingsButton = [[SettingsAccessButton alloc] init];
        settingsButton.position = CGPointMake(self.frame.size.width - settingsButton.frame.size.width - 10, 10);
        settingsButton.zPosition = 500;
        
        [self addChild:settingsButton];
        
        self.backgroundColor = [SKColor clearColor];
        
        [self connectSceneTransitions];
    }
    
    return self;
}

- (void)connectSceneTransitions {
    [settingsButton setTouchUpInsideTarget:self action:@selector(transitionToSettings)];
}

- (void)transitionToSettings {
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self.parent];
    
    DDLogInfo(@"Touches ended at point : %@ for class : <%@> with name : \'%@\'",
              NSStringFromCGPoint(touchPoint),
              NSStringFromClass([self class]),
              [self name]
              );
    
    [self.settingsButtonProperty touchesEnded:touches withEvent:event];
}

@end

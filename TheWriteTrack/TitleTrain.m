//
//  TitleTrain.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/21/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "TitleTrain.h"

@implementation TitleTrain

- (instancetype)init {
    self = [super initWithImageNamed:@"LaunchTrain"];

    self.name = @"TitleTrain";
    
    [self addSmokeEmitter];
    
    return self;
}

- (void)addSmokeEmitter {
    SKEmitterNode *emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:
                              [[NSBundle mainBundle] pathForResource:@"OrangeSmoke" ofType:@"sks"]];
    emitter.name = @"SmokeEmitter";
    emitter.position = CGPointMake(self.size.width, self.size.height);
    [self addChild:emitter];
}

@end

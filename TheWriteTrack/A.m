//
//  A.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 3/31/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "A.h"

@implementation A

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.scene.scaleMode = SKSceneScaleModeAspectFill;
    }
    return self;
}

-(void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
}

@end

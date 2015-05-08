//
//  A.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 3/31/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "A.h"
#import "LetterView.h"
#import <UIKit/UIKit.h>

@implementation A

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.scene.scaleMode = SKSceneScaleModeAspectFill;
        self.name = @"A";
        _stringPathView = [[LetterView alloc] initWithFrame:self.frame andString:@"A"];
    }
    return self;
}

-(void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
}

@end

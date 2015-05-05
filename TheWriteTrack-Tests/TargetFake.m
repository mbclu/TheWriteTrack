//
//  TargetFake.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/4/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "TargetFake.h"

@implementation TargetFake

- (instancetype)init {
    self = [super init];
    
    _didReceiveMessage = NO;
    
    return self;
}

- (void)expectedSelector {
    _didReceiveMessage = YES;
}

@end

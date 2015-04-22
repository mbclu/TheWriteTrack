//
//  TitleTrain.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 4/21/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "TitleTrain.h"

@implementation TitleTrain

- (instancetype) initWithImageNamed:(NSString *)name {
    self = [super initWithImageNamed:name];
    self.name = TITLE_TRAIN;
    self.position = TITLE_TRAIN_START_POSITION;
    return self;
}

@end

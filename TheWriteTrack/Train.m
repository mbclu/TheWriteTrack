//
//  Train.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/19/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "Train.h"

NSString *const MagicTrainName = @"MagicTrain";
NSString *const TrainName = @"Train";

@implementation Train

- (instancetype)initWithAttributedStringPath:(AttributedStringPath*)letterPath {
    self = [self init];
    [self setLetterPath:letterPath];
    return self;
}

- (instancetype)init {
    self = [super initWithImageNamed:MagicTrainName];
    self.name = TrainName;
    return self;
}

@end

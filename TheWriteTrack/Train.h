//
//  Train.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/19/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "AttributedStringPath.h"
#import <SpriteKit/SpriteKit.h>

@interface Train : SKSpriteNode

@property (nonatomic, retain) AttributedStringPath* letterPath;
@property (nonatomic, retain) NSArray *waypoints;

//NS_DESIGNATED_INITIALIZER
- (instancetype)initWithAttributedStringPath:(AttributedStringPath*)letterPath;
- (instancetype)init NS_UNAVAILABLE;
- (void)positionTrainAtStartPoint;

@end

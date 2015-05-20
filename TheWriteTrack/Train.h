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

- (instancetype)initWithAttributedStringPath:(AttributedStringPath*)letterPath;

@end

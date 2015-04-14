//
//  Train.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/20/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#define TITLE_TRAIN_IMAGE_NAME @"TitleTrain"
#define MAGIC_TRAIN_IMAGE_NAME @"MagicTrain"

#define TRAIN_NODE @"Train"

@interface Train : SKSpriteNode

@property (readonly) NSInteger pointsPerSecond;
@property NSMutableArray *wayPoints;
@property CGPoint velocity;

- (void)addPointToMove:(CGPoint)point;

@end

//
//  Train.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/20/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Train : SKSpriteNode

@property (readonly) NSInteger pointsPerSecond;

- (void)addPointToMove:(CGPoint)point;
- (void)move:(NSNumber *)dt;

@end

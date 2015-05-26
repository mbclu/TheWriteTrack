//
//  PathSegments.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/26/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PathSegments : NSObject

@property CGRect segmentBounds;
@property NSMutableArray *segments;

- (void)drawAllSegementsInScene:(SKScene *)scene;

@end

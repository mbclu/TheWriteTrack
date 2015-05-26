//
//  WaypointDropper.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/25/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <SpriteKit/SpriteKit.h>

@interface WaypointDropper : NSObject {
    NSUInteger currentEnvelopeIndex;
    NSMutableArray *waypointArray;
    NSString *letter;
}

- (instancetype)initForLetter:(NSString *)theLetter;
- (NSString *)getWaypointFileName;
- (void)createWaypointPropertyList;
- (void)displayWaypointFileContent;
- (void)addWaypointToArray:(CGPoint)waypoint inScene:(SKScene *)scene;
- (void)placeWaypointForTouches:(NSSet *)touches inScene:(SKScene *)scene;
- (void)moveWaypointForTouches:(NSSet *)touches inScene:(SKScene *)scene;

@end

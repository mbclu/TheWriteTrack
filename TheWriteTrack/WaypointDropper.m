//
//  WaypointDropper.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/25/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "WaypointDropper.h"
#import "LetterConstants.h"
#import "CocoaLumberjack.h"
#import <SpriteKit/SpriteKit.h>
#import <UIKit/UIKit.h>

@implementation WaypointDropper

- (instancetype)initForLetter:(NSString *)theLetter {
    self = [super init];
    currentEnvelopeIndex = 0;
    waypointArray = [[NSMutableArray alloc] init];
    letter = theLetter;
    return self;
}

- (void)addEnvelopeAtPoint:(CGPoint)touchPoint inScene:(SKScene *)scene {
    if (CGRectContainsPoint([scene childNodeWithName:LetterNodeName].frame, touchPoint)) {
        currentEnvelopeIndex++;
        SKSpriteNode *node = [[SKSpriteNode alloc] initWithImageNamed:@"Envelope"];
        node.name = [NSString stringWithFormat:@"%lui" , (unsigned long)currentEnvelopeIndex];
        node.position = touchPoint;
        [scene addChild:node];
    }
}

- (void)moveLastPlacedEnvelopeToPoint:(CGPoint)touchPoint inScene:(SKScene *)scene {
    if (CGRectContainsPoint([scene childNodeWithName:LetterNodeName].frame, touchPoint)) {
        SKSpriteNode *node = (SKSpriteNode *)[scene childNodeWithName:[NSString stringWithFormat:@"%lui" , (unsigned long)currentEnvelopeIndex]];
        node.position = touchPoint;
    }
}

- (NSString *)getWaypointFileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@_waypoints.plist",
                          libDirectory,
                          letter];
    return fileName;
}

/***********************************************************************************************
 * Here is a fun fact:
 * ~/Library/Developer/CoreSimulator/Devices/2D048742-A844-4620-AD5B-C832A0A1A658/data/...
 * ./Containers/Data/Application/1E1A5B19-33C3-4FDA-85B2-8C65A41B690A/Library/
 * YEAH! That is the file directory that get's written from this call....... Phwew!
 * The first UUID matches the simulator device which I confirmed with ```xcrun simctl list```
 * The second must be the Application itself, but I haven't confirmed
 **********************************************************************************************/
- (void)createWaypointPropertyList {
    [waypointArray writeToFile:[self getWaypointFileName] atomically:NO];
}

- (void)addWaypointToArray:(CGPoint)waypoint inScene:(SKScene *)scene {
    if (CGRectContainsPoint([scene childNodeWithName:LetterNodeName].frame, waypoint)) {
        [waypointArray addObject:NSStringFromCGPoint(waypoint)];
    }
}

- (void)displayWaypointFileContent {
    NSString *content = [[NSString alloc] initWithContentsOfFile:[self getWaypointFileName]
                                                    usedEncoding:nil
                                                           error:nil];
    DDLogDebug(@"Contents of waypoint file:\n%@", content);
}

- (void)placeWaypointForTouches:(NSSet *)touches inScene:(SKScene *)scene {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:scene];
    [self addEnvelopeAtPoint:touchPoint inScene:scene];
}

- (void)moveWaypointForTouches:(NSSet *)touches inScene:(SKScene *)scene {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:scene];
    
    [self moveLastPlacedEnvelopeToPoint:touchPoint inScene:scene];
}

@end

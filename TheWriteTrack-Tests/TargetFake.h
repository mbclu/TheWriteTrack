//
//  TargetFake.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/4/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TargetFake : NSObject

@property bool didReceiveMessage;

- (void)expectedSelector;

@end

//
//  LetterPathSegmentDictionary.h
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/31/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "PathSegmentsIndeces.h"

#import <Foundation/Foundation.h>

@interface LetterPathSegmentDictionary : NSObject {
}

+ (NSArray *)initializeUpperCaseKeys;
+ (NSDictionary *)dictionaryWithUpperCasePathSegments;

@end

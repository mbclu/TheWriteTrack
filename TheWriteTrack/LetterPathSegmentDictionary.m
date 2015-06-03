//
//  LetterPathSegmentDictionary.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/31/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LetterPathSegmentDictionary.h"

@implementation LetterPathSegmentDictionary

+ (NSArray *)initializeUpperCaseKeys {
    NSMutableArray *letterKeys = [[NSMutableArray alloc] init];
    for (unichar key = 'A'; key <= 'Z'; key++) {
        [letterKeys addObject:[NSString stringWithCharacters:&key length:1]];
    }
    return (NSArray *)letterKeys;
}

+ (NSDictionary *)dictionaryWithUpperCasePathSegments {
    NSArray *letterKeys = [self initializeUpperCaseKeys];
    NSMutableArray *letterValues = [[NSMutableArray alloc] init];
    
    /* A */ [letterValues addObject:[NSArray arrayWithObjects:RD, a43, a42, a41, a40, SE, ND, a44, a45, a46, a47, SE, h29, h30, SE, nil]];
    /* B */ [letterValues addObject:[NSArray arrayWithObjects:RD, v7, v6, v5, v4, SE, ND, h37, c68, c69, h29, RD, h29, ND, c70, c71, RD, h21, SE, nil]];
    /* C */ [letterValues addObject:[NSArray arrayWithObjects:c68, c72, c73, c71, SE, nil]];
    /* D */ [letterValues addObject:[NSArray arrayWithObjects:RD, v7, v6, v5, v4, SE, ND, h21, RD, c74, c75, h37, SE, nil]];
    /* E */ [letterValues addObject:[NSArray arrayWithObjects:nil]];
    /* F */ [letterValues addObject:[NSArray arrayWithObjects:nil]];
    /* G */ [letterValues addObject:[NSArray arrayWithObjects:nil]];
    /* H */ [letterValues addObject:[NSArray arrayWithObjects:nil]];
    /* I */ [letterValues addObject:[NSArray arrayWithObjects:nil]];
    /* J */ [letterValues addObject:[NSArray arrayWithObjects:nil]];
    /* K */ [letterValues addObject:[NSArray arrayWithObjects:nil]];
    /* L */ [letterValues addObject:[NSArray arrayWithObjects:nil]];
    /* M */ [letterValues addObject:[NSArray arrayWithObjects:nil]];
    /* N */ [letterValues addObject:[NSArray arrayWithObjects:nil]];
    /* O */ [letterValues addObject:[NSArray arrayWithObjects:nil]];
    /* P */ [letterValues addObject:[NSArray arrayWithObjects:nil]];
    /* Q */ [letterValues addObject:[NSArray arrayWithObjects:nil]];
    /* R */ [letterValues addObject:[NSArray arrayWithObjects:nil]];
    /* S */ [letterValues addObject:[NSArray arrayWithObjects:nil]];
    /* T */ [letterValues addObject:[NSArray arrayWithObjects:nil]];
    /* U */ [letterValues addObject:[NSArray arrayWithObjects:nil]];
    /* V */ [letterValues addObject:[NSArray arrayWithObjects:nil]];
    /* W */ [letterValues addObject:[NSArray arrayWithObjects:nil]];
    /* X */ [letterValues addObject:[NSArray arrayWithObjects:nil]];
    /* Y */ [letterValues addObject:[NSArray arrayWithObjects:nil]];
    /* Z */ [letterValues addObject:[NSArray arrayWithObjects:nil]];

    return [NSDictionary dictionaryWithObjects:letterValues forKeys:letterKeys];
}

@end

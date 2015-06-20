//
//  PathSegmentDictionary.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/31/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "PathSegmentDictionary.h"

@implementation PathSegmentDictionary

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
    /* C */ [letterValues addObject:[NSArray arrayWithObjects:RD, c68, ND, c72, c73, RD, c71, SE, nil]];
    /* D */ [letterValues addObject:[NSArray arrayWithObjects:RD, v7, v6, v5, v4, SE, ND, h37, RD, c75, c74, h21, SE, nil]];
    /* E */ [letterValues addObject:[NSArray arrayWithObjects:RD, v7, v6, v5, v4, SE, ND, h37, h38, h39, SE, h29, h30, SE, h21, h22, h23, SE, nil]];
    /* F */ [letterValues addObject:[NSArray arrayWithObjects:RD, v7, v6, v5, v4, SE, ND, h37, h38, h39, SE, h29, h30, SE, nil]];
    /* G */ [letterValues addObject:[NSArray arrayWithObjects:RD, c68, ND, c72, c73, c74, RD, h31, h30, SE, nil]];
    /* H */ [letterValues addObject:[NSArray arrayWithObjects:RD, v7, v6, v5, v4, SE, v19, v18, v17, v16, SE, ND, h29, h30, h31, SE, nil]];
    /* I */ [letterValues addObject:[NSArray arrayWithObjects:RD, v11, v10, v9, v8, SE, ND, h37, h38, SE, h21, h22, SE, nil]];
    /* J */ [letterValues addObject:[NSArray arrayWithObjects:RD, v11, v10, v9, ND, c76, c77, SE, nil]];
    /* K */ [letterValues addObject:[NSArray arrayWithObjects:RD, v11, v10, v9, v8, SE, x59, x58, ND, x62, x63, SE, nil]];
    /* L */ [letterValues addObject:[NSArray arrayWithObjects:RD, v7, v6, v5, v4, SE, ND, h21, h22, SE, nil]];
    /* M */ [letterValues addObject:[NSArray arrayWithObjects:RD, v3, v2, v1, v0, SE, ND, x60, x61, x58, x59, RD, v19, v18, v17, v16, SE, nil]];
    /* N */ [letterValues addObject:[NSArray arrayWithObjects:RD, v3, v2, v1, v0, SE, ND, x60, x61, x62, x63, ND, v16, v17, v18, v19, SE, nil]];
    /* O */ [letterValues addObject:[NSArray arrayWithObjects:c72, c73, c74, c75, SE, nil]];
    /* P */ [letterValues addObject:[NSArray arrayWithObjects:RD, v7, v6, v5, v4, SE, ND, h37, c68, c69, RD, h29, SE, nil]];
    /* Q */ [letterValues addObject:[NSArray arrayWithObjects:c72, c73, c74, c75, SE, x62, x63, SE, nil]];
    /* R */ [letterValues addObject:[NSArray arrayWithObjects:RD, v7, v6, v5, v4, SE, ND, h37, c68, c69, RD, h29, SE, ND, h29, x62, x63, SE, nil]];
    /* S */ [letterValues addObject:[NSArray arrayWithObjects:RD, c68, c67, c66, ND, c70, c71, c64, SE, nil]];
    /* T */ [letterValues addObject:[NSArray arrayWithObjects:RD, v11, v10, v9, v8, SE, ND, h36, h37, h38, h39, SE, nil]];
    /* U */ [letterValues addObject:[NSArray arrayWithObjects:RD, v3, v2, ND, c73, c74, v18, v19, SE, nil]];
    /* V */ [letterValues addObject:[NSArray arrayWithObjects:v48, v49, v50, v51, v52, v53, v54, v55, SE, nil]];
    /* W */ [letterValues addObject:[NSArray arrayWithObjects:RD, v3, v2, v1, v0, ND, x56, x57, x62, x63, v16, v17, v18, v19, SE, nil]];
    /* X */ [letterValues addObject:[NSArray arrayWithObjects:x60, x61, x62, x63, SE, RD, x59, x58, x57, x56, SE, nil]];
    /* Y */ [letterValues addObject:[NSArray arrayWithObjects:x60, x61, SE, RD, x59, x58, v9, v8, SE, nil]];
    /* Z */ [letterValues addObject:[NSArray arrayWithObjects:h36, h37, h38, h39, RD, x59, x58, x57, x56, ND, h20, h21, h22, h23, SE, nil]];

    return [NSDictionary dictionaryWithObjects:letterValues forKeys:letterKeys];
}

@end

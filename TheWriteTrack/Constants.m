//
//  LetterConstants.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 5/13/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "Constants.h"

CGFloat const LetterLineWidth = 10;
NSString *const TrainNodeName = @"TrainNode";
NSString *const LetterOutlineName = @"LetterOutlineNode";
NSString *const RockyBackgroundName = @"RockyBackground";
NSString *const NextButtonName = @"NextButton";
NSString *const PreviousButtonName = @"PreviousButton";
NSString *const LetterSelectButtonName = @"LetterSelectButton";
NSString *const TrackTextureName = @"TrackTexture";
NSString *const EnvelopeTextureName = @"Envelope";
NSString *const LetterSceneTrackContainerNodeName = @"TrackContainerNode";
NSString *const WaypointNodeName = @"WaypointNode";
NSString *const CrossbarNodeName = @"CrossbarNode";
CGFloat const NextButtonXPadding = 10;
CGFloat const TransitionLengthInSeconds = 0.6;
NSUInteger const SingleLetterLength = 1;
CFStringRef const DefaultLetterFont = (CFStringRef)@"Thonburi";

/* Buttons */
/* Start Button */
NSString *const StartText = @"start";
NSString *const StartStringSmokeSKS = @"StartStringSmoke";
CGFloat const StartStringSize = 125.0;
CGFloat const LetterHoriztontalOffset = 10.0;
CGFloat const ButtonOffsetMultiplier = 1.5;
CGFloat const FollowPathDuration = 2.0;     // The smaller the number
                                            // the faster the letters get filled in

/* Letter Select Button */
NSString *const ANodeName = @"ANode";
NSString *const BNodeName = @"BNode";
NSString *const CNodeName = @"CNode";

/* Chosen Letter Button */
NSString *const ChosenLetterNode = @"LetterNode";

/* Scenes */
/* Letter Select Scene */
double const MinMountainHeightChangePercentage = 0.30;
NSString *const ChosenLetterOverlay = @"LetterOverlayNode";

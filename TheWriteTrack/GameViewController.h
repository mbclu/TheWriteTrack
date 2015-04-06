//
//  GameViewController.h
//  The Write Track
//

//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LetterView.h"

@interface GameViewController : UIViewController {
    LetterView *letterView;
}

@property(nonatomic, retain) LetterView *letterView;

#ifdef DEBUG
- (void)addDebugPrintPathButton;
- (void)buttonPressed;
#endif

@end

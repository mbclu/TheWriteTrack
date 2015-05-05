//
//  GameViewController.m
//  The Write Track
//
//  Created by Mitch Clutter on 2/7/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "GameViewController.h"
#import "TitleScene.h"
#import "PathInfo.h"
#import "CocoaLumberjack.h"
#import "LetterConverter.h"

@implementation SKScene (Unarchive)

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    SKView *skView = (SKView *)self.view;
    if (!skView.scene) {
        TitleScene *titleScene = [[TitleScene alloc] initWithSize:skView.bounds.size];
        [skView setAccessibilityIdentifier:titleScene.name];
        [skView presentScene:titleScene];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end

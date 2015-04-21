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

static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

@implementation SKScene (Unarchive)

@end

@implementation GameViewController
@synthesize letterView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#ifdef DEBUG
//    [self addDebugPrintPathButton];
#endif
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    SKView *skView = (SKView *)self.view;
    if (!skView.scene) {
        TitleScene *titleScene = [TitleScene sceneWithSize:skView.bounds.size];
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

#ifdef DEBUG
- (void)addDebugPrintPathButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 170, 100, 30);
    [button setBackgroundColor:[UIColor redColor]];
    [button setTitle:@"Log Letter Path Data" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)buttonPressed {
    PrintPath([LetterConverter pathFromAttributedString:[self.letterView attrString]]);
    DDLogInfo(@"Button Pressed!");
}
#endif

@end

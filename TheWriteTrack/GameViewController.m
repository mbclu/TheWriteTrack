//
//  GameViewController.m
//  The Write Track
//
//  Created by Mitch Clutter on 2/7/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "GameViewController.h"
#import "_BaseTrackScene.h"
#import "LetterView.h"

@implementation SKScene (Unarchive)

@end

@implementation GameViewController
@synthesize letterView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.letterView = [[LetterView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"Verdana", 325.0, NULL);
    NSDictionary *attrDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    (__bridge id)fontRef, (NSString *)kCTFontAttributeName,
                                    (id)[[UIColor blueColor] CGColor], (NSString *)kCTForegroundColorAttributeName,
                                    (id)[[UIColor redColor] CGColor], (NSString *)kCTStrokeColorAttributeName,
                                    (id)[NSNumber numberWithFloat:-3.0], (NSString *)kCTStrokeWidthAttributeName,
                                    nil];
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"Hello World" attributes:attrDictionary];
    
    [self.letterView setAttrString:attrString];
    
    self.letterView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.letterView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
 
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        skView.showsFPS = NO;
        skView.showsNodeCount = NO;
        
        // Create and configure the scene.
        SKScene * scene = [_BaseTrackScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
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

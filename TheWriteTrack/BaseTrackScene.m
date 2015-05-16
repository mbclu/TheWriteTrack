//
//  _BaseTrack.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/11/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "BaseTrackScene.h"
#import "GenericSpriteButton.h"
#import "LetterConstants.h"

NSString *const RockyBackgroundName = @"RockyBackground";
NSString *const NextButtonName = @"NextButton";
CGFloat const NextButtonXPadding = 10;

@implementation BaseTrackScene

@synthesize nextButtonProperty = nextButton;

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"Touches on Title Scene!");
//    UITouch *touch = [touches anyObject];
//    CGPoint location = [touch locationInNode:self];
//    SKNode *node = [self nodeAtPoint:location];
//
//    NSLog(@"Node : %@", node.name);
//    if ([node.name isEqualToString:START_BUTTON]) {
//        NSLog(@"Start button pressed!");
//        SKScene *sampleScene = [[A alloc] initWithSize:self.size];
//        SKTransition *transition = [SKTransition flipVerticalWithDuration:0.5];
//        [self.view presentScene:sampleScene transition:transition];
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    SKSpriteNode *node = (SKSpriteNode*)[self childNodeWithName:TITLE_TRAIN];
//    UITouch *touch = [touches anyObject];
//    node.position = [touch locationInNode:self];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    SKSpriteNode *node = (SKSpriteNode*)[self childNodeWithName:TITLE_TRAIN];
//    DDLogDebug(@"Train Node position: %@", NSStringFromCGPoint(node.position));
//}

- (void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

- (void)addBackground {
    SKSpriteNode *rockyBackground = [SKSpriteNode spriteNodeWithImageNamed:RockyBackgroundName];
    rockyBackground.name = RockyBackgroundName;
    rockyBackground.anchorPoint = CGPointZero;
    [self addChild:rockyBackground];
}

- (GenericSpriteButton *)createNextButton {
    GenericSpriteButton *button = [[GenericSpriteButton alloc] initWithImageNamed:NextButtonName];
    button.name = NextButtonName;
    button.anchorPoint = CGPointZero;
    button.position = CGPointMake(self.size.width - button.size.width - NextButtonXPadding,
                                  (self.size.height - button.size.height) * 0.5);
    button.color = [SKColor redColor];

    NSLog(@"%@", NSStringFromCGRect(button.frame));
    return button;
}

- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self setScaleMode:SKSceneScaleModeAspectFill];
        
        [self addBackground];
        
        nextButton = [self createNextButton];
        [self addChild:nextButton];
    }
    return self;
}

@end

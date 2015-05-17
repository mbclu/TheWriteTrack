//
//  _BaseTrack.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/11/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LetterBaseScene.h"

#import "AttributedStringPath.h"
#import "CocoaLumberjack.h"
#import "GenericSpriteButton.h"
#import "LayoutMath.h"
#import "LetterConstants.h"

NSString *const RockyBackgroundName = @"RockyBackground";
NSString *const NextButtonName = @"NextButton";
NSString *const TrackTextureName = @"TrackTexture";
NSString *const MagicTrainName = @"MagicTrain";
CGFloat const NextButtonXPadding = 10;
CGFloat const TransitionLengthInSeconds = 0.6;

@implementation LetterBaseScene

@synthesize nextButtonProperty = nextButton;

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
}

- (instancetype)initWithSize:(CGSize)size AndLetter:(NSString *)letter {
    if (self = [super initWithSize:size]) {
        [self setScaleMode:SKSceneScaleModeAspectFill];
        
        [self addChild:[self createBackground]];
        
        if (![letter isEqual:@"Z"]) {
            nextButton = [self createNextButton];
            [self addChild:nextButton];
        }
        
        ///Letter Stuff
        _letter = [letter characterAtIndex:0];
        
        [self.scene setScaleMode:SKSceneScaleModeAspectFill];
        [self setName:[NSString stringWithCharacters:&_letter length:1]];
        [self addChild:[self createTrainNode]];
        [self addChild:[self createLetterPathNode]];
        [self connectSceneTransition];
    }
    return self;
}

- (SKSpriteNode *)createBackground {
    SKSpriteNode *rockyBackground = [SKSpriteNode spriteNodeWithImageNamed:RockyBackgroundName];
    rockyBackground.name = RockyBackgroundName;
    rockyBackground.anchorPoint = CGPointZero;
    return rockyBackground;
}

- (GenericSpriteButton *)createNextButton {
    GenericSpriteButton *button = [[GenericSpriteButton alloc] initWithImageNamed:NextButtonName];
    button.name = NextButtonName;
    button.anchorPoint = CGPointZero;
    button.position = CGPointMake(self.size.width - button.size.width - NextButtonXPadding,
                                  (self.size.height - button.size.height) * 0.5);
    button.color = [SKColor redColor];
    
    return button;
}

- (SKShapeNode *)createLetterPathNode {
    AttributedStringPath *attrStringPath = [[AttributedStringPath alloc] initWithString:
                                            [NSString stringWithCharacters:&_letter length:1]];
    SKShapeNode *letterPathNode = [SKShapeNode shapeNodeWithPath:attrStringPath.letterPath];
    letterPathNode.name = LetterNodeName;
    letterPathNode.lineWidth = LetterLineWidth;
    letterPathNode.strokeColor = [SKColor darkGrayColor];
    letterPathNode.fillTexture = [SKTexture textureWithImageNamed:TrackTextureName];
    letterPathNode.fillColor = [SKColor whiteColor];
    [self moveNodeToCenter:letterPathNode];
    return letterPathNode;
}

- (SKNode *)createTrainNode {
    SKSpriteNode *trainNode = [[SKSpriteNode alloc] initWithImageNamed:MagicTrainName];
    trainNode.name = TrainNodeName;
    return trainNode;
}

- (void)moveNodeToCenter:(SKNode *)node {
    CGPoint center = [LayoutMath centerOfMainScreen];
    center.x -= (node.frame.size.width * 0.5) - (LetterLineWidth * 0.1);
    center.y -= (node.frame.size.height - LetterLineWidth) * 0.5;
    node.position = center;
}

- (void)transitionToNextScene {
    unichar nextCharacter = (unichar)(_letter + 1);
    NSString *nextLetter = [NSString stringWithCharacters:&nextCharacter length:1];
    DDLogInfo(@"Transitioning to the %@ scene", nextLetter);
    
    SKScene *nextScene = [[LetterBaseScene alloc] initWithSize:self.size AndLetter:nextLetter];
    SKTransition *transition = [SKTransition revealWithDirection:SKTransitionDirectionLeft duration:TransitionLengthInSeconds];
    
    [self.view presentScene:nextScene transition:transition];
    [self.view setIsAccessibilityElement:YES];
    [self.view setAccessibilityIdentifier:nextScene.name];
}

- (void)connectSceneTransition {
    [nextButton setTouchUpInsideTarget:self action:@selector(transitionToNextScene)];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self.parent];
    
    DDLogInfo(@"Touches ended at point : %@ for class : <%@> with name : \'%@\'",
              NSStringFromCGPoint(touchPoint),
              NSStringFromClass([self class]),
              [self name]
              );
    
    [self.nextButtonProperty touchesEnded:touches withEvent:event];
}

@end

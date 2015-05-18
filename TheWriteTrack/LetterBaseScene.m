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
#import "PathInfo.h"

NSString *const RockyBackgroundName = @"RockyBackground";
NSString *const NextButtonName = @"NextButton";
NSString *const PreviousButtonName = @"PreviousButton";
NSString *const TrackTextureName = @"TrackTexture";
NSString *const MagicTrainName = @"MagicTrain";
CGFloat const NextButtonXPadding = 10;
CGFloat const TransitionLengthInSeconds = 0.6;
NSUInteger const SingleLetterLength = 1;

@implementation LetterBaseScene

@synthesize nextButtonProperty = nextButton;
@synthesize previousButtonProperty = previousButton;

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
}

- (instancetype)initWithSize:(CGSize)size AndLetter:(NSString *)letter {
    if (self = [super initWithSize:size]) {
        _letter = [letter characterAtIndex:0];
        
        [self setScaleMode:SKSceneScaleModeAspectFill];
        [self setName:[self stringFromSceneUnicharLetter]];
        
        [self addChild:[self createBackground]];
        
        if (![letter isEqual:@"Z"]) {
            nextButton = [self createNextButton];
            [self addChild:nextButton];
        }
        
        if (![letter isEqual:@"A"]) {
            previousButton = [self createPreviousButton];
            [self addChild:previousButton];
        }
        
        [self addChild:[self createLetterPathNode]];
        
        [self addChild:[self createTrainNode]];
        
        [self connectSceneTransitions];
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
    return button;
}

- (GenericSpriteButton *)createPreviousButton {
    GenericSpriteButton *button = [[GenericSpriteButton alloc] initWithImageNamed:PreviousButtonName];
    button.name = PreviousButtonName;
    button.anchorPoint = CGPointZero;
    button.position = CGPointMake(self.frame.origin.x + NextButtonXPadding,
                                  (self.size.height - button.size.height) * 0.5);
    return button;
}

- (SKShapeNode *)createLetterPathNode {
    AttributedStringPath *attrStringPath = [[AttributedStringPath alloc] initWithString:[self stringFromSceneUnicharLetter]];
    SKShapeNode *letterPathNode = [SKShapeNode shapeNodeWithPath:attrStringPath.letterPath];
    letterPathNode.name = LetterNodeName;
    letterPathNode.lineWidth = LetterLineWidth;
    letterPathNode.strokeColor = [SKColor darkGrayColor];
    letterPathNode.fillTexture = [SKTexture textureWithImageNamed:TrackTextureName];
    letterPathNode.fillColor = [SKColor whiteColor];
    CGPoint center = [self moveNodeToCenter:letterPathNode];
#ifdef DEBUG
    [self drawDotsAtCenter:center OfPath:attrStringPath.letterPath];
#endif
    return letterPathNode;
}

- (SKNode *)createTrainNode {
    SKSpriteNode *trainNode = [[SKSpriteNode alloc] initWithImageNamed:MagicTrainName];
    trainNode.name = TrainNodeName;
    return trainNode;
}

- (CGPoint)moveNodeToCenter:(SKNode *)node {
    CGPoint center = [LayoutMath centerOfMainScreen];
    center.x -= (node.frame.size.width * 0.5) - (LetterLineWidth * 0.1);
    center.y -= (node.frame.size.height - LetterLineWidth) * 0.5;
    node.position = center;
    return center;
}

#ifdef DEBUG
-(void)drawDotsAtCenter:(CGPoint)center OfPath:(CGPathRef)path {
    PathInfo *pathInfo = [[PathInfo alloc] init];
    NSArray *array = [pathInfo TransformPathToArray:path];
    for (NSUInteger i = 0; i < array.count; ++i) {
        SKShapeNode *node = [SKShapeNode shapeNodeWithCircleOfRadius:5];
        node.fillColor = [SKColor redColor];
        NSValue *pointValue = (NSValue *)[array objectAtIndex:i];
        CGPoint point = [pointValue CGPointValue];
        point.x += center.x;
        point.y += center.y;
        node.position = point;
        node.zPosition = 5;
        SKLabelNode *label = [[SKLabelNode alloc] init];
        label.text = [NSString stringWithFormat:@"%lu", (unsigned long)i];
        label.fontColor = [SKColor whiteColor];
        label.fontSize = 20;
        [node addChild:label];
        [self addChild:node];
    }
}
#endif

- (void)transitionToSceneWithLetter:(NSString *)letter {
    DDLogInfo(@"Transitioning to the %@ scene", letter);
    
    SKScene *nextScene = [[LetterBaseScene alloc] initWithSize:self.size AndLetter:letter];
    SKTransition *transition = [SKTransition revealWithDirection:SKTransitionDirectionLeft duration:TransitionLengthInSeconds];
    
    [self.view presentScene:nextScene transition:transition];
    [self.view setIsAccessibilityElement:YES];
    [self.view setAccessibilityIdentifier:nextScene.name];
}

- (void)transitionToNextScene {
    [self transitionToSceneWithLetter:[self nextLetterString]];
}

- (void)transitionToPreviousScene {
    [self transitionToSceneWithLetter:[self previousLetterString]];
}

- (void)connectSceneTransitions {
    [nextButton setTouchUpInsideTarget:self action:@selector(transitionToNextScene)];
    [previousButton setTouchUpInsideTarget:self action:@selector(transitionToPreviousScene)];
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
    [self.previousButtonProperty touchesEnded:touches withEvent:event];
}

- (NSString *)stringFromSceneUnicharLetter {
    return [NSString stringWithCharacters:&_letter length:SingleLetterLength];
}

- (NSString *)nextLetterString {
    unichar nextCharacter = (unichar)(_letter + 1);
    return [NSString stringWithCharacters:&nextCharacter length:SingleLetterLength];
}

- (NSString *)previousLetterString {
    unichar previousCharacter = (unichar)(_letter - 1);
    return [NSString stringWithCharacters:&previousCharacter length:SingleLetterLength];
}

@end

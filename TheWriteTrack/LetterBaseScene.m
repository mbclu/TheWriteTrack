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
#import "Constants.h"
#import "Train.h"
#import "PathSegments.h"

#if (APP_SHOULD_DRAW_DOTS)
    #import "PathDots.h"
#endif

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

        [self addNavigationButtons];
        
        AttributedStringPath *letterPath = [[AttributedStringPath alloc] initWithString:[self stringFromSceneUnicharLetter]];
        SKShapeNode* letterNode = [self createLetterPathNode:letterPath];
        CGPoint center = [self moveNodeToCenter:letterNode];
        CGAffineTransform centerTranslateTransform = CGAffineTransformMakeTranslation(center.x, center.y);
//        [self addChild:letterNode];
        
        [self connectSceneTransitions];

        PathSegments *pathSegments = [[PathSegments alloc] init];
        [pathSegments generateCombinedPathAndCrossbarsForLetter:self.name atCenter:center];
        SKShapeNode *letter = [self createTrackPathNode:pathSegments.combinedPath withTransform:centerTranslateTransform];
        [self addChild:letter];
        [self addChild:[self createTrackOutlineNode:pathSegments.combinedPath withTransform:centerTranslateTransform]];
        [self addCrossbars:pathSegments.crossbars];
        
        Train *train = [self createTrainNodeWithPath:letter.path];
        [self addChild:(SKNode *)train];
        
        [self addWaypoints:train.waypoints];

#if (APP_SHOULD_DRAW_DOTS)
        PathDots *dots = [[PathDots alloc] init];
        [dots drawDotsAtCenter:center OfPath:letterPath.letterPath inScene:self];
#endif
        
#if (APP_SHOULD_ALLOW_CREATING_WAYPOINTS)
        wpDropper = [[WaypointDropper alloc] initForLetter:[self stringFromSceneUnicharLetter]];
#endif
    }
    return self;
}

- (SKSpriteNode *)createBackground {
    SKTexture *texture = [SKTexture textureWithImageNamed:RockyBackgroundName];
    SKSpriteNode *rockyBackground = [SKSpriteNode spriteNodeWithTexture:texture size:self.size];
    rockyBackground.name = RockyBackgroundName;
    rockyBackground.anchorPoint = CGPointZero;
    return rockyBackground;
}

- (void)addNavigationButtons {
    if (![[self stringFromSceneUnicharLetter] isEqual:@"Z"]) {
        nextButton = [self createNextButton];
        [self addChild:nextButton];
    }
    
    if (![[self stringFromSceneUnicharLetter] isEqual:@"A"]) {
        previousButton = [self createPreviousButton];
        [self addChild:previousButton];
    }
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

- (SKShapeNode *)createLetterPathNode:(AttributedStringPath *)attrStringPath {
    SKShapeNode *letterPathNode = [SKShapeNode shapeNodeWithPath:attrStringPath.letterPath];
    letterPathNode.name = LetterNodeName;
    letterPathNode.lineWidth = LetterLineWidth;
    letterPathNode.strokeColor = [SKColor darkGrayColor];
    return letterPathNode;
}

- (SKShapeNode *)createTrackOutlineNode:(CGPathRef)combinedPath withTransform:(CGAffineTransform)transform {
    SKShapeNode *segmentNode = [SKShapeNode shapeNodeWithPath:CGPathCreateCopyByStrokingPath(combinedPath, &transform, 1.0, kCGLineCapRound, kCGLineJoinRound, 1.0)];
    segmentNode.name = LetterNodeName;
    segmentNode.strokeColor = [SKColor lightGrayColor];
    segmentNode.lineWidth = 20.0;
    return segmentNode;
}

- (SKShapeNode *)createTrackPathNode:(CGPathRef)combinedPath withTransform:(CGAffineTransform)transform {
    SKShapeNode *outlineNode = [SKShapeNode shapeNodeWithPath:CGPathCreateCopyByStrokingPath(combinedPath, &transform, 25.0, kCGLineCapRound, kCGLineJoinRound, 1.0)];
    outlineNode.name = LetterOutlineName;
    outlineNode.lineWidth = 10.0;
    outlineNode.strokeColor = [SKColor darkGrayColor];
    return outlineNode;
}

- (void)addCrossbars:(NSArray *)crossbars {
    for (NSUInteger i = 0; i < crossbars.count; i++) {
        [self addChild:(SKShapeNode *)[crossbars objectAtIndex:i]];
    }
}

- (void)addWaypoints:(NSArray *)waypoints {
    for (NSInteger i = 0; i < waypoints.count; i++) {
        [self addEnvelopeAtPoint:[[waypoints objectAtIndex:i] CGPointValue]];
    }
}

- (void)addEnvelopeAtPoint:(CGPoint)position {
    SKSpriteNode *envelope = [[SKSpriteNode alloc] initWithImageNamed:EnvelopeName];
    envelope.position = position;
    [self addChild:envelope];
}

- (Train *)createTrainNodeWithPath:(CGPathRef)path {
    Train *trainNode = [[Train alloc] initWithPath:path];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self.parent];
    
#if (APP_SHOULD_ALLOW_CREATING_WAYPOINTS)
    [wpDropper placeWaypointForTouches:touches inScene:self];
#endif
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
#if (APP_SHOULD_ALLOW_CREATING_WAYPOINTS)
    [wpDropper moveWaypointForTouches:touches inScene:self];
#endif
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self.parent];
    
    DDLogInfo(@"Touches ended at point : %@ for class : <%@> with name : \'%@\'",
              NSStringFromCGPoint(touchPoint),
              NSStringFromClass([self class]),
              [self name]
              );
    
#if (APP_SHOULD_ALLOW_CREATING_WAYPOINTS)
    [wpDropper addWaypointToArray:touchPoint inScene:self];
    [wpDropper createWaypointPropertyList];
    [wpDropper displayWaypointFileContent];
#endif
    
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

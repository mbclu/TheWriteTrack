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

- (instancetype)initWithSize:(CGSize)size andLetter:(NSString *)letter {
    if (self = [super initWithSize:size]) {
        
        if (_pathSegments == nil) {
            _pathSegments = [[PathSegments alloc] init];
        }
        
        _letter = [letter characterAtIndex:0];
        
        [self setScaleMode:SKSceneScaleModeAspectFill];

        [self setName:[self stringFromSceneUnicharLetter]];
        
        [self addChild:[self createBackground]];
        
        SKShapeNode *trackOutline = [self createTrackOutlineNode:[_pathSegments generateCombinedPathForLetter:self.name]];
        [self addChild:trackOutline];

        [self addCrossbarsAndWaypoints];
        
        [self addChild:[self createTrainNodeWithPathSegments:_pathSegments]];

        [self addNavigationButtons];
        [self connectSceneTransitions];
        
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

- (instancetype)initWithSize:(CGSize)size letter:(NSString *)letter andPathSegments:(PathSegments *)pathSegments {
    _pathSegments = pathSegments;
    self = [self initWithSize:size andLetter:letter];
    return self;
}

- (SKSpriteNode *)createBackground {
    SKTexture *texture = [SKTexture textureWithImageNamed:RockyBackgroundName];
    SKSpriteNode *rockyBackground = [SKSpriteNode spriteNodeWithTexture:texture size:self.size];
    rockyBackground.name = RockyBackgroundName;
    rockyBackground.anchorPoint = CGPointZero;
    rockyBackground.zPosition = LetterBaseSceneBackgroundZPosition;
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
    button.zPosition = LetterBaseSceneNextButtonZPosition;
    return button;
}

- (GenericSpriteButton *)createPreviousButton {
    GenericSpriteButton *button = [[GenericSpriteButton alloc] initWithImageNamed:PreviousButtonName];
    button.name = PreviousButtonName;
    button.anchorPoint = CGPointZero;
    button.position = CGPointMake(self.frame.origin.x + NextButtonXPadding,
                                  (self.size.height - button.size.height) * 0.5);
    button.zPosition = LetterBaseScenePreviousButtonZPosition;
    return button;
}

- (SKShapeNode *)createTrackOutlineNode:(CGPathRef)combinedPath {
    SKShapeNode *outlineNode = [SKShapeNode shapeNodeWithPath:
                                CGPathCreateCopyByStrokingPath(combinedPath,
                                                               nil,
                                                               25.0,
                                                               kCGLineCapButt,
                                                               kCGLineJoinBevel,
                                                               1.0)
                                ];
    
    outlineNode.name = LetterOutlineName;
    outlineNode.lineWidth = 7.0;
    outlineNode.strokeColor = [SKColor darkGrayColor];
    outlineNode.position = [self getCenterForShapeNode:outlineNode];
    outlineNode.zPosition = LetterBaseSceneTrackOutlineZPosition;
    
    return outlineNode;
}

- (void)addCrossbarsAndWaypoints {
    CGPoint centeringShiftPoint = [_pathSegments pathOffsetFromZero];
    INCREMENT_POINT_BY_POINT(centeringShiftPoint, [self childNodeWithName:LetterOutlineName].position);
    
    [_pathSegments setCenterShift:centeringShiftPoint];
    [_pathSegments generateObjectsWithType:CrossbarObjectType forLetter:self.name];
    [_pathSegments generateObjectsWithType:WaypointObjectType forLetter:self.name];
    
    [self createSpritesForCrossbars:_pathSegments.crossbars withTransform:_pathSegments.translateToZeroTransform];
    [self createSpritesForWaypoints:_pathSegments.waypoints withOffset:_pathSegments.pathOffsetFromZero];
}

- (void)createSpritesForCrossbars:(NSArray *)crossbars withTransform:(CGAffineTransform)translateToZero {
    for (NSUInteger i = 0; i < crossbars.count; i++) {
        [self addCrossbarWithPath:CGPathCreateCopyByTransformingPath((__bridge CGPathRef)[crossbars objectAtIndex:i], &translateToZero)];
    }
}

- (void)addCrossbarWithPath:(CGPathRef)crossbarPath {
    CGAffineTransform transform = CGAffineTransformMakeTranslation([self childNodeWithName:LetterOutlineName].position.x,
                                                                   [self childNodeWithName:LetterOutlineName].position.y);
    
    SKShapeNode *crossbarNode = [SKShapeNode shapeNodeWithPath:CGPathCreateCopyByTransformingPath(crossbarPath, &transform)];
    crossbarNode.lineWidth = 8.0;
    crossbarNode.strokeColor = [SKColor brownColor];
    crossbarNode.name = @"Crossbar";
    crossbarNode.zPosition = LetterBaseSceneCrossbarZPosition;

    [self addChild:crossbarNode];
}

- (void)createSpritesForWaypoints:(NSArray *)waypoints withOffset:(CGPoint)offsetFromZero {
    for (NSInteger i = 0; i < waypoints.count; i++) {
        CGPoint envelopePosition = [[waypoints objectAtIndex:i] CGPointValue];
        envelopePosition.x -= offsetFromZero.x;
        envelopePosition.y -= offsetFromZero.y;
        [self addEnvelopeAtPoint:envelopePosition];
    }
}

- (void)addEnvelopeAtPoint:(CGPoint)position {
    SKSpriteNode *envelope = [[SKSpriteNode alloc] initWithImageNamed:EnvelopeName];
    position.x += [self childNodeWithName:LetterOutlineName].position.x;
    position.y += [self childNodeWithName:LetterOutlineName].position.y;
    envelope.position = position;
    envelope.name = @"Waypoint";
    envelope.zPosition = LetterBaseSceneWaypointZPosition;
    [self addChild:envelope];
}

- (Train *)createTrainNodeWithPathSegments:(PathSegments *)segments {
    Train *trainNode = [[Train alloc] initWithPathSegments:segments andCenterOffset:[self childNodeWithName:LetterOutlineName].position];
    trainNode.name = TrainNodeName;
    trainNode.zPosition = LetterBaseSceneTrainZPosition;
    return trainNode;
}

- (CGPoint)getCenterForShapeNode:(SKShapeNode *)node {
    CGPoint center = [LayoutMath centerOfMainScreen];
    CGRect pathBoundingBox = CGPathGetPathBoundingBox(node.path);
    center.x -= HALF_OF(pathBoundingBox.size.width) + pathBoundingBox.origin.x;
    center.y -= HALF_OF(pathBoundingBox.size.height) + pathBoundingBox.origin.y;
    return center;
}

- (void)transitionToSceneWithLetter:(NSString *)letter {
    DDLogInfo(@"Transitioning to the %@ scene", letter);
    
    SKScene *nextScene = [[LetterBaseScene alloc] initWithSize:self.size andLetter:letter];
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

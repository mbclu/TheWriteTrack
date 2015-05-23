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
#import "Train.h"

#ifdef DEBUG
    #define APP_SHOULD_DRAW_DOTS                0
    #define APP_SHOULD_ALLOW_CREATING_WAYPOINTS 0
    #define APP_SHOULD_LOG_LINE_TYPES           1
#endif

#if (APP_SHOULD_DRAW_DOTS || APP_SHOULD_LOG_LINE_TYPES)
    #import "PathInfo.h"
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
        
        if (![letter isEqual:@"Z"]) {
            nextButton = [self createNextButton];
            [self addChild:nextButton];
        }
        
        if (![letter isEqual:@"A"]) {
            previousButton = [self createPreviousButton];
            [self addChild:previousButton];
        }
        
        AttributedStringPath *letterPath = [[AttributedStringPath alloc] initWithString:[self stringFromSceneUnicharLetter]];
        [self addChild:[self createLetterPathNode:letterPath]];
        [self addChild:[self createTrainNode:letterPath]];
        
        [self connectSceneTransitions];
        
#if (APP_SHOULD_ALLOW_CREATING_WAYPOINTS)
        currentEnvelopeIndex = 0;
        waypointArray = [[NSMutableArray alloc] init];
#endif
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

- (SKShapeNode *)createLetterPathNode:(AttributedStringPath *)attrStringPath {
    SKShapeNode *letterPathNode = [SKShapeNode shapeNodeWithPath:attrStringPath.letterPath];
    letterPathNode.name = LetterNodeName;
    letterPathNode.lineWidth = LetterLineWidth;
    letterPathNode.strokeColor = [SKColor darkGrayColor];
//    letterPathNode.fillColor = [SKColor orangeColor];
//    letterPathNode.fillTexture = [SKTexture textureWithImageNamed:TrackTextureName];
    CGPoint center = [self moveNodeToCenter:letterPathNode];
#if (APP_SHOULD_DRAW_DOTS)
    [self drawDotsAtCenter:center OfPath:attrStringPath.letterPath];
    [self drawWaypointsAtCenter:center OfPath:attrStringPath.letterPath];
#endif
#if (APP_SHOULD_LOG_LINE_TYPES)
    PathInfo *pathInfo = [[PathInfo alloc] init];
    NSMutableArray *array = [pathInfo TransformPathToElementTypes:attrStringPath.letterPath];
    DDLogInfo(@"Letter : %@", [self stringFromSceneUnicharLetter]);
    for (NSUInteger i = 0; i < array.count; i++) {
        DDLogInfo(@"Element Type : %@\n", [array objectAtIndex:i]);
    }
#endif
    return letterPathNode;
}

- (SKNode *)createTrainNode:(AttributedStringPath *)attrStringPath {
    Train *trainNode = [[Train alloc] initWithAttributedStringPath:attrStringPath];
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

#if (APP_SHOULD_DRAW_DOTS)
- (void)drawDotsAtCenter:(CGPoint)center OfPath:(CGPathRef)path {
    PathInfo *pathInfo = [[PathInfo alloc] init];
    NSArray *array = [pathInfo TransformPathToArray:path];
    for (NSUInteger i = 0; i < array.count; ++i) {
        if (i < array.count) {
            SKShapeNode *node = [SKShapeNode shapeNodeWithCircleOfRadius:5];
            node.fillColor = [SKColor redColor];
            NSValue *pointValue = (NSValue *)[array objectAtIndex:i];
            CGPoint point = [pointValue CGPointValue];
            point.x += center.x;
            point.y += center.y;
            node.position = point;
            node.zPosition = 5;
            SKLabelNode *label = [[SKLabelNode alloc] init];
            label.text = [NSString stringWithFormat:@"%lu <%0.1f, %0.1f>",
                          (unsigned long)i,
                          point.x,
                          point.y];
            label.fontColor = [SKColor redColor];
            label.fontSize = 15;
            [node addChild:label];
            [self addChild:node];
        }
    }
    DDLogDebug(@"%@", NSStringFromCGPoint(center));
}

- (void)drawWaypointsAtCenter:(CGPoint)center OfPath:(CGPathRef)path {
    
}
#endif

#if (APP_SHOULD_ALLOW_CREATING_WAYPOINTS)
- (void)addEnvelopeAtPoint:(CGPoint)touchPoint {
    if (CGRectContainsPoint([self childNodeWithName:LetterNodeName].frame, touchPoint)) {
        currentEnvelopeIndex++;
        SKSpriteNode *node = [[SKSpriteNode alloc] initWithImageNamed:@"Envelope"];
        node.name = [NSString stringWithFormat:@"%lui" , (unsigned long)currentEnvelopeIndex];
        node.position = touchPoint;
        [self addChild:node];
    }
}

- (void)moveLastPlacedEnvelopeToPoint:(CGPoint)touchPoint {
    if (CGRectContainsPoint([self childNodeWithName:LetterNodeName].frame, touchPoint)) {
        SKSpriteNode *node = (SKSpriteNode *)[self childNodeWithName:[NSString stringWithFormat:@"%lui" , (unsigned long)currentEnvelopeIndex]];
        node.position = touchPoint;
    }
}

- (NSString *)getWaypointFileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@_waypoints.plist",
                          libDirectory,
                          [self stringFromSceneUnicharLetter]];
    return fileName;
}

/***********************************************************************************************
 * Here is a fun fact:
 * ~/Library/Developer/CoreSimulator/Devices/2D048742-A844-4620-AD5B-C832A0A1A658/data/...
 * ./Containers/Data/Application/1E1A5B19-33C3-4FDA-85B2-8C65A41B690A/Library/
 * YEAH! That is the file directory that get's written from this call....... Phwew!
 * The first UUID matches the simulator device which I confirmed with ```xcrun simctl list```
 * The second must be the Application itself, but I haven't confirmed
 **********************************************************************************************/
- (void)createWaypointPropertyList {
    [waypointArray writeToFile:[self getWaypointFileName] atomically:NO];
}

- (void)addWaypointToArray:(CGPoint)waypoint {
    if (CGRectContainsPoint([self childNodeWithName:LetterNodeName].frame, waypoint)) {
        [waypointArray addObject:NSStringFromCGPoint(waypoint)];
    }
}

- (void)displayWaypointFileContent {
    NSString *content = [[NSString alloc] initWithContentsOfFile:[self getWaypointFileName]
                                                    usedEncoding:nil
                                                           error:nil];
    DDLogDebug(@"Contents of waypoint file:\n%@", content);
}
#endif

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self];
#if (APP_SHOULD_ALLOW_CREATING_WAYPOINTS)
    [self addEnvelopeAtPoint:touchPoint];
#endif
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self];
    
#if (APP_SHOULD_ALLOW_CREATING_WAYPOINTS)
    [self moveLastPlacedEnvelopeToPoint:touchPoint];
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
    [self addWaypointToArray:touchPoint];
    [self createWaypointPropertyList];
    [self displayWaypointFileContent];
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

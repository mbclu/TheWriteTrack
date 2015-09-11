//
//  LetterScene.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 2/11/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LetterScene.h"

#import "AttributedStringPath.h"
#import "GenericSpriteButton.h"
#import "LayoutMath.h"
#import "LetterSelectScene.h"
#import "Constants.h"
#import "Colors.h"
#import "Train.h"
#import "TitleScene.h"
#import "AccessibilityHelper.h"
#import "CocoaLumberjack.h"

static DDLogLevel ddLogLevel = DDLogLevelAll;

static int const LETTER_SCENE_MARGIN_DEFAULT = 20;
static NSTimeInterval const FADE_DURATION_IN_SECONDS = 0.5;

@implementation LetterScene

@synthesize nextButtonProperty = nextButton;
@synthesize previousButtonProperty = previousButton;
@synthesize letterSelectButtonProperty = letterSelectButton;
@synthesize skipDemoButtonProperty = skipDemoButton;

- (instancetype)initWithSize:(CGSize)size andLetter:(NSString *)letter {
    if (self = [super initWithSize:size]) {
        
        _letter = [letter characterAtIndex:0];
        
        self.name = letter;
        self.scaleMode = SKSceneScaleModeAspectFill;

        [self setName:[self stringFromSceneUnicharLetter]];
        
        [self addChild:[self createBackground]];
        
        [self setupTrackContainerAndPhysics];

        [self addNavigationButtons];

        [self addSkipDemoButton];
    }
    return self;
}

- (void)setupTrackContainerAndPhysics {
    TrackContainer *trackContainer = [self createLetterTrack];
    [self addChild:trackContainer];
    self.physicsWorld.contactDelegate = trackContainer;
    self.physicsWorld.gravity = CGVectorMake(0, 0);
}

- (void)didMoveToView:(SKView *)view {
    [AccessibilityHelper setAccessibilityName:self.name forView:view];
    [((TrackContainer *)[self childNodeWithName:LetterSceneTrackContainerNodeName]) beginDemonstration];
}

- (SKSpriteNode *)createBackground {
    SKTexture *texture = [SKTexture textureWithImageNamed:RockyBackgroundName];
    SKSpriteNode *rockyBackground = [SKSpriteNode spriteNodeWithTexture:texture size:self.size];
    rockyBackground.name = RockyBackgroundName;
    rockyBackground.anchorPoint = CGPointZero;
    rockyBackground.zPosition = LetterSceneBackgroundZPosition;
    return rockyBackground;
}

- (TrackContainer *)createLetterTrack {
    TrackContainer *trackContainer = [[TrackContainer alloc] initWithLetterKey:self.name andPathSegments:nil];
    trackContainer.zPosition = LetterSceneTrackContainerZPosition;
    trackContainer.name = LetterSceneTrackContainerNodeName;
    return trackContainer;
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
    
    letterSelectButton = [self createLetterSelectButton];
    [self addChild:letterSelectButton];
    
    [self connectSceneTransitions];
}

- (void)addSkipDemoButton {
    skipDemoButton = [self createSkipDemoButton];
    [self addChild:skipDemoButton];

    [self connectSkipDemoAction];
}

- (GenericSpriteButton *)createNextButton {
    GenericSpriteButton *button = [self createButtonWithImage:NEXT_BUTTON_NAME];
    button.position = CGPointMake(self.size.width - button.size.width - NextButtonXPadding, HALF_OF((self.size.height - button.size.height)));
    return button;
}

- (GenericSpriteButton *)createPreviousButton {
    GenericSpriteButton *button = [self createButtonWithImage:PREVIOUS_BUTTON_NAME];
    button.position = CGPointMake(self.frame.origin.x + NextButtonXPadding, HALF_OF((self.size.height - button.size.height)));
    return button;
}

- (GenericSpriteButton *)createSkipDemoButton {
    GenericSpriteButton *button = [self createButtonWithImage:SKIP_DEMO_BUTTON_NAME];
    button.position = CGPointMake(LETTER_SCENE_MARGIN_DEFAULT, self.size.height - button.size.height - LETTER_SCENE_MARGIN_DEFAULT);
    return button;
}

- (GenericSpriteButton *)createButtonWithImage:(NSString *)name {
    GenericSpriteButton *button = [GenericSpriteButton buttonWithImageNamed:name];
    button.zPosition = LetterSceneButtonZPosition;
    return button;
}

- (LetterSelectButton *)createLetterSelectButton {
    LetterSelectButton *button = [[LetterSelectButton alloc] init];
    button.name = LETTER_SELECT_BUTTON_NAME;
    
    CGPoint position = self.position;
    INCREMENT_POINT_BY_POINT(position, CGPointMake(LETTER_SCENE_MARGIN_DEFAULT, LETTER_SCENE_MARGIN_DEFAULT));
    button.position = position;
    
    button.zPosition = LetterSceneButtonZPosition;
    
    button.isAccessibilityElement = YES;
    button.accessibilityLabel = LETTER_SELECT_BUTTON_NAME;
    
    return button;
}

- (SKTransition *)getSceneTransition:(NSString *)letter {
    SKTransition *transition = [SKTransition pushWithDirection:SKTransitionDirectionLeft duration:TransitionLengthInSeconds];;
    if ([letter characterAtIndex:0] < [self.name characterAtIndex:0]) {
        transition = [SKTransition pushWithDirection:SKTransitionDirectionRight duration:TransitionLengthInSeconds];
    }
    return transition;
}

- (void)transitionToNextScene {
    [self transitionToSceneWithLetter:[self nextLetterString]];
}

- (void)transitionToPreviousScene {
    [self transitionToSceneWithLetter:[self previousLetterString]];
}

- (void)transitionToSceneWithLetter:(NSString *)letter {
    DDLogInfo(@"Transitioning to the %@ scene", letter);
    
    SKScene *nextScene = [[LetterScene alloc] initWithSize:self.size andLetter:letter];
    
    [self.view presentScene:nextScene transition:[self getSceneTransition:letter]];
    [self.view setIsAccessibilityElement:YES];
    [self.view setAccessibilityIdentifier:nextScene.name];
}

- (void)transitionToLetterSelectScene {
    DDLogInfo(@"Transitioning to the Letter Selection scene");
    
    SKScene *letterSelectionScene = [[LetterSelectScene alloc] init];
    [self transitionToScene:letterSelectionScene];
}

- (void)transitionToScene:(SKScene *)scene {
    [self.view presentScene:scene transition:
     [SKTransition fadeWithColor:DARK_GREY_COLOR_SCENE_TRANSITION duration:FADE_DURATION_IN_SECONDS]];
}

- (void)connectSceneTransitions {
    [nextButton setTouchUpInsideTarget:self action:@selector(transitionToNextScene)];
    [previousButton setTouchUpInsideTarget:self action:@selector(transitionToPreviousScene)];
    [letterSelectButton setTouchUpInsideTarget:self action:@selector(transitionToLetterSelectScene)];
}

- (void) connectSkipDemoAction {
    [skipDemoButton setTouchUpInsideTarget:self action:@selector(skipDemo)];
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
    [self.letterSelectButtonProperty touchesEnded:touches withEvent:event];
    [self.skipDemoButtonProperty touchesEnded:touches withEvent:event];
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

- (void)skipDemo {
    [(TrackContainer *)[self childNodeWithName:LetterSceneTrackContainerNodeName] skipDemo];
}

@end

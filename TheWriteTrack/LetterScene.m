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
#import "Train.h"
#import "TitleScene.h"
#import "AccessibilityHelper.h"
#import "CocoaLumberjack.h"

static DDLogLevel ddLogLevel = DDLogLevelAll;

@implementation LetterScene

@synthesize nextButtonProperty = nextButton;
@synthesize previousButtonProperty = previousButton;
@synthesize letterSelectButtonProperty = letterSelectButton;

- (instancetype)initWithSize:(CGSize)size andLetter:(NSString *)letter {
    if (self = [super initWithSize:size]) {
        
        _letter = [letter characterAtIndex:0];
        
        self.name = letter;
        self.scaleMode = SKSceneScaleModeAspectFill;

        [self setName:[self stringFromSceneUnicharLetter]];
        
        [self addChild:[self createBackground]];
        
        [self setupTrackContainerAndPhysics];

        [self addNavigationButtons];
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
    
    LetterSelectButton *lsButton = [self createLetterSelectButton];
    [self addChild:lsButton];
    letterSelectButton = [self createOverlayForButton:lsButton];
    [self addChild:letterSelectButton];
    
    [self connectSceneTransitions];
}

- (GenericSpriteButton *)createNextButton {
    GenericSpriteButton *button = [[GenericSpriteButton alloc] initWithImageNamed:NextButtonName];
    button.name = NextButtonName;
    button.anchorPoint = CGPointZero;
    button.position = CGPointMake(self.size.width - button.size.width - NextButtonXPadding,
                                  HALF_OF((self.size.height - button.size.height)));
    button.zPosition = LetterSceneButtonZPosition;

    button.isAccessibilityElement = YES;
    button.accessibilityLabel = @"Next Button";
    
    return button;
}

- (GenericSpriteButton *)createPreviousButton {
    GenericSpriteButton *button = [[GenericSpriteButton alloc] initWithImageNamed:PreviousButtonName];
    button.name = PreviousButtonName;
    button.anchorPoint = CGPointZero;
    button.position = CGPointMake(self.frame.origin.x + NextButtonXPadding,
                                  HALF_OF((self.size.height - button.size.height)));
    button.zPosition = LetterSceneButtonZPosition;
    return button;
}

- (LetterSelectButton *)createLetterSelectButton {
    LetterSelectButton *button = [[LetterSelectButton alloc] init];
    button.name = LetterSelectButtonName;
    CGPoint position = self.position;
    INCREMENT_POINT_BY_POINT(position, CGPointMake(20, 20));
    button.position = position;
    button.zPosition = LetterSceneButtonZPosition - 1;
    return button;
}

- (GenericSpriteButton *)createOverlayForButton:(LetterSelectButton *)lsButton {
    GenericSpriteButton *button = [[GenericSpriteButton alloc] init];
    
    button.size = CGSizeMake([[lsButton childNodeWithName:ANodeName] frame].origin.x +
                             [[lsButton childNodeWithName:CNodeName] frame].origin.x +
                             [[lsButton childNodeWithName:CNodeName] frame].size.width,
                             [[lsButton childNodeWithName:ANodeName] frame].origin.y +
                             [[lsButton childNodeWithName:BNodeName] frame].origin.y +
                             [[lsButton childNodeWithName:BNodeName] frame].size.height);

    button.name = LetterSelectButtonName;
    CGPoint position = self.position;
    INCREMENT_POINT_BY_POINT(position, CGPointMake(20, 20));
    button.position = position;
    button.zPosition = LetterSceneButtonZPosition;
    button.color = [SKColor clearColor];
    return button;
}

- (SKTransition *)getSceneTransition:(NSString *)letter {
    SKTransition *transition = [SKTransition pushWithDirection:SKTransitionDirectionLeft duration:TransitionLengthInSeconds];;
    if ([letter characterAtIndex:0] < [self.name characterAtIndex:0]) {
        transition = [SKTransition pushWithDirection:SKTransitionDirectionRight duration:TransitionLengthInSeconds];
    }
    return transition;
}

- (void)transitionToSceneWithLetter:(NSString *)letter {
    DDLogInfo(@"Transitioning to the %@ scene", letter);
    
    SKScene *nextScene = [[LetterScene alloc] initWithSize:self.size andLetter:letter];
    
    [self.view presentScene:nextScene transition:[self getSceneTransition:letter]];
    [self.view setIsAccessibilityElement:YES];
    [self.view setAccessibilityIdentifier:nextScene.name];
}

- (void)transitionToNextScene {
    [self transitionToSceneWithLetter:[self nextLetterString]];
}

- (void)transitionToPreviousScene {
    [self transitionToSceneWithLetter:[self previousLetterString]];
}

- (void)transitionToLetterSelectScene {
    DDLogInfo(@"Transitioning to the Letter Selection scene");
    
    SKScene *letterSelectionScene = [[LetterSelectScene alloc] init];
    [self transitionToScene:letterSelectionScene];
}

- (void)transitionToScene:(SKScene *)scene {
    UIColor *const FadeColorDarkGray = [UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:0.9];
    NSTimeInterval const FadeDurationHalfSecond = 0.50;
    [self.view presentScene:scene transition:[SKTransition fadeWithColor:FadeColorDarkGray duration:FadeDurationHalfSecond]];
}

- (void)connectSceneTransitions {
    [nextButton setTouchUpInsideTarget:self action:@selector(transitionToNextScene)];
    [previousButton setTouchUpInsideTarget:self action:@selector(transitionToPreviousScene)];
    [letterSelectButton setTouchUpInsideTarget:self action:@selector(transitionToLetterSelectScene)];
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

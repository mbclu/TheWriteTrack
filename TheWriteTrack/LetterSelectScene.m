//
//  LetterSelectScene.m
//  OnTheWriteTrack
//
//  Created by Mitch Clutter on 6/20/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "LetterSelectScene.h"
#import "LayoutMath.h"
#import "LetterSelectButton.h"
#import "ChosenLetterButton.h"
#import "Constants.h"
#import "LetterScene.h"

#import "CocoaLumberjack.h"

@implementation LetterSelectScene {
    UIColor *backgroundColor;
    UIColor *skyColor;
    UIColor *sunColor;
    UIColor *sunStrokeColor;
    UIColor *mountainsColor;
    UIColor *backgroundMountainsColor;
    UIColor *grassColor;
}

- (instancetype)init {
    self = [super initWithSize:[UIScreen mainScreen].bounds.size];
    self.scaleMode = SKSceneScaleModeAspectFill;
    self.blendMode = SKBlendModeAlpha;
    
    backgroundColor = [UIColor colorWithRed:0.46 green:0.61 blue:0.89 alpha:1.0];
    skyColor = [UIColor colorWithRed:0.40 green:0.70 blue:0.97 alpha:1.0];
    sunColor = [UIColor colorWithRed:1.00 green:1.00 blue:0.52 alpha:0.80];
    sunStrokeColor = [UIColor colorWithRed:1.00 green:0.95 blue:0.62 alpha:0.30];
//    mountainsColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.99 alpha:1.0];
    mountainsColor = [UIColor colorWithRed:0.46 green:0.65 blue:0.69 alpha:1.0];
    backgroundMountainsColor = [UIColor colorWithRed:0.85 green:0.80 blue:0.96 alpha:1.0];
    grassColor = [UIColor colorWithRed:0.73 green:0.93 blue:0.65 alpha:1.0];
    
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [self sky];
    [self sun];
    [self mountains];
    [self grass];
    [self letters];
}

- (void)sky {
    self.backgroundColor = skyColor;
}

- (void)sun {
    SKShapeNode *sunNode = [SKShapeNode shapeNodeWithCircleOfRadius:self.size.width * 0.11];
    sunNode.name = @"sun";
    sunNode.position = CGPointMake(self.size.width * 0.05, self.size.height * 0.95);
    sunNode.fillColor = sunColor;
    sunNode.fillTexture = [SKTexture textureWithImage:[UIImage imageNamed:@"airbrushSun"]];
    sunNode.blendMode = SKBlendModeAlpha;
    
    sunNode.strokeColor = sunStrokeColor;
    sunNode.lineWidth = 15.0;
    [self addChild:sunNode];
}

- (void)mountains {
    CGPathRef backgroundMountainsPath = [self createMountainsPathWithVectorCount:60.0 andMaxHeightChange:0.700];
    CGPathRef mountainsPath = [self createMountainsPathWithVectorCount:60.0 andMaxHeightChange:0.600];

    SKShapeNode *backgroundMountainsNode = [SKShapeNode shapeNodeWithPath:backgroundMountainsPath];
    backgroundMountainsNode.name = @"backgroundMountains";
    backgroundMountainsNode.lineWidth = 0.0;
    backgroundMountainsNode.fillColor = backgroundMountainsColor;
    backgroundMountainsNode.yScale = 0.7;
    backgroundMountainsNode.position = CGPointMake(0.0, self.size.height * 0.05);
    [self addChild:backgroundMountainsNode];
    
    SKShapeNode *mountainsNode = [SKShapeNode shapeNodeWithPath:mountainsPath];
    mountainsNode.name = @"mountains";
    mountainsNode.lineWidth = 0.0;
    mountainsNode.fillColor = mountainsColor;
    [self addChild:mountainsNode];
    
    CGPathRelease(backgroundMountainsPath);
    CGPathRelease(mountainsPath);
}

- (void)grass {
    SKShapeNode *grassNode = [SKShapeNode shapeNodeWithRect:CGRectMake(0, 0, self.size.width, self.size.height * 0.20)];
    grassNode.name = @"grass";
    grassNode.lineWidth = 0.0;
    grassNode.fillColor = grassColor;
    [self addChild:grassNode];
}

- (CGPathRef)createMountainsPathWithVectorCount:(double)vectorCount andMaxHeightChange:(double)maxHeightChange {
    CGMutablePathRef mountainsPath = CGPathCreateMutable();
    CGPathMoveToPoint(mountainsPath, nil, 0.0, self.size.height * MinMountainHeightChangePercentage);
    
    double heightPercentage = MinMountainHeightChangePercentage;
    double widthPercentage = 0.0;
    
    double numberOfMountainVectors = vectorCount;
    for (NSUInteger i = 1; i < numberOfMountainVectors + 1; i++) {
        heightPercentage = [self calculateHeightChangePercent:heightPercentage :maxHeightChange];
        widthPercentage += (1.0 / numberOfMountainVectors);
        CGPathAddLineToPoint(mountainsPath, nil, self.size.width * widthPercentage, (self.size.height * heightPercentage));
    }
    
    CGPathAddLineToPoint(mountainsPath, nil, self.size.width, (self.size.height * heightPercentage));
    CGPathAddLineToPoint(mountainsPath, nil, self.size.width, (self.size.height * 0.20));
    CGPathAddLineToPoint(mountainsPath, nil, 0.0, (self.size.height * 0.20));
    CGPathAddLineToPoint(mountainsPath, nil, 0.0, self.size.height * MinMountainHeightChangePercentage);
    
    return (CGPathRef)mountainsPath;
}

- (double)calculateHeightChangePercent:(double)percentage :(double)max {
    static double percentageChangeDirection = +1.0;
    double percentageChange = ((double)arc4random_uniform(10) / 200.0);

    percentage += (percentageChange * percentageChangeDirection);
    
    if (percentage < MinMountainHeightChangePercentage) {
        percentage = MinMountainHeightChangePercentage;
        percentageChangeDirection = +1.0;
    } else if (percentage > max) {
        percentage = max;
        percentageChangeDirection = -1.0;
    }
    
    return percentage;
}

- (void)letters {
    CGPoint buttonPosition = CGPointMake(15, self.size.height * 0.08);
    for (unichar letter = 'A'; letter <= 'Z'; letter++) {
        ChosenLetterButton *letterButton = [[ChosenLetterButton alloc] initWithLetter:letter];
        letterButton.position = buttonPosition;
        [self addChild:letterButton];
        
        INCREMENT_POINT_BY_POINT(buttonPosition, CGPointMake(LetterSelectButtonFontSize * 0.90, 0));
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self];
    
    DDLogInfo(@"Touches ended at point : %@ on the Letter Select Scene",
              NSStringFromCGPoint(touchPoint));
    
    [self evaluateTouchAtPoint:touchPoint];
}

- (void)evaluateTouchAtPoint:(CGPoint)touchPoint {
    for (SKNode* child in self.children) {
        if ([child containsPoint:touchPoint] && [child.name containsString:ChosenLetterOverlay]) {
            DDLogDebug(@"Child with name %@ and AccessibilityValue %@ Touched on the LetterSelectScene",
                       child.name, child.accessibilityValue);
            [self transitionToLetterScene:child.accessibilityValue];
        }
    }
}

- (void)transitionToLetterScene:(NSString *)letter {
    DDLogInfo(@"Transitioning to the Letter <%@> scene", letter);
    
    SKScene *letterScene = [[LetterScene alloc] initWithSize:[UIScreen mainScreen].bounds.size andLetter:letter];
    
    [self.view presentScene:letterScene transition:[SKTransition fadeWithDuration:1.0]];
    [self.view setIsAccessibilityElement:YES];
    [self.view setAccessibilityIdentifier:letterScene.name];
}

@end

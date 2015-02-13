//
//  GameScene.m
//  The Write Track
//
//  Created by Mitch Clutter on 2/7/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    GameScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    [self setHelloWorldLabel:[SKLabelNode labelNodeWithFontNamed:@"Chalkduster"]];
    
    [self helloWorldLabel].text = @"Hello, World!";
    [self helloWorldLabel].fontSize = 65;
    [self helloWorldLabel].position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    [self helloWorldLabel].name = @"helloWorldLabel";
    
    [self addChild:[self helloWorldLabel]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.xScale = 0.5;
        sprite.yScale = 0.5;
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end

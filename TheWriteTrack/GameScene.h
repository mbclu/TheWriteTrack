//
//  GameScene.h
//  The Write Track
//

//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene

@property (readwrite) SKLabelNode *helloWorldLabel;

+ (instancetype)unarchiveFromFile:(NSString *)file;

@end

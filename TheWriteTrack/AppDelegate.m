//
//  AppDelegate.m
//  The Write Track
//
//  Created by Mitch Clutter on 2/7/15.
//  Copyright (c) 2015 Mitch Clutter. All rights reserved.
//

#import "AppDelegate.h"
#import "CocoaLumberjack.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (void)EnableLumberjackWithColors {
    // Override point for customization after application launch.
    // CocoaLumberjack
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    // XcodeColors
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];

    // Custom Colors
    UIColor *yellow = [UIColor colorWithRed:211.0f/255.0f green:225.0f/255.0f blue:38.0f/255.0f alpha:1.0];
    UIColor *peach = [UIColor colorWithRed:246.0f/255.0f green:178.0f/255.0f blue:107.0f/255.0f alpha:1.0];
    UIColor *violet = [UIColor colorWithRed:142.0f/255.0f green:124.0f/255.0f blue:195.0f/255.0f alpha:1.0];
    UIColor *grey = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0];
    [[DDTTYLogger sharedInstance] setForegroundColor:yellow backgroundColor:nil forFlag:DDLogFlagWarning];
    [[DDTTYLogger sharedInstance] setForegroundColor:grey backgroundColor:nil forFlag:DDLogFlagInfo];
    [[DDTTYLogger sharedInstance] setForegroundColor:violet backgroundColor:nil forFlag:DDLogFlagDebug];
    [[DDTTYLogger sharedInstance] setForegroundColor:peach backgroundColor:nil forFlag:DDLogFlagVerbose];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self EnableLumberjackWithColors];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

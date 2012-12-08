//
//  GRSHAppDelegate.m
//  Leren Rekenen
//
//  Created by Jettro Coenradie on 11/29/12.
//  Copyright (c) 2012 Jettro Coenradie. All rights reserved.
//

#import "GRSHAppDelegate.h"
#import "MainViewController.h"

@implementation GRSHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[MainViewController new]];
    self.window.rootViewController = nav;

    [self.window makeKeyAndVisible];
    return YES;
}

@end

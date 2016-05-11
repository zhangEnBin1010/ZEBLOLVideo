//
//  AppDelegate.m
//  ZEBLOLVideo
//
//  Created by qianfeng001 on 15/10/14.
//  Copyright (c) 2015年 章恩斌. All rights reserved.
//

#import "AppDelegate.h"
#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import "LeftViewController.h"
#import "UIView+Common.h"
#import "UMSocial.h"
@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    
    [UMSocialData setAppKey:@"56234f55e0f55aab0d009be2"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    LeftViewController *leftViewController = [[LeftViewController alloc] init];
    UINavigationController *navLeft = [[UINavigationController alloc] initWithRootViewController:leftViewController];
    
    self.putViewController = [[PutViewController alloc] init];
    self.putViewController.title = @"推荐";
    UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:self.putViewController];

    MMDrawerController *drawController = [[MMDrawerController alloc] initWithCenterViewController:centerNav leftDrawerViewController:navLeft];
    self.window.rootViewController = drawController;
    
    [drawController setMaximumLeftDrawerWidth:200];
    [drawController setShowsShadow:YES];
    [drawController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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

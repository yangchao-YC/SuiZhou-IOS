//
//  AppDelegate.m
//  SuiZhou
//
//  Created by 杨超 on 13-10-10.
//  Copyright (c) 2013年 杨 超. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "HomeViewController.h"
#import "UMSocial.h"
@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UMSocialData setAppKey:@"507fcab25270157b37000010"];
    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    HomeViewController *home = [[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil]autorelease];
    self.window.rootViewController = [[[UINavigationController alloc]initWithRootViewController:home]autorelease];
    [self.window makeKeyAndVisible];
    return YES;
}

+(CGRect) ip5sizeFrame:(CGRect) frm  forOpt: (int) opt
{
    if( IS_IPHONE_5)
    {
        /// int h = frm.size.height + (568-480)  ;
        CGRect frm2 = CGRectMake(frm.origin.x, frm.origin.y, frm.size.width,frm.size.height + DISTANCE  ) ;
        return frm2 ;
    }
    return frm ;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

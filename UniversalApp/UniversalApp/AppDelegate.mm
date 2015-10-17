//
//  AppDelegate.m
//  UniversalApp
//
//  Created by Think on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "HomeTabViewController.h"
#import "NetworkModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:screenBounds()];
    self.window.backgroundColor = sysWhiteColor();
    [self.window makeKeyAndVisible];
    
    [UHTTPRequest sendAsynWithURL:@"https://www.baidu.com"
                           header:nil
                           method:@"GET"
                            param:nil
                         callback:^(UHTTPStatus *status, id data)
     {
         if (status.code == UHTTPCodeLocalCached) {
             NSLog(@"From cached:\n%@", data);
         } else if (status.code == UHTTPCodeOK) {
             NSLog(@"From request:\n%@", data);
         }
    } cached:YES];
    
    // Start timer
    [UTimerBooster start];
    
    // Goto home
    [self gotoHomePage];
    
    NSDictionary *dict = @{@"name":@"cailiang", @"content_fields":@[@{@"time":@"12:00"}, @{@"time":@"00:00"}]};
    NetworkModel *model = [NetworkModel modelWithDictionary:dict];
    dict = [model dictionaryWithModelKey];
    NSString *JSONString = [dict JSONString];
    NSLog(@"%@", JSONString);
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //
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

#pragma mark - Methods

- (void)gotoHomePage
{
    HomeTabViewController *home = [[HomeTabViewController alloc]init];
    BaseNavigationController *root = [[BaseNavigationController alloc]initWithRootViewController:home];
    self.window.rootViewController = root;
}

@end

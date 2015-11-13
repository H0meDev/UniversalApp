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
    
    UHTTPRequestParam *param = [UHTTPRequestParam param];
    param.url = @"https://www.baidu.com";
    param.method = @"GET";
    param.timeout = 20;
    param.cached = YES;
    
    UHTTPOperation *operation = [UHTTPRequest sendAsynWith:(UHTTPRequestParam *)param
                                                  callback:^(UHTTPStatus *status, id data)
    {
         if (status.code == UHTTPCodeLocalCached) {
             NSLog(@"From cached:\n%@", data);
         } else if (status.code == UHTTPCodeOK) {
             NSLog(@"From request:\n%@", data);
         }
    }];
    
    [operation cancel];
    
    // Start timer
    [UTimerBooster start];
    
    // Goto home
    [self gotoHomePage];
    
    NSDate *date = [NSDate dateFromString:@"2015-10-30" format:@"yyyy-MM-dd"];
    NSLog(@"%@", [date stringWithFormat:@"yyyy-MM-dd HH:mm:ss:SSS"]);
    
    // UModel examples
    NSDictionary *dict = @{@"name":@"cailiang", @"content_fields":@[@{@"time":@"12:00", @"content_fields":@[@{@"time":@"12:00"}, @{@"time":@"00:00"}]}, @{@"time":@"00:00", @"content_fields":@[@{@"time":@"12:00"}, @{@"time":@"00:00"}]}]};
    NetworkModel *model = [NetworkModel modelWithDictionary:dict];
    dict = [model dictionaryWithModelKey];
    model = [NetworkModel modelWithDictionary:dict];
    NSString *JSONString = [dict JSONString];
    model = [NetworkModel modelWithJSONString:JSONString];
    model = [UModel modelWithJSONString:JSONString];
    NSLog(@"%@", JSONString);
    
    NSArray *array = @[@{@"time":@"12:00", @"content_fields":@[@{@"time":@"12:00"}, @{@"time":@"00:00"}]}, @{@"time":@"00:00", @"content_fields":@[@{@"time":@"12:00"}, @{@"time":@"00:00"}]}];
    NSArray *items = [NetworkModelContentFieldsItem modelsWithArray:array];
    NSLog(@"%@", [NetworkModelContentFieldsItem arrayWithModels:items]);
    
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
    BaseNavigationController *root = [BaseNavigationController controllerWithRoot:home];
    self.window.rootViewController = root;
}

@end

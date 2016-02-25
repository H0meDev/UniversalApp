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
#import "NetworkSDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:screenBounds()];
    self.window.backgroundColor = sysWhiteColor();
    [self.window makeKeyAndVisible];
    
    NSMutableArray *marray = [NSMutableArray array];
    UModelSQLiteFieldDescription *desc1 = [[UModelSQLiteFieldDescription alloc]init];
    desc1.fieldName = @"index_value";
    desc1.primaryKey = YES;
    desc1.autoincrement = NO;
    desc1.index = YES;
    desc1.unique = YES;
    [marray addObject:desc1];
    
    UModelSQLiteFieldDescription *desc2 = [[UModelSQLiteFieldDescription alloc]init];
    desc2.fieldName = @"rate";
    desc2.primaryKey = YES;
    desc2.index = YES;
    [marray addObject:desc2];
    
    UserInfoTable *model = [UserInfoTable modelWithDictionary:@{@"name":@"cailiang",
                                                                @"rate":@"3.1415926",
                                                                @"excludeProperties":@[@"ABCDEFG"],
                                                                @"dict":@{@"key":@"value"},
                                                                }];
    NSLog(@"%@", model);
    NSLog(@"%@", [model dictionary]);
    NSLog(@"%@", [model dictionaryWithModelKey]);
    
    UModelSQLite *sqlite = [[UModelSQLite alloc]initWith:@"caches.sqlite"];
    BOOL success = [sqlite createTableWith:[UserInfoTable class] descriptions:marray];
    
    model.excludeProperties = @[@"index_value"];
    NSArray *properties = [model propertyArray];
    success = [sqlite insertWith:model];
    
    success = [sqlite excuteWith:@"create table if not exists tb_demo1 (index_value integer primary key, name text, rate float)"];
    success = [sqlite excuteWith:@"insert into tb_demo1(name, rate) values(\"cailiang\", \"3.1415926\")"];
    USQLiteStatement *statement = [sqlite prepareWith:@"select * from tb_demo1"];
    while ([sqlite stepRowWith:statement]) {
        int index = [sqlite fieldIntValueWith:statement index:0];
        const u_char* name = [sqlite fieldTextValueWith:statement index:1];
        float rate = [sqlite fieldDoubleValueWith:statement index:2];
        
        id field1 = [sqlite fieldValueWith:statement index:0];
        id field2 = [sqlite fieldValueWith:statement index:1];
        id field3 = [sqlite fieldValueWith:statement index:2];
        
        NSLog(@"ABCDEFG");
    }
    
    [sqlite finalizeWith:statement];
    statement = nil;
    
    [sqlite close];
    sqlite = nil;
    
    // Goto home
    [self gotoHomePage];
    
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
    root.statusBarContentBackgroundTransparent = YES;
    root.navigationBarContentBackgroundTransparent = YES;
    self.window.rootViewController = root;
}

@end

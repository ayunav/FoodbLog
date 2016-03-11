//
//  AppDelegate.m
//  FoodbLog
//
//  Created by Ayuna Vogel on 10/11/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <ChameleonFramework/Chameleon.h>

#import "AppDelegate.h"
#import "FoodLog.h"

NSString * const parseApplicationId = @"YOUR_PARSE_APP_ID";
NSString * const parseClientKey = @"YOUR_PARSE_CLIENT_KEY";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self setParseDatabase];

    [Chameleon setGlobalThemeUsingPrimaryColor:[UIColor flatOrangeColor] withContentStyle:UIContentStyleLight];

    return YES;
}

- (void)setParseDatabase {

    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    [Parse enableLocalDatastore];

    // Initialize Parse.
    [Parse setApplicationId:parseApplicationId
                  clientKey:parseClientKey];

    [FoodLog registerSubclass];

    // [Optional] Track statistics around application opens.
    // This method should be inside the didFinishLaunchingWithOptions method.
    //[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

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

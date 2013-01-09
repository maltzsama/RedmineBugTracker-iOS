//
//  RBTAppDelegate.m
//  Redmine-Bugtracker
//
//  Created by demetrius on 04/01/13.
//  Copyright (c) 2013 demetrius albuquerque. All rights reserved.
//

#import "RBTAppDelegate.h"
#import "RBTIssue.h"
#import "CKCrashReporter.h"

@implementation RBTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    CKCrashReporter *reporter = [CKCrashReporter sharedReporter];
    reporter.catchExceptions = YES;
    if ([reporter hasCrashAvailable]) {
        
        RBTIssue *myIssue = [[RBTIssue alloc]init];

        myIssue.crash = [reporter savedCrash];
        myIssue.timeout = 60;
        myIssue.server = @"http://192.168.20.18:3000";
        myIssue.userName = @"testuser";
        myIssue.passwd = @"testuser";
        myIssue.projectId = @"bugtrackertap4-ios";
        myIssue.priority = @"1";
        myIssue.status = @"1";
        myIssue.subjectInfo = [NSString stringWithFormat:@"Crash Report: %@",[[reporter savedCrash] objectForKey:@"Name"]];
        
        [myIssue sendIssuetoRedmine];
        [reporter removeSavedCrash];
    }
    
    return YES;
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
    // Internal error reporting

}

@end

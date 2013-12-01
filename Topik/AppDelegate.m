//
//  AppDelegate.m
//  Topik
//
//  Created by Lee Haining on 13-11-23.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSLog(@"Appliction didFinishLaunchingWithOptions");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.needLanspace=FALSE;
    [self checkAndUpdateDatabse];
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
    NSLog(@"applicationDidEnterBackground");
    /**
    UIApplication* app = [UIApplication sharedApplication];
    
    
    UIBackgroundTaskIdentifier __block bgTask = [app beginBackgroundTaskWithExpirationHandler: ^{
        // dispatch_async(dispatch_get_main_queue(), ^{
        // [app endBackgroundTask:bgTask];
        // bgTask = UIBackgroundTaskInvalid;
        // });
    }];
     **/
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    internetReach=[Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    NetworkStatus netStatus=[internetReach currentReachabilityStatus];
    switch(netStatus)
    {
        case ReachableViaWiFi:
        {
            NSLog(@"Current NetStatus:%@",@"Wifi connected");
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"Current NetStatus:%@",@"WWAN connected");
            break;
        }
        case NotReachable:
        {
            NSLog(@"Current NetStatus:%@",@"Not connected");
            break;
        }
        default:
            break;
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark- Database Preparation
- (void)checkAndUpdateDatabse{
    /** Before accessing resource file, should CopyBundleResources and add the target resources
    NSString *dbPath=[[NSBundle mainBundle] pathForResource:@"LectureDB" ofType:@"sqlite"];
    NSLog(@"DB Path in Resource:%@",path);
     **/
    NSError *error;
    BOOL success;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);//NSUserDomainMask: user's home directory --- place to install user's personal items (~)
    NSString *documentsDirectory = [documentPaths objectAtIndex:0];
    NSString *appDBPath=[documentsDirectory stringByAppendingString:@"/LectureDB.sqlite"];
    success=[fileManager fileExistsAtPath:appDBPath];
    if(!success)
    {
        NSString *defaultDBPath = [[NSBundle mainBundle] pathForResource:@"LectureDB" ofType:@"sqlite"];
        NSLog(@"DB Path in Resource:%@",defaultDBPath);
        if(defaultDBPath!=NULL)
        {
            success = [fileManager copyItemAtPath:defaultDBPath toPath:appDBPath error:&error];
            if (!success) {
                NSLog(@"Failed to create writable database file with message '%@'.", [error localizedDescription]);
            }
            else
            {
                NSLog(@"Successed to create writable data file from %@ to %@",defaultDBPath,appDBPath);
            }
        }
    }
    else
    {
        NSLog(@"File Exists:%@ No need to create again.",appDBPath);
    }
    
}
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    //id presentedViewController = [window.rootViewController presentedViewController];
    //NSString *className = presentedViewController ? NSStringFromClass([presentedViewController class]) : nil;
    /**
    if (window && [className isEqualToString:@"MPInlineVideoFullscreenViewController"]) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
     **/
    NSLog(@"Orientation: needLandscape:%d",self.needLanspace);
    if(self.needLanspace)
    {
        return UIInterfaceOrientationMaskAll;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void) reachabilityChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            NSLog(@"reachabilityChanged Current NetStatus:%@",@"WWAN connected");
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"reachabilityChanged Current NetStatus:%@",@"WiFi connected");
            break;
        }
        case NotReachable:
        {
            NSLog(@"reachabilityChanged Current NetStatus:%@",@"Not connected");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"We are unable to make a internet connection at this time. Some functionality will be limited until a connection is made." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            break;
        }
    }
}

@end

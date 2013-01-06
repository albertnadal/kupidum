//
//  AppDelegate.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 18/11/12.
//  Copyright (c) 2012 laFruitera.com. All rights reserved.
//

#import "AppDelegate.h"
#import "InitialScreenViewController.h"
#import "ChatViewController.h"
#import "VideoconferenceViewController.h"
#import "FinderViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    sleep(1);

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    InitialScreenViewController *initialScreen = [[InitialScreenViewController alloc] initWithNibName:@"InitialScreenViewController" bundle:nil];
    UINavigationController *initialNavigationController = [[UINavigationController alloc] initWithRootViewController:initialScreen];
    self.window.rootViewController = initialNavigationController;

    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], UITextAttributeTextColor,
                                                           [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8], UITextAttributeTextShadowColor,
                                                           [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)], UITextAttributeTextShadowOffset,
                                                           [UIFont fontWithName:@"HelveticaNeue" size:20.0f], UITextAttributeFont,
                                                           nil
     ]];

    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];

    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)showKupidumTabBar
{
    FinderViewController *finderViewController = [[FinderViewController alloc] initWithNibName:@"FinderViewController" bundle:nil];
    VideoconferenceViewController *videoconferenceViewController = [[VideoconferenceViewController alloc] initWithNibName:@"VideoconferenceViewController" bundle:nil];
    ChatViewController *chatViewController = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    UIViewController *finderViewController2 = [[UIViewController alloc] initWithNibName:@"FinderViewController" bundle:nil];

    UIViewController *homeViewController = [[UIViewController alloc] init];
    UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    [homeViewController setTabBarItem:[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Inici", @"") image:[UIImage imageNamed:@"tab_icon_home"] tag:1]];
    [homeViewController.navigationItem setTitle:@"Superwoman"];

    UIImageView *home_background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 455)];
    [home_background setImage:[UIImage imageNamed:@"home_prototype.png"]];
    [homeViewController.view addSubview:home_background];

    UINavigationController *finderNavigationController = [[UINavigationController alloc] initWithRootViewController:finderViewController];
    [finderNavigationController setTabBarItem:[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Cercar", @"") image:[UIImage imageNamed:@"tab_icon_search"] tag:2]];
    [finderViewController2 setTabBarItem:[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Missatges", @"") image:[UIImage imageNamed:@"tab_icon_msg"] tag:3]];

    UINavigationController *chatNavigationController = [[UINavigationController alloc] initWithRootViewController:chatViewController];
    [chatNavigationController setTabBarItem:[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Xat", @"") image:[UIImage imageNamed:@"tab_icon_chat"] tag:4]];
    [videoconferenceViewController setTabBarItem:[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Videotrucada", @"") image:[UIImage imageNamed:@"tab_icon_video"] tag:5]];

    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[homeNavigationController, finderNavigationController, finderViewController2, chatNavigationController, videoconferenceViewController];
    [self.tabBarController setSelectedViewController:videoconferenceViewController];
    self.window.rootViewController = self.tabBarController;
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

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end

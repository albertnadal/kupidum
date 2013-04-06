//
//  AppDelegate.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 18/11/12.
//  Copyright (c) 2012 laFruitera.com. All rights reserved.
//

#import "AppDelegate.h"
#import "KupidumDBSingleton.h"
#import "InitialScreenViewController.h"
#import "HomeViewController.h"
#import "ChatViewController.h"
#import "FinderViewController.h"
#import "VideocallViewController.h"
#import "MessageViewController.h"

#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"Failure on line %d", __LINE__); abort(); } }

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    sleep(1);

    [self createDatabaseIfNeeded];


#warning remove the following lines
[[KPDUserSingleton sharedInstance] setUsername:@"albert"];
[[KPDClientSIP sharedInstance] registerToServerWithUser:@"albert" password:@"albert"];



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

- (void)createDatabaseIfNeeded
{
    FMDatabase *db = [[KupidumDBSingleton sharedInstance] db];

    [db beginTransaction];
    // User tables
    [db executeUpdate:@"create table user (username text primary key, avatar_url text, avatar blob)"];

    // Chat tables
    [db executeUpdate:@"create table chat (username_a text, username_b text, last_message text, date_last_message date)"];
    [db executeUpdate:@"create table conversation (from_username text, to_username text, message text, date_message date)"];

    // Videocall tables
    [db executeUpdate:@"create table videocall (from_username text, to_username text, length int, first_incoming_frame blob, is_incoming_call bool, missed bool, date_call date)"];

    // Messages
    [db executeUpdate:@"create table message (from_username text, to_username text, subject text, message text, read bool, date_message date)"];

    // User profile
    [db executeUpdate:@"create table user_profile (username text primary key, eye_color_id int, body_height int, body_weight int, hair_color_id int, hair_size_id int, body_look_id int, body_highlight_id int, citizenship_id int, ethnic_id int, religion_id int, religious_practice_id int, marriage_opinion_id int, romanticism_level_id int, want_children_id int, study_level_id int, profession_id int, salary_id int, style_id int, alimentation_id int, smoke_level_id int, animal_id int)"];

//    [db executeUpdate:@"create table movie (movie_id int primary key, name text)"];
    [db executeUpdate:@"create table user_movie (user_movie_id int primary key, username text, movie_id int)"];

//    [db executeUpdate:@"create table music (music_id int primary key, name text)"];
    [db executeUpdate:@"create table user_music (user_music_id int primary key, username text, music_id int)"];

//    [db executeUpdate:@"create table sparetime_activity (sparetime_activity_id int primary key, name text)"];
    [db executeUpdate:@"create table user_sparetime_activity (user_sparetime_activity_id int primary key, username text, sparetime_activity_id int)"];

//    [db executeUpdate:@"create table sport (sport_id int primary key, name text)"];
    [db executeUpdate:@"create table user_sport (user_sport_id int primary key, username text, sport_id int)"];

//    [db executeUpdate:@"create table hobby (hobby_id int primary key, name text)"];
    [db executeUpdate:@"create table user_hobby (user_hobby_id int primary key, username text, hobby_id int)"];

//    [db executeUpdate:@"create table language (language_id int primary key, name text)"];
    [db executeUpdate:@"create table user_language (user_language_id int primary key, username text, language_id int)"];

    [db commit];
}

- (void)showKupidumTabBar
{
    MessageViewController *messageViewController = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
    FinderViewController *finderViewController = [[FinderViewController alloc] initWithNibName:@"FinderViewController" bundle:nil];
    VideocallViewController *videocallViewController = [[VideocallViewController alloc] initWithNibName:@"VideocallViewController" bundle:nil];
    ChatViewController *chatViewController = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];

    UIViewController *homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    [homeViewController setTabBarItem:[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Superwoman", @"") image:[UIImage imageNamed:@"tab_icon_home"] tag:1]];
    [homeViewController.navigationItem setTitle:@"Superwoman"];

    UINavigationController *finderNavigationController = [[UINavigationController alloc] initWithRootViewController:finderViewController];
    [finderNavigationController setTabBarItem:[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Cercar", @"") image:[UIImage imageNamed:@"tab_icon_search"] tag:2]];

    UINavigationController *messageNavigationController = [[UINavigationController alloc] initWithRootViewController:messageViewController];
    [messageNavigationController setTabBarItem:[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Missatges", @"") image:[UIImage imageNamed:@"tab_icon_msg"] tag:3]];
    [messageViewController setTabBarItem:[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Missatges", @"") image:[UIImage imageNamed:@"tab_icon_msg"] tag:3]];

    UINavigationController *chatNavigationController = [[UINavigationController alloc] initWithRootViewController:chatViewController];
    [chatNavigationController setTabBarItem:[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Xat", @"") image:[UIImage imageNamed:@"tab_icon_chat"] tag:4]];

    UINavigationController *videocallNavigationController = [[UINavigationController alloc] initWithRootViewController:videocallViewController];
    [videocallNavigationController setTabBarItem:[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Videotrucada", @"") image:[UIImage imageNamed:@"tab_icon_video"] tag:4]];
    [videocallViewController setTabBarItem:[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Videotrucada", @"") image:[UIImage imageNamed:@"tab_icon_video"] tag:5]];

    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[homeNavigationController, finderNavigationController, messageNavigationController, chatNavigationController, videocallNavigationController];
    [self.tabBarController setSelectedViewController:homeNavigationController];
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

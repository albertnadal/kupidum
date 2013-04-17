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
    [db executeUpdate:@"create table user_profile (username text primary key, face_front_image_url text, face_front_image blob, face_profile_image_url text, face_profile_image blob, body_image_url text, body_image blob, height int, weight int, hair_color_id int, hair_size_id int, eye_color_id int, personality_id int, appearance_id int, silhouette_id int, body_highlight_id int, marital_status_id int, has_childrens_id int, live_with_id int, citizenship_id int, ethnical_origin_id int, religion_id int, religion_level_id int, marriage_opinion_id int, romanticism_id int, want_childrens_id int, studies_id int, languages_id text, profession_id int, salary_id int, style_id int, diet_id int, smoke_id int, animals_id text, hobbies_id text, sports_id text, sparetime_id text, music_id text, movies_id text)"];

    // User candidate profile
    [db executeUpdate:@"create table user_candidate_profile (username text primary key, min_age int, max_age int, min_height int, max_height int, min_weight int, max_weight int, marital_status_id text, where_is_living_id text, want_childrens_id text, has_childrens_id text, silhouette_id text, main_characteristic_id text, is_romantic_id text, marriage_is_id text, smokes_id text, diet_id text, nation_id text, ethnical_origin_id text, body_look_id text, hair_size_id text, hair_color_id text, eye_color_id text, style_id text, highlight_id text, studies_min_level_id int, studies_max_level_id int, languages_id text, religion_id text, religion_level_id text, hobbies_id text, sparetime_id text, music_id text, movies_id text, animals_id text, sports_id text, business_id text, min_salary_id int, max_salary_id int)"];

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

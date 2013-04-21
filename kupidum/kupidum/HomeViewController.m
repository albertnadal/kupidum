//
//  HomeViewController.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 06/01/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "HomeViewController.h"
#import "UsersNavigatorViewController.h"
#import "UserProfileViewController.h"
#import "MyAccountViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ProfileFormDataSource.h"
#import <IBAForms/IBAForms.h>

/*typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;*/

@interface HomeViewController ()
{
/*    float lastContentOffset;
    bool topBarIsMoving;
    CGRect originalViewFrame;
    ScrollDirection lastScrollDirection;*/
}

- (NSMutableDictionary *)retrieveUserProfileModelForUser:(NSString *)username_;
- (void)hideTopBarAnimated;
- (void)showTopBarAnimated;

@end

@implementation HomeViewController

@synthesize scroll, profileResumeView, nearToYouCandidatesView, candidatesYouMayLikeView, background;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [scroll setContentSize:CGSizeMake(320, 535)];

    [scroll addPullToRefreshWithActionHandler:^{
        // prepend data to dataSource, insert cells at top of table view
        // call [tableView.pullToRefreshView stopAnimating] when done
        NSLog(@"Refresh!");
        [scroll.pullToRefreshView stopAnimating];
    }];

    profileResumeView.layer.cornerRadius = 5.0;
    profileResumeView.layer.masksToBounds = YES;

    nearToYouCandidatesTableViewController = [[KPDUsersHorizontalTableViewController alloc] initWithFrame:CGRectMake(0, 0, 98, 209)];
    [nearToYouCandidatesTableViewController setDelegate:self];
    [nearToYouCandidatesView addSubview:nearToYouCandidatesTableViewController.view];
    nearToYouCandidatesView.layer.cornerRadius = 1.0;
    nearToYouCandidatesView.layer.masksToBounds = YES;
    [nearToYouCandidatesTableViewController scrollContentToLeft];

    candidatesYouMayLikeTableViewController = [[KPDUsersHorizontalTableViewController alloc] initWithFrame:CGRectMake(0, 0, 98, 209)];
    [candidatesYouMayLikeTableViewController setDelegate:self];
    [candidatesYouMayLikeView addSubview:candidatesYouMayLikeTableViewController.view];
    candidatesYouMayLikeView.layer.cornerRadius = 1.0;
    candidatesYouMayLikeView.layer.masksToBounds = YES;
    [candidatesYouMayLikeTableViewController scrollContentToLeft];
}

/*- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    ScrollDirection scrollDirection;
    if (lastContentOffset > scrollView.contentOffset.y)
        scrollDirection = ScrollDirectionDown;
    else if (lastContentOffset <= scrollView.contentOffset.y)
        scrollDirection = ScrollDirectionUp;
    
    lastContentOffset = scrollView.contentOffset.y;

    if(scrollDirection == lastScrollDirection)
        return;

    lastScrollDirection = scrollDirection;

    if((!topBarIsMoving) && (scrollDirection == ScrollDirectionUp) && (!self.navigationController.navigationBar.isHidden) && (scrollView.dragging))
    {
        NSLog(@"Up!");
        [self performSelectorOnMainThread:@selector(hideTopBarAnimated) withObject:nil waitUntilDone:YES];
    }
    else if((!topBarIsMoving) && (scrollDirection == ScrollDirectionDown) && (self.navigationController.navigationBar.isHidden) && (scrollView.dragging))
    {
        NSLog(@"Down!");
        [self performSelectorOnMainThread:@selector(showTopBarAnimated) withObject:nil waitUntilDone:YES];
    }
}

- (void)hideTopBarAnimated
{
    if(topBarIsMoving)
        return;

    topBarIsMoving = true;

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
#if __IPHONE_OS_VERSION_MIN_REQUIRED > 30100
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
#else
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
#endif
#endif

    [self.navigationController setNavigationBarHidden:YES animated:YES];

    topBarIsMoving = false;
}

- (void)showTopBarAnimated
{
    if(topBarIsMoving)
        return;

    topBarIsMoving = true;
    
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
#if __IPHONE_OS_VERSION_MIN_REQUIRED > 30100
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
#else
    [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
#endif
#endif
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    topBarIsMoving = false;
}*/

- (void)usersHorizontalTableViewControllerDidRefresh:(KPDUsersHorizontalTableViewController *)tableViewController
{
    [self showPeopleLivingNearToUser:@"Superwoman"];
}

- (void)showPeopleLivingNearToUser:(NSString *)theUser
{
    UsersNavigatorViewController *unvc = [[UsersNavigatorViewController alloc] initWithNibName:@"UsersNavigatorViewController" bundle:nil];
    [self.navigationController pushViewController:unvc animated:YES];
}

- (NSMutableDictionary *)retrieveUserProfileModelForUser:(NSString *)username_
{
	NSMutableDictionary *model = [[NSMutableDictionary alloc] init];
    NSArray *selectedEyeColorListOption = [IBAPickListFormOption pickListOptionsForStrings:[NSSet setWithObject:@"[5]Verds"]];

	[model setObject:selectedEyeColorListOption forKey:kEyeColorUserProfileField];
    return model;
}

- (IBAction)showUserProfile:(id)sender
{
    NSString *username = @"albert";
    UserProfileViewController *upvc = [[UserProfileViewController alloc] initWithUsername:username isEditable:YES];
    [self.navigationController pushViewController:upvc animated:YES];
}

- (IBAction)showUserAccount:(id)sender
{
    NSString *username = @"albert";
    MyAccountViewController *mavc = [[MyAccountViewController alloc] initWithNibName:@"MyAccountViewController" bundle:nil withUsername:username];
    [self.navigationController pushViewController:mavc animated:YES];
}

- (IBAction)showUserMessages:(id)sender
{
    self.tabBarController.selectedIndex = 2; // 2 => Messages screen index
}

- (IBAction)showRecentVisitors:(id)sender
{
    UsersNavigatorViewController *unvc = [[UsersNavigatorViewController alloc] initWithNibName:@"UsersNavigatorViewController" bundle:nil];
    [self.navigationController pushViewController:unvc animated:YES];
}

- (IBAction)showRecentUsersInterestedWithMe:(id)sender
{
    UsersNavigatorViewController *unvc = [[UsersNavigatorViewController alloc] initWithNibName:@"UsersNavigatorViewController" bundle:nil];
    [self.navigationController pushViewController:unvc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [nearToYouCandidatesTableViewController scrollContentToLeft];
    [candidatesYouMayLikeTableViewController scrollContentToLeft];
}

@end

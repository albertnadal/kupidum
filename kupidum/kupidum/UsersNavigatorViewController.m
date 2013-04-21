//
//  UsersNavigatorViewController.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 30/03/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "UsersNavigatorViewController.h"
#import "UsersNavigatorContainerView.h"
#import "UserNavigatorProfileViewController.h"
#import "KPDUser.h"
#import "KPDUserProfile.h"
#import "UserProfileViewController.h"
#import "KPDUIUtilities.h"

static const int kSpaceBetweenAvatars = 6;
static const int kAvatarWidth = 65;
static const int kAvatarHeight = 65;
static const int kNavigationScrollMargin = 3;

@interface UsersNavigatorViewController ()
{
    NSArray *usersList;

    int contentScrollNavigatorWidth;
    int contentScrollProfilesWidth;

    IBOutlet UsersNavigatorContainerView *scrollNavigatorContainer;
    IBOutlet UIScrollView *scrollNavigator;
    IBOutlet UIScrollView *scrollProfiles;
    UIScrollView *activeScroll;

    NSMutableArray *userNavigatorProfileViewControllers;
}

@property (nonatomic, retain) IBOutlet UsersNavigatorContainerView *scrollNavigatorContainer;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollNavigator;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollProfiles;

- (void)showNavigationBarButtons;
- (void)backPressed;
- (void)loadFakeUsers;
- (void)showUsersNavigator;
- (void)showUsersProfiles;

@end

@implementation UsersNavigatorViewController

@synthesize scrollNavigator, scrollProfiles, scrollNavigatorContainer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        contentScrollNavigatorWidth = 0;
        contentScrollProfilesWidth = 0;
        activeScroll = nil;
        userNavigatorProfileViewControllers = nil;

        [self loadFakeUsers];
    }
    return self;
}

- (void)showNavigationBarButtons
{
    UIButton *backButton = [KPDUIUtilities customCircleBarButtonWithImage:@"nav_black_circle_button.png"
                                                           andInsideImage:@"nav_arrow_back_button.png"
                                                              andSelector:@selector(backPressed)
                                                                andTarget:self];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backButton]];
}

- (void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView != activeScroll)
        return;

    if(scrollView == scrollNavigator)
    {
        int offsetXScrollUsersProfiles = (scrollView.contentOffset.x * [UIScreen mainScreen].bounds.size.width) / (kSpaceBetweenAvatars + kAvatarWidth);
        [scrollProfiles setContentOffset:CGPointMake(offsetXScrollUsersProfiles, 0) animated:NO];

        int indexSelectedUser = (scrollView.contentOffset.x * [usersList count]) / (([usersList count]*(kSpaceBetweenAvatars + kAvatarWidth)));
        [self setTitle:[NSString stringWithFormat:@"%@: %@", [NSString stringWithFormat:NSLocalizedString(@"%d de %d", @""), indexSelectedUser+1, [usersList count]], [[usersList objectAtIndex:indexSelectedUser] username]]];
    }
    else if(scrollView == scrollProfiles)
    {
        int offsetXScrollUsersNavigator = (scrollView.contentOffset.x * (kSpaceBetweenAvatars + kAvatarWidth)) / [UIScreen mainScreen].bounds.size.width;
        [scrollNavigator setContentOffset:CGPointMake(offsetXScrollUsersNavigator, 0) animated:NO];

        int indexSelectedUser = (scrollView.contentOffset.x * [usersList count]) / ([usersList count]*[UIScreen mainScreen].bounds.size.width);
        [self setTitle:[NSString stringWithFormat:@"%@: %@", [NSString stringWithFormat:NSLocalizedString(@"%d de %d", @""), indexSelectedUser+1, [usersList count]], [[usersList objectAtIndex:indexSelectedUser] username]]];
        //[self setTitle:[NSString stringWithFormat:NSLocalizedString(@"%d de %d", @""), indexSelectedUser+1, [usersList count]]];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    activeScroll = scrollView;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    activeScroll = nil;
}

- (void)loadFakeUsers
{
    KPDUser *user1 = [[KPDUser alloc] initWithUsername:@"user1"];
    KPDUser *user2 = [[KPDUser alloc] initWithUsername:@"user2"];
    KPDUser *user3 = [[KPDUser alloc] initWithUsername:@"user3"];
    KPDUser *user4 = [[KPDUser alloc] initWithUsername:@"user4"];
    KPDUser *user5 = [[KPDUser alloc] initWithUsername:@"user5"];
    KPDUser *user6 = [[KPDUser alloc] initWithUsername:@"user6"];
    KPDUser *user7 = [[KPDUser alloc] initWithUsername:@"user7"];
    KPDUser *user8 = [[KPDUser alloc] initWithUsername:@"user8"];
    usersList = @[ user1, user2, user3, user4, user5, user6, user7, user8 ];
}

- (void)showUsersNavigator
{
    [self.scrollNavigatorContainer setClipsToBounds:YES];
    [self.scrollNavigator setClipsToBounds:NO];

    int x = 0;
    for(int i=0; i<[usersList count]; i++)
    {
        if(i)   x+=kSpaceBetweenAvatars;
        else    x+=kNavigationScrollMargin;

        KPDUser *user = [usersList objectAtIndex:i];

        UIView *avatarContainer = [[UIView alloc] initWithFrame:CGRectMake(x, 0, kAvatarWidth, kAvatarHeight)];
        [avatarContainer setBackgroundColor:[UIColor whiteColor]];
        UIImageView *avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, kAvatarWidth-2, kAvatarHeight-2)];
        [avatarImage setImage:[user avatar]];
        [avatarContainer addSubview:avatarImage];
        [scrollNavigator addSubview:avatarContainer];

        x+=kAvatarWidth;
    }

    if(x)   x+=kNavigationScrollMargin;

    contentScrollNavigatorWidth = x;

    [scrollNavigator setContentSize:CGSizeMake(x, kAvatarHeight)];
}

- (void)showUsersProfiles
{
    if(userNavigatorProfileViewControllers)
        [userNavigatorProfileViewControllers removeAllObjects];

    userNavigatorProfileViewControllers = [[NSMutableArray alloc] init];

    int x = 0;
    for(int i=0; i<[usersList count]; i++)
    {        
        KPDUser *user = [usersList objectAtIndex:i];

        UserNavigatorProfileViewController *unpvc = [[UserNavigatorProfileViewController alloc] initWithUser:user];
        [unpvc setDelegate:self];
        [unpvc.view setFrame:CGRectMake(x, 0, [UIScreen mainScreen].bounds.size.width, scrollProfiles.frame.size.height)];
        [scrollProfiles addSubview:unpvc.view];
        [userNavigatorProfileViewControllers addObject:unpvc];

        x+=[UIScreen mainScreen].bounds.size.width;
    }

    contentScrollProfilesWidth = 0;

    [scrollProfiles setContentSize:CGSizeMake(x, scrollProfiles.frame.size.height)];
}

- (void)showUserProfile:(NSString *)username
{
    UserProfileViewController *upvc = [[UserProfileViewController alloc] initWithUsername:username isEditable:NO];
    [self.navigationController pushViewController:upvc animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self showNavigationBarButtons];
    [self setTitle:[NSString stringWithFormat:@"%@: %@", [NSString stringWithFormat:NSLocalizedString(@"%d de %d", @""), 1, [usersList count]], [[usersList objectAtIndex:0] username]]];
    [self showUsersNavigator];
    [self showUsersProfiles];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

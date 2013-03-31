//
//  UsersNavigatorViewController.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 30/03/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "UsersNavigatorViewController.h"
#import "UsersNavigatorContainerView.h"
#import "KPDUser.h"
#import "KPDUserProfile.h"

static const int kSpaceBetweenAvatars = 6;
static const int kAvatarWidth = 65;
static const int kAvatarHeight = 65;
static const int kNavigationScrollMargin = 3;

@interface UsersNavigatorViewController ()
{
    NSArray *usersList;
    NSArray *userProfiles;

    IBOutlet UsersNavigatorContainerView *scrollNavigatorContainer;
    IBOutlet UIScrollView *scrollNavigator;
    IBOutlet UIScrollView *scrollProfiles;
}

@property (nonatomic, retain) IBOutlet UsersNavigatorContainerView *scrollNavigatorContainer;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollNavigator;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollProfiles;

- (void)loadFakeUsers;
- (void)showUsersNavigator;

@end

@implementation UsersNavigatorViewController

@synthesize scrollNavigator, scrollProfiles, scrollNavigatorContainer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self loadFakeUsers];
    }
    return self;
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
        [avatarImage setImage:[UIImage imageNamed:@"fake_photo1.png"]];
        [avatarContainer addSubview:avatarImage];
        [scrollNavigator addSubview:avatarContainer];

        x+=kAvatarWidth;
    }

    if(x)   x+=kNavigationScrollMargin;

    [scrollNavigator setContentSize:CGSizeMake(x, kAvatarHeight)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:[NSString stringWithFormat:NSLocalizedString(@"%d de %d", @""), 1, 34]];
    [self showUsersNavigator];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

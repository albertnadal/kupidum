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

@interface HomeViewController ()
{

}

- (void)retrieveDataFromWebService;
- (bool)imageIsEmpty:(UIImage *)image;
- (void)setupUserInterface;
- (void)loadUserPictures;
- (void)updateLastVisitorButton;
- (void)updateLastMessageUserButton;
- (void)updateLastInterestedUserButton;
- (NSMutableDictionary *)retrieveUserProfileModelForUser:(NSString *)username_;
- (void)hideTopBarAnimated;
- (void)showTopBarAnimated;

@end

@implementation HomeViewController

@synthesize scroll, profileResumeView, nearToYouCandidatesView, candidatesYouMayLikeView, background, lastVisitor, lastMessageUser, lastInterestedUser, lastVisitorButton, lastMessageUserButton, lastInterestedUserButton, interestingPeopleLivingNear, interestingPeopleYouMayLike, nearToYouCandidatesTableViewController, candidatesYouMayLikeTableViewController, myAccountButton, myProfileButton, nearToYouCandidatesLabel, candidatesYouMayLikeLabel, faceFrontPhoto, faceProfilePhoto, bodySilouetePhoto, userProfile;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.lastVisitor = nil;
        self.lastMessageUser = nil;
        self.lastInterestedUser = nil;
        self.interestingPeopleLivingNear = nil;
        self.interestingPeopleYouMayLike = nil;
        self.userProfile = [[KPDUserProfile alloc] initWithUsername:@"albert"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadUserPictures];

    [self setupUserInterface];

    [scroll setContentSize:CGSizeMake(320, 532)];

    [scroll addPullToRefreshWithActionHandler:^{
        // prepend data to dataSource, insert cells at top of table view
        // call [tableView.pullToRefreshView stopAnimating] when done
        NSLog(@"Refresh!");
        [scroll.pullToRefreshView stopAnimating];
    }];

#warning remove the loading of fake data and implement the data loading from the web service
    [self retrieveDataFromWebService];

    [self updateLastVisitorButton];
    [self updateLastMessageUserButton];
    [self updateLastInterestedUserButton];

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

- (bool)imageIsEmpty:(UIImage *)image
{
    return ((!image.size.width) && (!image.size.height));
}

- (void)loadUserPictures
{
    // Head front picture
    if((self.userProfile.faceFrontImage) && (![self imageIsEmpty:self.userProfile.faceFrontImage]))
    {
        [self.faceFrontPhoto setImage:self.userProfile.faceFrontImage];
    }
    else
    {
        switch (self.userProfile.gender.intValue)
        {
            case kMale:     [self.faceFrontPhoto setImage:[UIImage imageNamed:@"img_user_default_front_man.png"]];
                break;
                
            case kFemale:   [self.faceFrontPhoto setImage:[UIImage imageNamed:@"img_user_default_front_woman.png"]];
                break;
        }
    }
    
    // Head profile picture
    if((self.userProfile.faceProfileImage) && (![self imageIsEmpty:self.userProfile.faceProfileImage]))
    {
        [self.faceProfilePhoto setImage:self.userProfile.faceProfileImage];
    }
    else
    {
        switch (self.userProfile.gender.intValue)
        {
            case kMale:     [self.faceProfilePhoto setImage:[UIImage imageNamed:@"img_user_default_profile_man.png"]];
                break;
                
            case kFemale:   [self.faceProfilePhoto setImage:[UIImage imageNamed:@"img_user_default_profile_woman.png"]];
                break;
        }
    }
    
    // Body silhouette picture
    if((self.userProfile.bodyImage) && (![self imageIsEmpty:self.userProfile.bodyImage]))
    {
        [self.bodySilouetePhoto setImage:self.userProfile.bodyImage];
    }
    else
    {
        switch (self.userProfile.gender.intValue)
        {
            case kMale:     [self.bodySilouetePhoto setImage:[UIImage imageNamed:@"img_user_default_body_man.png"]];
                break;
                
            case kFemale:   [self.bodySilouetePhoto setImage:[UIImage imageNamed:@"img_user_default_body_woman.png"]];
                break;
        }
    }
}

- (void)setupUserInterface
{
    // people neart to you label
    [self.nearToYouCandidatesLabel setText:NSLocalizedString(@"Interesting people living near to you", @"")];
    [self.nearToYouCandidatesLabel.layer setMasksToBounds:NO];
    self.nearToYouCandidatesLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.nearToYouCandidatesLabel.layer.shadowOpacity = 0.4;
    self.nearToYouCandidatesLabel.layer.shadowRadius = 1;
    self.nearToYouCandidatesLabel.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);

    // people you may like label
    [self.candidatesYouMayLikeLabel setText:NSLocalizedString(@"Interesting people you may like", @"")];
    [self.candidatesYouMayLikeLabel.layer setMasksToBounds:NO];
    self.candidatesYouMayLikeLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.candidatesYouMayLikeLabel.layer.shadowOpacity = 0.4;
    self.candidatesYouMayLikeLabel.layer.shadowRadius = 1;
    self.candidatesYouMayLikeLabel.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);

    // last visitor button
    [self.lastVisitorButton.titleLabel.layer setMasksToBounds:NO];
    self.lastVisitorButton.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.lastVisitorButton.titleLabel.layer.shadowOpacity = 1.0;
    self.lastVisitorButton.titleLabel.layer.shadowRadius = 3;
    self.lastVisitorButton.titleLabel.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);

    [self.lastVisitorButton.imageView.layer setMasksToBounds:NO];
    self.lastVisitorButton.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.lastVisitorButton.imageView.layer.shadowOpacity = 1.0;
    self.lastVisitorButton.imageView.layer.shadowRadius = 3;
    self.lastVisitorButton.imageView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);

    // last message user button
    [self.lastMessageUserButton.titleLabel.layer setMasksToBounds:NO];
    self.lastMessageUserButton.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.lastMessageUserButton.titleLabel.layer.shadowOpacity = 1.0;
    self.lastMessageUserButton.titleLabel.layer.shadowRadius = 3;
    self.lastMessageUserButton.titleLabel.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);

    [self.lastMessageUserButton.imageView.layer setMasksToBounds:NO];
    self.lastMessageUserButton.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.lastMessageUserButton.imageView.layer.shadowOpacity = 1.0;
    self.lastMessageUserButton.imageView.layer.shadowRadius = 3;
    self.lastMessageUserButton.imageView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);

    // last interested user button
    [self.lastInterestedUserButton.titleLabel.layer setMasksToBounds:NO];
    self.lastInterestedUserButton.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.lastInterestedUserButton.titleLabel.layer.shadowOpacity = 1.0;
    self.lastInterestedUserButton.titleLabel.layer.shadowRadius = 3;
    self.lastInterestedUserButton.titleLabel.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);

    [self.lastInterestedUserButton.imageView.layer setMasksToBounds:NO];
    self.lastInterestedUserButton.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.lastInterestedUserButton.imageView.layer.shadowOpacity = 1.0;
    self.lastInterestedUserButton.imageView.layer.shadowRadius = 3;
    self.lastInterestedUserButton.imageView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);

    // my profile button
    [self.myProfileButton.titleLabel.layer setMasksToBounds:NO];
    self.myProfileButton.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.myProfileButton.titleLabel.layer.shadowOpacity = 0.4;
    self.myProfileButton.titleLabel.layer.shadowRadius = 1;
    self.myProfileButton.titleLabel.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);

    [self.myProfileButton.imageView.layer setMasksToBounds:NO];
    self.myProfileButton.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.myProfileButton.imageView.layer.shadowOpacity = 0.4;
    self.myProfileButton.imageView.layer.shadowRadius = 1;
    self.myProfileButton.imageView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);

    // my account button
    [self.myAccountButton.titleLabel.layer setMasksToBounds:NO];
    self.myAccountButton.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.myAccountButton.titleLabel.layer.shadowOpacity = 0.4;
    self.myAccountButton.titleLabel.layer.shadowRadius = 1;
    self.myAccountButton.titleLabel.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);

    [self.myAccountButton.imageView.layer setMasksToBounds:NO];
    self.myAccountButton.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.myAccountButton.imageView.layer.shadowOpacity = 0.4;
    self.myAccountButton.imageView.layer.shadowRadius = 1;
    self.myAccountButton.imageView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
}

- (void)retrieveDataFromWebService
{
    self.lastVisitor = [[KPDUser alloc] initWithUsername:@"pepito"];
    self.lastMessageUser = [[KPDUser alloc] initWithUsername:@"fulanito"];
    self.lastInterestedUser = [[KPDUser alloc] initWithUsername:@"menganito"];

    KPDUser *user1 = [[KPDUser alloc] initWithUsername:@"superman"];
    KPDUser *user2 = [[KPDUser alloc] initWithUsername:@"doraemon"];
    KPDUser *user3 = [[KPDUser alloc] initWithUsername:@"gojira"];
    KPDUser *user4 = [[KPDUser alloc] initWithUsername:@"muzaman"];
    KPDUser *user5 = [[KPDUser alloc] initWithUsername:@"perchita"];

    self.interestingPeopleLivingNear = @[user1, user2, user3, user4, user5];
    self.interestingPeopleYouMayLike = @[user1, user2, user3, user4, user5];
}

- (void)updateLastVisitorButton
{
    if(self.lastVisitor)
    {
        [self.lastVisitorButton setBackgroundImage:self.lastVisitor.avatar forState:UIControlStateNormal];
        [self.lastVisitorButton setTitle:@"2" forState:UIControlStateNormal];
    }
    else
    {
        [self.lastVisitorButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.lastVisitorButton setTitle:@"0" forState:UIControlStateNormal];
    }
}

- (void)updateLastMessageUserButton
{
    if(self.lastMessageUser)
    {
        [self.lastMessageUserButton setBackgroundImage:self.lastMessageUser.avatar forState:UIControlStateNormal];
        [self.lastMessageUserButton setTitle:@"3" forState:UIControlStateNormal];
    }
    else
    {
        [self.lastMessageUserButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.lastMessageUserButton setTitle:@"0" forState:UIControlStateNormal];
    }
}

- (void)updateLastInterestedUserButton
{
    if(self.lastInterestedUser)
    {
        [self.lastInterestedUserButton setBackgroundImage:self.lastInterestedUser.avatar forState:UIControlStateNormal];
        [self.lastInterestedUserButton setTitle:@"1" forState:UIControlStateNormal];
    }
    else
    {
        [self.lastInterestedUserButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.lastInterestedUserButton setTitle:@"0" forState:UIControlStateNormal];
    }
}

- (void)usersHorizontalTableViewController:(KPDUsersHorizontalTableViewController *)tableViewController didSelectUserAtIndex:(int)index
{
    KPDUser *user = nil;

    if((tableViewController == self.nearToYouCandidatesTableViewController) && (self.interestingPeopleLivingNear))
    {
        user = [self.interestingPeopleLivingNear objectAtIndex:index];
    }
    else if((tableViewController == self.candidatesYouMayLikeTableViewController) && (self.interestingPeopleYouMayLike))
    {
        user = [self.interestingPeopleYouMayLike objectAtIndex:index];
    }

    UserProfileViewController *upvc = [[UserProfileViewController alloc] initWithUsername:user.username isEditable:NO];
    [self.navigationController pushViewController:upvc animated:YES];
}

- (void)usersHorizontalTableViewControllerDidRefresh:(KPDUsersHorizontalTableViewController *)tableViewController
{
    [self showPeopleLivingNearToUser:@"Superwoman"];
}

- (KPDUser *)usersHorizontalTableViewControllerDidRefresh:(KPDUsersHorizontalTableViewController *)tableViewController userForRowAtIndex:(int)index
{
    if((tableViewController == self.nearToYouCandidatesTableViewController) && (self.interestingPeopleLivingNear))
    {
        return [self.interestingPeopleLivingNear objectAtIndex:index];
    }
    else if((tableViewController == self.candidatesYouMayLikeTableViewController) && (self.interestingPeopleYouMayLike))
    {
        return [self.interestingPeopleYouMayLike objectAtIndex:index];
    }
    
    return nil;
}

- (NSInteger)numberOfUsersForHorizontalTableViewController:(KPDUsersHorizontalTableViewController *)tableViewController
{
    if((tableViewController == self.nearToYouCandidatesTableViewController) && (self.interestingPeopleLivingNear))
    {
        return [self.interestingPeopleLivingNear count];
    }
    else if((tableViewController == self.candidatesYouMayLikeTableViewController) && (self.interestingPeopleYouMayLike))
    {
        return [self.interestingPeopleYouMayLike count];
    }

    return 0;
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

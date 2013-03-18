//
//  HomeViewController.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 06/01/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "HomeViewController.h"
#import "SearchResultsListViewController.h"
#import "UserProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ProfileFormDataSource.h"
#import <IBAForms/IBAForms.h>

@interface HomeViewController ()

- (NSMutableDictionary *)retrieveUserProfileModelForUser:(NSString *)username_;

@end

@implementation HomeViewController

@synthesize scroll, profileResumeView, nearToYouCandidatesView, candidatesYouMayLikeView, candidatesWhoYouMayLikeView;

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
    // Do any additional setup after loading the view from its nib.

    [scroll setContentSize:CGSizeMake(320, 688)];

    profileResumeView.layer.cornerRadius = 5.0;
    profileResumeView.layer.masksToBounds = YES;

    nearToYouCandidatesTableViewController = [[KPDUsersHorizontalTableViewController alloc] initWithFrame:CGRectMake(1, 18, 126, 305)];
    [nearToYouCandidatesTableViewController setDelegate:self];
    [nearToYouCandidatesView addSubview:nearToYouCandidatesTableViewController.view];
    nearToYouCandidatesView.layer.cornerRadius = 5.0;
    nearToYouCandidatesView.layer.masksToBounds = YES;
    [nearToYouCandidatesTableViewController scrollContentToLeft];

    candidatesYouMayLikeTableViewController = [[KPDUsersHorizontalTableViewController alloc] initWithFrame:CGRectMake(1, 18, 126, 305)];
    [candidatesYouMayLikeTableViewController setDelegate:self];
    [candidatesYouMayLikeView addSubview:candidatesYouMayLikeTableViewController.view];
    candidatesYouMayLikeView.layer.cornerRadius = 5.0;
    candidatesYouMayLikeView.layer.masksToBounds = YES;
    [candidatesYouMayLikeTableViewController scrollContentToLeft];

    candidatesWhoYouMayLikeTableViewController = [[KPDUsersHorizontalTableViewController alloc] initWithFrame:CGRectMake(1, 18, 126, 305)];
    [candidatesWhoYouMayLikeTableViewController setDelegate:self];
    [candidatesWhoYouMayLikeView addSubview:candidatesWhoYouMayLikeTableViewController.view];
    candidatesWhoYouMayLikeView.layer.cornerRadius = 5.0;
    candidatesWhoYouMayLikeView.layer.masksToBounds = YES;
    [candidatesWhoYouMayLikeTableViewController scrollContentToLeft];
}

- (void)usersHorizontalTableViewControllerDidRefresh:(KPDUsersHorizontalTableViewController *)tableViewController
{
    [self showPeopleLivingNearToUser:@"Superwoman"];
}

- (void)showPeopleLivingNearToUser:(NSString *)theUser
{
    SearchResultsListViewController *srvc = [[SearchResultsListViewController alloc] initWithNibName:@"SearchResultsListViewController" bundle:nil];
    [self.navigationController pushViewController:srvc animated:YES];
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
    UserProfileViewController *upvc = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil withUsername:username];
    [self.navigationController pushViewController:upvc animated:YES];
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
    [candidatesWhoYouMayLikeTableViewController scrollContentToLeft];
}

@end

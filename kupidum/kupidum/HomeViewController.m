//
//  HomeViewController.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 06/01/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "HomeViewController.h"
#import "SearchResultsListViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface HomeViewController ()

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

    [scroll setContentSize:CGSizeMake(320, 605)];

    profileResumeView.layer.cornerRadius = 5.0;
    profileResumeView.layer.masksToBounds = YES;

    nearToYouCandidatesTableViewController = [[KPDUsersHorizontalTableViewController alloc] initWithFrame:CGRectMake(1, 18, 70, 305)];
    [nearToYouCandidatesView addSubview:nearToYouCandidatesTableViewController.view];
    nearToYouCandidatesView.layer.cornerRadius = 5.0;
    nearToYouCandidatesView.layer.masksToBounds = YES;
    [nearToYouCandidatesTableViewController scrollContentToLeft];

    candidatesYouMayLikeTableViewController = [[KPDUsersHorizontalTableViewController alloc] initWithFrame:CGRectMake(1, 18, 70, 305)];
    [candidatesYouMayLikeView addSubview:candidatesYouMayLikeTableViewController.view];
    candidatesYouMayLikeView.layer.cornerRadius = 5.0;
    candidatesYouMayLikeView.layer.masksToBounds = YES;
    [candidatesYouMayLikeTableViewController scrollContentToLeft];

    candidatesWhoYouMayLikeTableViewController = [[KPDUsersHorizontalTableViewController alloc] initWithFrame:CGRectMake(1, 18, 70, 305)];
    [candidatesWhoYouMayLikeView addSubview:candidatesWhoYouMayLikeTableViewController.view];
    candidatesWhoYouMayLikeView.layer.cornerRadius = 5.0;
    candidatesWhoYouMayLikeView.layer.masksToBounds = YES;
    [candidatesWhoYouMayLikeTableViewController scrollContentToLeft];
}

- (void)showPeopleLivingNearToUser:(NSString *)theUser
{
    SearchResultsListViewController *srvc = [[SearchResultsListViewController alloc] initWithNibName:@"SearchResultsViewController" bundle:nil];
    [self.navigationController pushViewController:srvc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

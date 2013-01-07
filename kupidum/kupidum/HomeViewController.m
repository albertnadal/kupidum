//
//  HomeViewController.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 06/01/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize scroll, nearToYouCandidatesView, candidatesYouMayLikeView, candidatesWhoYouMayLikeView;

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

    [scroll setContentSize:CGSizeMake(320, 585)];

    nearToYouCandidatesTableViewController = [[KPDUsersHorizontalTableViewController alloc] initWithFrame:CGRectMake(1, 18, 63, 305)];
    [nearToYouCandidatesView addSubview:nearToYouCandidatesTableViewController.view];
    [nearToYouCandidatesTableViewController scrollContentToLeft];

    candidatesYouMayLikeTableViewController = [[KPDUsersHorizontalTableViewController alloc] initWithFrame:CGRectMake(1, 18, 63, 305)];
    [candidatesYouMayLikeView addSubview:candidatesYouMayLikeTableViewController.view];
    [candidatesYouMayLikeTableViewController scrollContentToLeft];

    candidatesWhoYouMayLikeTableViewController = [[KPDUsersHorizontalTableViewController alloc] initWithFrame:CGRectMake(1, 18, 63, 305)];
    [candidatesWhoYouMayLikeView addSubview:candidatesWhoYouMayLikeTableViewController.view];
    [candidatesWhoYouMayLikeTableViewController scrollContentToLeft];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

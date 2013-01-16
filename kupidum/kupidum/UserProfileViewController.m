//
//  UserProfileViewController.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 10/01/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "UserProfileViewController.h"
#import "KPDUIUtilities.h"

@interface UserProfileViewController ()

- (void)showNavigationBarButtons;
- (void)backPressed;

@end

@implementation UserProfileViewController

@synthesize scroll;

const int basicInformationPanelHeight = 550;
const int detailedInformationPanelHeight = 1150;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
	[super loadView];

	UITableView *formTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, basicInformationPanelHeight, 320, detailedInformationPanelHeight) style:UITableViewStyleGrouped];
	[formTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[self setTableView:formTableView];

    [self.scroll addSubview:formTableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showNavigationBarButtons];
    [scroll setContentSize:CGSizeMake(320, basicInformationPanelHeight + detailedInformationPanelHeight)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end

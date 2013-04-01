//
//  MyAccountViewController.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 01/04/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "MyAccountViewController.h"
#import "KPDUIUtilities.h"

@interface MyAccountViewController ()
{
    NSString *username;

    IBOutlet UIScrollView *scroll;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scroll;

- (void)showNavigationBarButtons;
- (void)backPressed;

@end

@implementation MyAccountViewController

@synthesize scroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUsername:(NSString *)username_
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        username = username_;
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTitle:NSLocalizedString(@"My account", @"")];
    [self.scroll setContentSize:CGSizeMake(320, 734)];
    [self showNavigationBarButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

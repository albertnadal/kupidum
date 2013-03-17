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
{
    UIBarButtonItem *editButton;
}

- (void)saveUserProfile;
- (void)restoreOriginalProfileScrollSize:(NSNotification *)notification;
- (void)registerSelector:(SEL)selector withNotification:(NSString *)notificationKey;
- (void)showFormField:(NSNotification *)notification;
- (void)showNavigationBarButtons;
- (void)backPressed;

@end

@implementation UserProfileViewController

@synthesize scroll;

const float basicInformationPanelHeight = 550.0;
const float detailedInformationPanelHeight = 1500.0;
const float fieldCellHeight = 44.0;

const int numberOfFieldsInAppearanceSection = 7;
const int numberOfFieldsInValuesSection = 7;
const int numberOfFieldsInProfessionalSection = 4;
const int numberOfFieldsInLifestyleSection = 4;
const int numberOfFieldsInInterestsSection = 3;
const int numberOfFieldsInCultureSection = 2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)registerSelector:(SEL)selector withNotification:(NSString *)notificationKey
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:notificationKey object:nil];
}

- (void)restoreOriginalProfileScrollSize:(NSNotification *)notification
{
    [UIView beginAnimations:@"restoreProfileContentSize" context:nil];
    [UIView setAnimationDuration:0.3];
    [scroll setContentSize:CGSizeMake(320, basicInformationPanelHeight + detailedInformationPanelHeight)];
    [UIView commitAnimations];
}

- (void)showFormField:(NSNotification *)notification
{
    [scroll setContentSize:CGSizeMake(320, basicInformationPanelHeight + detailedInformationPanelHeight + scroll.frame.size.height)];

	NSIndexPath *indexPath = [[notification userInfo] objectForKey:@"indexPath"];

    int numberOfFieldsInSection[6] = {  numberOfFieldsInAppearanceSection + 1,
                                        numberOfFieldsInValuesSection + 1,
                                        numberOfFieldsInProfessionalSection + 1,
                                        numberOfFieldsInLifestyleSection + 1,
                                        numberOfFieldsInInterestsSection + 1,
                                        numberOfFieldsInCultureSection + 1 };

    float previousSectionsHeight = 0;
    for(int i=0; i <indexPath.section; i++)
        previousSectionsHeight += (numberOfFieldsInSection[i] * fieldCellHeight);

    CGRect scrollToArea = CGRectMake(0, basicInformationPanelHeight + previousSectionsHeight + (indexPath.row * fieldCellHeight), 320, scroll.frame.size.height);

    [self.scroll scrollRectToVisible:scrollToArea animated:YES];
}

- (void)loadView
{
	[super loadView];

	UITableView *formTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, basicInformationPanelHeight, 320, detailedInformationPanelHeight) style:UITableViewStyleGrouped];
	[formTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[self setTableView:formTableView];
    [formTableView setScrollEnabled:NO];

    [self.scroll addSubview:formTableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerSelector:@selector(showFormField:) withNotification:IBAInputRequestorShowFormField];
    [self registerSelector:@selector(restoreOriginalProfileScrollSize:) withNotification:IBAInputRequestorRestoreOriginalProfileSize];

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

    editButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Save", @"")
                                                  style: UIBarButtonItemStyleDone
                                                 target: self.navigationController
                                                 action: @selector(saveUserProfile)];
    [editButton setEnabled:FALSE];

    [self.navigationItem setRightBarButtonItem:editButton];
}

- (void)saveUserProfile
{
    
}

- (void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

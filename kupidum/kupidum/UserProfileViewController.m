//
//  UserProfileViewController.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 10/01/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "UserProfileViewController.h"
#import "ProfileFormDataSource.h"
#import "KPDUIUtilities.h"

@interface UserProfileViewController ()
{
    bool isReadOnly;
    bool editMode;
    bool profileIsEditable;
    UIBarButtonItem *editButton;
    UIBarButtonItem *doneButton;
    UITableView *formTableView;
}

- (void)beginEditMode;
- (void)saveUserProfile;
- (void)restoreOriginalProfileScrollSize:(NSNotification *)notification;
- (void)registerSelector:(SEL)selector withNotification:(NSString *)notificationKey;
- (void)showFormField:(NSNotification *)notification;
- (void)showNavigationBarButtons;
- (void)backPressed;
- (void)reloadFormTableView;

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

- (id)init
{
    if(self = [super init])
    {

    }

    return self;
}

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

	formTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, basicInformationPanelHeight, 320, detailedInformationPanelHeight) style:UITableViewStyleGrouped];
	[formTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[self setTableView:formTableView];
    [formTableView setScrollEnabled:NO];

    [self.scroll addSubview:formTableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"superwoman";

    [self registerSelector:@selector(showFormField:) withNotification:IBAInputRequestorShowFormField];
    [self registerSelector:@selector(restoreOriginalProfileScrollSize:) withNotification:IBAInputRequestorRestoreOriginalProfileSize];

    isReadOnly = [(ProfileFormDataSource *)self.formDataSource isReadOnly];
    profileIsEditable = TRUE; //This must be set after load user profile from DB or web service //!isReadOnly;
    editMode = true;

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


    if(profileIsEditable)
    {
        // Edit button
        editButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Edit", @"")
                                                      style: UIBarButtonItemStyleDone
                                                     target: self
                                                     action: @selector(beginEditMode)];
        [editButton setEnabled:TRUE];
        [self.navigationItem setRightBarButtonItem:editButton];

        // Done button
        doneButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Done", @"")
                                                      style: UIBarButtonItemStyleDone
                                                     target: self
                                                     action: @selector(saveUserProfile)];
    }
}

- (void)reloadFormTableView
{
    bool isReadOnly_ = editMode ? false : true;
	ProfileFormDataSource *profileFormDataSource = [[ProfileFormDataSource alloc] initWithModel:self.formDataSource.model isReadOnly:isReadOnly_];
    self.formDataSource = profileFormDataSource;
    
    [formTableView removeFromSuperview];
	formTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, basicInformationPanelHeight, 320, detailedInformationPanelHeight) style:UITableViewStyleGrouped];
	[formTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[self setTableView:formTableView];
    [formTableView setScrollEnabled:NO];
    
    [self.scroll addSubview:formTableView];
    [super viewDidLoad];
}

- (void)beginEditMode
{
    editMode = true;
    [self.navigationItem setRightBarButtonItem:doneButton];

    [self reloadFormTableView];
}

- (void)saveUserProfile
{
    if([self.formDataSource respondsToSelector:@selector(getModelWithValues)])
        NSLog(@"Model: %@", [(ProfileFormDataSource *)self.formDataSource getModelWithValues]);

    editMode = false;
    [self.navigationItem setRightBarButtonItem:editButton];

    [self reloadFormTableView];
}

- (void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

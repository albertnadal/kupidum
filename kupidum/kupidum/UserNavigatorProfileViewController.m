//
//  UserNavigatorProfileViewController.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 31/03/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "UserNavigatorProfileViewController.h"

@interface UserNavigatorProfileViewController ()
{
    KPDUser *user;
    IBOutlet UIImageView *avatar;
    IBOutlet UILabel *overview;
    IBOutlet UILabel *usernameLabel;
    IBOutlet UILabel *wantsToMeetLabel;
}

@property (nonatomic, retain) KPDUser *user;
@property (nonatomic, retain) IBOutlet UIImageView *avatar;
@property (nonatomic, retain) IBOutlet UILabel *overview;
@property (nonatomic, retain) IBOutlet UILabel *usernameLabel;
@property (nonatomic, retain) IBOutlet UILabel *wantsToMeetLabel;

@end

@implementation UserNavigatorProfileViewController

@synthesize delegate, user, avatar, overview, usernameLabel, wantsToMeetLabel;

- (id)initWithUser:(KPDUser *)user_
{
    self = [super initWithNibName:@"UserNavigatorProfileViewController" bundle:nil];
    if (self)
    {
        self.user = user_;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.avatar setImage:self.user.avatar];

    [self.usernameLabel setText:self.user.username];
    [self.usernameLabel sizeToFit];

    [self.wantsToMeetLabel setText:[NSString stringWithFormat:@"%@ %@...", NSLocalizedString(@"wants to meet a", @""), self.user.genderCandidateString]];
    [self.wantsToMeetLabel sizeToFit];

    CGRect wantsToMeetLabelFrame = self.wantsToMeetLabel.frame;
    wantsToMeetLabelFrame.origin.x = CGRectGetMaxX(self.usernameLabel.frame) + 5.0f;
    [self.wantsToMeetLabel setFrame:wantsToMeetLabelFrame];

    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.user.dateOfBirth];
    int secondsPerYear = 60*60*24*365;
    int totalYears = floor(timeInterval/secondsPerYear);

    NSString *genderOrProfession = self.user.professionString ? self.user.professionString : self.user.genderString;
    [self.overview setText:[NSString stringWithFormat:@"%@ is a %d years old %@ who lives in %@", self.user.username, totalYears, genderOrProfession, self.user.city]];

    // Invisible selector button
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectButton setBackgroundColor:[UIColor clearColor]];
    [selectButton addTarget:self action:@selector(showFullUserProfile:) forControlEvents:UIControlEventTouchUpInside];
    selectButton.frame = self.view.frame;
    [self.view addSubview:selectButton];
}

- (IBAction)showFullUserProfile:(id)sender
{
    [self.delegate showUserProfile:self.user.username];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

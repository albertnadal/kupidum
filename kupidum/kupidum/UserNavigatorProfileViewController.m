//
//  UserNavigatorProfileViewController.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 31/03/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "UserNavigatorProfileViewController.h"
#import <QuartzCore/QuartzCore.h>

static const int kPresentationHeight = 64.0f;

@interface UserNavigatorProfileViewController ()
{
    KPDUser *user;
    IBOutlet UIImageView *avatar;
    IBOutlet UILabel *overview;
    IBOutlet UILabel *usernameLabel;
    IBOutlet UILabel *wantsToMeetLabel;
    IBOutlet UIImageView *beginQuotesImage;
    IBOutlet UILabel *presentationLabel;
    IBOutlet UILabel *minMaxAgeCandidateLabel;
    IBOutlet UILabel *minMaxHeightCandidateLabel;
}

@property (nonatomic, retain) KPDUser *user;
@property (nonatomic, retain) IBOutlet UIImageView *avatar;
@property (nonatomic, retain) IBOutlet UILabel *overview;
@property (nonatomic, retain) IBOutlet UILabel *usernameLabel;
@property (nonatomic, retain) IBOutlet UILabel *wantsToMeetLabel;
@property (nonatomic, retain) IBOutlet UIImageView *beginQuotesImage;
@property (nonatomic, retain) IBOutlet UILabel *presentationLabel;
@property (nonatomic, retain) IBOutlet UILabel *minMaxAgeCandidateLabel;
@property (nonatomic, retain) IBOutlet UILabel *minMaxHeightCandidateLabel;

- (void)loadData;

@end

@implementation UserNavigatorProfileViewController

@synthesize delegate, user, avatar, overview, usernameLabel, wantsToMeetLabel, beginQuotesImage, presentationLabel, minMaxAgeCandidateLabel, minMaxHeightCandidateLabel;

- (id)initWithUser:(KPDUser *)user_
{
    self = [super initWithNibName:@"UserNavigatorProfileViewController" bundle:nil];
    if (self)
    {
        self.user = user_;
    }
    return self;
}

- (void)reloadData
{
    [self.user retrieveDataFromDatabase];
    [self loadData];
}

- (void)loadData
{
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
    [self.overview setText:[NSString stringWithFormat:NSLocalizedString(@"%@ is a %d years old %@ who lives in %@", @""), self.user.username, totalYears, genderOrProfession, self.user.city]];

    // people near to you label
    [self.overview.layer setMasksToBounds:NO];
    self.overview.layer.shadowColor = [UIColor blackColor].CGColor;
    self.overview.layer.shadowOpacity = 0.95;
    self.overview.layer.shadowRadius = 1.5;
    self.overview.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.overview.layer.shouldRasterize = YES;
    self.overview.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    [self.minMaxAgeCandidateLabel setText:[NSString stringWithFormat:NSLocalizedString(@"%d-%d years old", @""), [self.user.minAgeCandidate intValue], [self.user.maxAgeCandidate intValue]]];
    [self.minMaxHeightCandidateLabel setText:[NSString stringWithFormat:NSLocalizedString(@"%d-%d cm height", @""), [self.user.minHeightCandidate intValue], [self.user.maxHeightCandidate intValue]]];

    // load the presentation data
    NSString *presentationText = [NSString stringWithFormat:@"        %@", self.user.presentation];
    [self.presentationLabel setText:presentationText];
    [self.presentationLabel sizeToFit];

    CGRect presentationLabelFrame = self.presentationLabel.frame;
    presentationLabelFrame.size.height = MIN(kPresentationHeight, presentationLabelFrame.size.height);
    [self.presentationLabel setFrame:presentationLabelFrame];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadData];

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

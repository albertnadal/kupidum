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
#import "MBProgressHUD.h"

@interface HomeViewController ()
{
    MBProgressHUD *hud;
}

@property (nonatomic, strong) MBProgressHUD *hud;

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

@synthesize scroll, profileResumeView, nearToYouCandidatesView, candidatesYouMayLikeView, background, lastVisitor, lastMessageUser, lastInterestedUser, lastVisitorButton, lastMessageUserButton, lastInterestedUserButton, interestingPeopleLivingNear, interestingPeopleYouMayLike, nearToYouCandidatesTableViewController, candidatesYouMayLikeTableViewController, myAccountButton, myProfileButton, nearToYouCandidatesLabel, candidatesYouMayLikeLabel, faceFrontPhoto, faceProfilePhoto, bodySilouetePhoto, userProfile, hud;

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
        self.userProfile = [[KPDUserProfile alloc] initWithUsername:@"albert" andDelegate:self];
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
        [self performSelector:@selector(retrieveDataFromWebService) withObject:nil afterDelay:0.3];
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
    // Reset to default values
    [self.lastVisitorButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.lastVisitorButton setTitle:@"0" forState:UIControlStateNormal];
    [self.lastMessageUserButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.lastMessageUserButton setTitle:@"0" forState:UIControlStateNormal];
    [self.lastInterestedUserButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.lastInterestedUserButton setTitle:@"0" forState:UIControlStateNormal];

    // people neart to you label
    [self.nearToYouCandidatesLabel setText:NSLocalizedString(@"Interesting people living near to me", @"")];
    [self.nearToYouCandidatesLabel.layer setMasksToBounds:NO];
    self.nearToYouCandidatesLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.nearToYouCandidatesLabel.layer.shadowOpacity = 0.4;
    self.nearToYouCandidatesLabel.layer.shadowRadius = 1;
    self.nearToYouCandidatesLabel.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.nearToYouCandidatesLabel.layer.shouldRasterize = YES;
    self.nearToYouCandidatesLabel.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    // people you may like label
    [self.candidatesYouMayLikeLabel setText:NSLocalizedString(@"Interesting people I may like", @"")];
    [self.candidatesYouMayLikeLabel.layer setMasksToBounds:NO];
    self.candidatesYouMayLikeLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.candidatesYouMayLikeLabel.layer.shadowOpacity = 0.4;
    self.candidatesYouMayLikeLabel.layer.shadowRadius = 1;
    self.candidatesYouMayLikeLabel.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.candidatesYouMayLikeLabel.layer.shouldRasterize = YES;
    self.candidatesYouMayLikeLabel.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    // last visitor button
    [self.lastVisitorButton.titleLabel.layer setMasksToBounds:NO];
    self.lastVisitorButton.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.lastVisitorButton.titleLabel.layer.shadowOpacity = 1.0;
    self.lastVisitorButton.titleLabel.layer.shadowRadius = 3;
    self.lastVisitorButton.titleLabel.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.lastVisitorButton.titleLabel.layer.shouldRasterize = YES;
    self.lastVisitorButton.titleLabel.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    [self.lastVisitorButton.imageView.layer setMasksToBounds:NO];
    self.lastVisitorButton.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.lastVisitorButton.imageView.layer.shadowOpacity = 1.0;
    self.lastVisitorButton.imageView.layer.shadowRadius = 3;
    self.lastVisitorButton.imageView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.lastVisitorButton.imageView.layer.shouldRasterize = YES;
    self.lastVisitorButton.imageView.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    // last message user button
    [self.lastMessageUserButton.titleLabel.layer setMasksToBounds:NO];
    self.lastMessageUserButton.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.lastMessageUserButton.titleLabel.layer.shadowOpacity = 1.0;
    self.lastMessageUserButton.titleLabel.layer.shadowRadius = 3;
    self.lastMessageUserButton.titleLabel.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.lastMessageUserButton.titleLabel.layer.shouldRasterize = YES;
    self.lastMessageUserButton.titleLabel.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    [self.lastMessageUserButton.imageView.layer setMasksToBounds:NO];
    self.lastMessageUserButton.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.lastMessageUserButton.imageView.layer.shadowOpacity = 1.0;
    self.lastMessageUserButton.imageView.layer.shadowRadius = 3;
    self.lastMessageUserButton.imageView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.lastMessageUserButton.imageView.layer.shouldRasterize = YES;
    self.lastMessageUserButton.imageView.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    // last interested user button
    [self.lastInterestedUserButton.titleLabel.layer setMasksToBounds:NO];
    self.lastInterestedUserButton.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.lastInterestedUserButton.titleLabel.layer.shadowOpacity = 1.0;
    self.lastInterestedUserButton.titleLabel.layer.shadowRadius = 3;
    self.lastInterestedUserButton.titleLabel.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.lastInterestedUserButton.titleLabel.layer.shouldRasterize = YES;
    self.lastInterestedUserButton.titleLabel.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    [self.lastInterestedUserButton.imageView.layer setMasksToBounds:NO];
    self.lastInterestedUserButton.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.lastInterestedUserButton.imageView.layer.shadowOpacity = 1.0;
    self.lastInterestedUserButton.imageView.layer.shadowRadius = 3;
    self.lastInterestedUserButton.imageView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.lastInterestedUserButton.imageView.layer.shouldRasterize = YES;
    self.lastInterestedUserButton.imageView.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    // my profile button
    [self.myProfileButton.titleLabel.layer setMasksToBounds:NO];
    self.myProfileButton.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.myProfileButton.titleLabel.layer.shadowOpacity = 0.4;
    self.myProfileButton.titleLabel.layer.shadowRadius = 1;
    self.myProfileButton.titleLabel.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.myProfileButton.titleLabel.layer.shouldRasterize = YES;
    self.myProfileButton.titleLabel.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    [self.myProfileButton.imageView.layer setMasksToBounds:NO];
    self.myProfileButton.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.myProfileButton.imageView.layer.shadowOpacity = 0.4;
    self.myProfileButton.imageView.layer.shadowRadius = 1;
    self.myProfileButton.imageView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.myProfileButton.imageView.layer.shouldRasterize = YES;
    self.myProfileButton.imageView.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    // my account button
    [self.myAccountButton.titleLabel.layer setMasksToBounds:NO];
    self.myAccountButton.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.myAccountButton.titleLabel.layer.shadowOpacity = 0.4;
    self.myAccountButton.titleLabel.layer.shadowRadius = 1;
    self.myAccountButton.titleLabel.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.myAccountButton.titleLabel.layer.shouldRasterize = YES;
    self.myAccountButton.titleLabel.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    [self.myAccountButton.imageView.layer setMasksToBounds:NO];
    self.myAccountButton.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.myAccountButton.imageView.layer.shadowOpacity = 0.4;
    self.myAccountButton.imageView.layer.shadowRadius = 1;
    self.myAccountButton.imageView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.myAccountButton.imageView.layer.shouldRasterize = YES;
    self.myAccountButton.imageView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (void)retrieveDataFromWebService
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDAnimationFade;
    self.hud.labelText = NSLocalizedString(@"Loading data...", @"");

    NSURL *url = [NSURL URLWithString:@"http://www.lafruitera.com/ws/v1/home.php"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
    {
        NSLog(@"App.net Global Stream: %@", JSON);
        NSDictionary *homeData = (NSDictionary *)JSON;

        // Set the basic user home information
        NSDictionary *userHomeInformation = [homeData objectForKey:@"userHomeInformation"];
        [self setTitle:[userHomeInformation objectForKey:@"username"]];
        [self.lastVisitorButton setTitle:[(NSNumber *)[userHomeInformation objectForKey:@"totalNewVisitors"] stringValue] forState:UIControlStateNormal];
        [self.lastMessageUserButton setTitle:[(NSNumber *)[userHomeInformation objectForKey:@"totalNewMessages"] stringValue] forState:UIControlStateNormal];
        [self.lastInterestedUserButton setTitle:[(NSNumber *)[userHomeInformation objectForKey:@"totalNewInterests"] stringValue] forState:UIControlStateNormal];

        // Set the avatar placeholder based on candidate gender
        UIImage *candidateAvatarPlaceholder = nil;
        UserGender genderCandidate = [(NSNumber *)[userHomeInformation objectForKey:@"genderCandidate"] intValue];
        switch (genderCandidate)
        {
            case kMale:     candidateAvatarPlaceholder = [UIImage imageNamed:@"img_user_default_front_man.png"];
                            break;
                
            case kFemale:   candidateAvatarPlaceholder = [UIImage imageNamed:@"img_user_default_front_woman.png"];
                            break;
        }

        // Set default user pictures based on gender type
        UserGender gender = [(NSNumber *)[userHomeInformation objectForKey:@"gender"] intValue];
        switch (gender)
        {
            case kMale:     [self.faceFrontPhoto setImage:[UIImage imageNamed:@"img_user_default_front_man.png"]];
                            [self.faceProfilePhoto setImage:[UIImage imageNamed:@"img_user_default_profile_man.png"]];
                            [self.bodySilouetePhoto setImage:[UIImage imageNamed:@"img_user_default_body_man.png"]];
                            break;
                
            case kFemale:   [self.faceFrontPhoto setImage:[UIImage imageNamed:@"img_user_default_front_woman.png"]];
                            [self.faceProfilePhoto setImage:[UIImage imageNamed:@"img_user_default_profile_woman.png"]];
                            [self.bodySilouetePhoto setImage:[UIImage imageNamed:@"img_user_default_body_woman.png"]];
                            break;
        }

        // Download user pictures
        if([[userHomeInformation objectForKey:@"frontFaceImageUrl"] length])
            [self.faceFrontPhoto setImageWithURL:[NSURL URLWithString:[userHomeInformation objectForKey:@"frontFaceImageUrl"]] placeholderImage:self.faceFrontPhoto.image];

        if([[userHomeInformation objectForKey:@"profileFaceImageUrl"] length])
            [self.faceProfilePhoto setImageWithURL:[NSURL URLWithString:[userHomeInformation objectForKey:@"profileFaceImageUrl"]] placeholderImage:self.faceProfilePhoto.image];

        if([[userHomeInformation objectForKey:@"bodyImageUrl"] length])
            [self.bodySilouetePhoto setImageWithURL:[NSURL URLWithString:[userHomeInformation objectForKey:@"bodyImageUrl"]] placeholderImage:self.bodySilouetePhoto.image];

        // Save and show the information of the last visitor
        NSDictionary *lastVisitorData = [homeData objectForKey:@"lastVisitor"];
        if(lastVisitorData)
        {
            NSString *lastVisitorUsername = [lastVisitorData objectForKey:@"username"];
            NSString *lastVisitorAvatarURL = [lastVisitorData objectForKey:@"avatarURL"];
            UserGender lastVisitorGender = [(NSNumber *)[lastVisitorData objectForKey:@"gender"] intValue];
            UserGender lastVisitorGenderCandidate = [(NSNumber *)[lastVisitorData objectForKey:@"genderCandidate"] intValue];
            int lastVisitorMinAgeCandidate = [(NSNumber *)[lastVisitorData objectForKey:@"minAgeCandidate"] intValue];
            int lastVisitorMaxAgeCandidate = [(NSNumber *)[lastVisitorData objectForKey:@"maxAgeCandidate"] intValue];
            int lastVisitorMinLenghtCandidate = [(NSNumber *)[lastVisitorData objectForKey:@"minHeightCandidate"] intValue];
            int lastVisitorMaxLenghtCandidate = [(NSNumber *)[lastVisitorData objectForKey:@"maxHeightCandidate"] intValue];
            NSDate *lastVisitorDateOfBirth = [NSDate dateWithTimeIntervalSince1970:[(NSNumber *)[lastVisitorData objectForKey:@"dateOfBirth"] intValue]];
            NSString *lastVisitorCity = [lastVisitorData objectForKey:@"city"];
            NSString *lastVisitorPresentation = [lastVisitorData objectForKey:@"presentation"];
            int lastVisitorProfessionId = [(NSNumber *)[lastVisitorData objectForKey:@"professionId"] intValue];

            self.lastVisitor = [[KPDUser alloc] initWithUsername:lastVisitorUsername avatarUrl:lastVisitorAvatarURL avatar:nil gender:lastVisitorGender genderCandidate:lastVisitorGenderCandidate dateOfBirth:lastVisitorDateOfBirth city:lastVisitorCity professionId:lastVisitorProfessionId presentation:lastVisitorPresentation minAgeCandidate:lastVisitorMinAgeCandidate maxAgeCandidate:lastVisitorMaxAgeCandidate minLenghtCandidate:lastVisitorMinLenghtCandidate maxLenghtCandidate:lastVisitorMaxLenghtCandidate];

            // Download and save to disk the last visitor avatar
            if([lastVisitorAvatarURL length])
            {
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:lastVisitorAvatarURL]];
                [[[UIImageView alloc] init] setImageWithURLRequest:request placeholderImage:candidateAvatarPlaceholder success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                {
                    self.lastVisitor.avatar = image;
                    [self.lastVisitor saveToDatabase]; // Save the user avatar to disk
                    [self.lastVisitorButton setBackgroundImage:self.lastVisitor.avatar forState:UIControlStateNormal];

                } failure:nil];
            }
        }

        // Save and show the information of the last user message
        NSDictionary *lastMessageUserData = [homeData objectForKey:@"lastMessageUser"];
        if(lastMessageUserData)
        {
            NSString *lastMessageUserUsername = [lastMessageUserData objectForKey:@"username"];
            NSString *lastMessageUserAvatarURL = [lastMessageUserData objectForKey:@"avatarURL"];
            UserGender lastMessageUserGender = [(NSNumber *)[lastMessageUserData objectForKey:@"gender"] intValue];
            UserGender lastMessageUserGenderCandidate = [(NSNumber *)[lastMessageUserData objectForKey:@"genderCandidate"] intValue];
            int lastMessageUserMinAgeCandidate = [(NSNumber *)[lastMessageUserData objectForKey:@"minAgeCandidate"] intValue];
            int lastMessageUserMaxAgeCandidate = [(NSNumber *)[lastMessageUserData objectForKey:@"maxAgeCandidate"] intValue];
            int lastMessageUserMinLenghtCandidate = [(NSNumber *)[lastMessageUserData objectForKey:@"minHeightCandidate"] intValue];
            int lastMessageUserMaxLenghtCandidate = [(NSNumber *)[lastMessageUserData objectForKey:@"maxHeightCandidate"] intValue];
            NSDate *lastMessageUserDateOfBirth = [NSDate dateWithTimeIntervalSince1970:[(NSNumber *)[lastMessageUserData objectForKey:@"dateOfBirth"] intValue]];
            NSString *lastMessageUserCity = [lastMessageUserData objectForKey:@"city"];
            NSString *lastMessageUserPresentation = [lastMessageUserData objectForKey:@"presentation"];
            int lastMessageUserProfessionId = [(NSNumber *)[lastMessageUserData objectForKey:@"professionId"] intValue];

            self.lastMessageUser = [[KPDUser alloc] initWithUsername:lastMessageUserUsername avatarUrl:lastMessageUserAvatarURL avatar:nil gender:lastMessageUserGender genderCandidate:lastMessageUserGenderCandidate dateOfBirth:lastMessageUserDateOfBirth city:lastMessageUserCity professionId:lastMessageUserProfessionId presentation:lastMessageUserPresentation minAgeCandidate:lastMessageUserMinAgeCandidate maxAgeCandidate:lastMessageUserMaxAgeCandidate minLenghtCandidate:lastMessageUserMinLenghtCandidate maxLenghtCandidate:lastMessageUserMaxLenghtCandidate];

            // Download and save to disk the last visitor avatar
            if([lastMessageUserAvatarURL length])
            {
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:lastMessageUserAvatarURL]];
                [[[UIImageView alloc] init] setImageWithURLRequest:request placeholderImage:candidateAvatarPlaceholder success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                 {
                     self.lastMessageUser.avatar = image;
                     [self.lastMessageUser saveToDatabase]; // Save the user avatar to disk
                     [self.lastMessageUserButton setBackgroundImage:self.lastMessageUser.avatar forState:UIControlStateNormal];
                 } failure:nil];
            }
        }

        // Save and show the information of the last interested user
        NSDictionary *lastInterestedUserData = [homeData objectForKey:@"lastInterestedUser"];
        if(lastInterestedUserData)
        {
            NSString *lastInterestedUserUsername = [lastInterestedUserData objectForKey:@"username"];
            NSString *lastInterestedUserAvatarURL = [lastInterestedUserData objectForKey:@"avatarURL"];
            UserGender lastInterestedUserGender = [(NSNumber *)[lastInterestedUserData objectForKey:@"gender"] intValue];
            UserGender lastInterestedUserGenderCandidate = [(NSNumber *)[lastInterestedUserData objectForKey:@"genderCandidate"] intValue];
            int lastInterestedUserMinAgeCandidate = [(NSNumber *)[lastInterestedUserData objectForKey:@"minAgeCandidate"] intValue];
            int lastInterestedUserMaxAgeCandidate = [(NSNumber *)[lastInterestedUserData objectForKey:@"maxAgeCandidate"] intValue];
            int lastInterestedUserMinLenghtCandidate = [(NSNumber *)[lastInterestedUserData objectForKey:@"minHeightCandidate"] intValue];
            int lastInterestedUserMaxLenghtCandidate = [(NSNumber *)[lastInterestedUserData objectForKey:@"maxHeightCandidate"] intValue];
            NSDate *lastInterestedUserDateOfBirth = [NSDate dateWithTimeIntervalSince1970:[(NSNumber *)[lastInterestedUserData objectForKey:@"dateOfBirth"] intValue]];
            NSString *lastInterestedUserCity = [lastInterestedUserData objectForKey:@"city"];
            NSString *lastInterestedUserPresentation = [lastInterestedUserData objectForKey:@"presentation"];
            int lastInterestedUserProfessionId = [(NSNumber *)[lastInterestedUserData objectForKey:@"professionId"] intValue];

            self.lastInterestedUser = [[KPDUser alloc] initWithUsername:lastInterestedUserUsername avatarUrl:lastInterestedUserAvatarURL avatar:nil gender:lastInterestedUserGender genderCandidate:lastInterestedUserGenderCandidate dateOfBirth:lastInterestedUserDateOfBirth city:lastInterestedUserCity professionId:lastInterestedUserProfessionId presentation:lastInterestedUserPresentation minAgeCandidate:lastInterestedUserMinAgeCandidate maxAgeCandidate:lastInterestedUserMaxAgeCandidate minLenghtCandidate:lastInterestedUserMinLenghtCandidate maxLenghtCandidate:lastInterestedUserMaxLenghtCandidate];

            // Download and save to disk the last visitor avatar
            if([lastInterestedUserAvatarURL length])
            {
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:lastInterestedUserAvatarURL]];
                [[[UIImageView alloc] init] setImageWithURLRequest:request placeholderImage:candidateAvatarPlaceholder success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                 {
                     self.lastInterestedUser.avatar = image;
                     [self.lastInterestedUser saveToDatabase]; // Save the user avatar to disk
                     [self.lastInterestedUserButton setBackgroundImage:self.lastInterestedUser.avatar forState:UIControlStateNormal];
                 } failure:nil];
            }
        }

        // Save and show interesting people living near to user
        NSArray *listOfInterestingPeopleLivingNear = [homeData objectForKey:@"interestingPeopleLivingNear"];
        if(self.interestingPeopleLivingNear)
            [self.interestingPeopleLivingNear removeAllObjects];
        self.interestingPeopleLivingNear = [[NSMutableArray alloc] init];

        for(NSDictionary *interestingUser in listOfInterestingPeopleLivingNear)
        {
            NSString *interestingUserUsername = [interestingUser objectForKey:@"username"];
            NSString *interestingUserAvatarURL = [interestingUser objectForKey:@"avatarURL"];
            UserGender interestingUserGender = [(NSNumber *)[interestingUser objectForKey:@"gender"] intValue];
            UserGender interestingUserGenderCandidate = [(NSNumber *)[interestingUser objectForKey:@"genderCandidate"] intValue];
            int interestingUserMinAgeCandidate = [(NSNumber *)[interestingUser objectForKey:@"minAgeCandidate"] intValue];
            int interestingUserMaxAgeCandidate = [(NSNumber *)[interestingUser objectForKey:@"maxAgeCandidate"] intValue];
            int interestingUserMinLenghtCandidate = [(NSNumber *)[interestingUser objectForKey:@"minHeightCandidate"] intValue];
            int interestingUserMaxLenghtCandidate = [(NSNumber *)[interestingUser objectForKey:@"maxHeightCandidate"] intValue];
            NSDate *interestingUserDateOfBirth = [NSDate dateWithTimeIntervalSince1970:[(NSNumber *)[interestingUser objectForKey:@"dateOfBirth"] intValue]];
            NSString *interestingUserCity = [interestingUser objectForKey:@"city"];
            NSString *interestingUserPresentation = [interestingUser objectForKey:@"presentation"];
            int interestingUserProfessionId = [(NSNumber *)[interestingUser objectForKey:@"professionId"] intValue];

            KPDUser *interestingUser = [[KPDUser alloc] initWithUsername:interestingUserUsername avatarUrl:interestingUserAvatarURL avatar:nil gender:interestingUserGender genderCandidate:interestingUserGenderCandidate dateOfBirth:interestingUserDateOfBirth city:interestingUserCity professionId:interestingUserProfessionId presentation:interestingUserPresentation minAgeCandidate:interestingUserMinAgeCandidate maxAgeCandidate:interestingUserMaxAgeCandidate minLenghtCandidate:interestingUserMinLenghtCandidate maxLenghtCandidate:interestingUserMaxLenghtCandidate];
            [self.interestingPeopleLivingNear addObject:interestingUser];

            // Download and save to disk the last visitor avatar
            if([interestingUserAvatarURL length])
            {
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:interestingUserAvatarURL]];
                [[[UIImageView alloc] init] setImageWithURLRequest:request placeholderImage:candidateAvatarPlaceholder success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                 {
                     interestingUser.avatar = image;
                     [interestingUser saveToDatabase]; // Save the user avatar to disk
                     [(UITableView *)self.nearToYouCandidatesTableViewController.view reloadData];
                     [nearToYouCandidatesTableViewController scrollContentToLeft];
                 } failure:nil];
            }
        }


        // Save and show interesting people living near to user
        NSArray *listOfInterestingPeopleYouMayLike = [homeData objectForKey:@"interestingPeopleYouMayLike"];
        if(self.interestingPeopleYouMayLike)
            [self.interestingPeopleYouMayLike removeAllObjects];
        self.interestingPeopleYouMayLike = [[NSMutableArray alloc] init];
        
        for(NSDictionary *interestingUser in listOfInterestingPeopleYouMayLike)
        {
            NSString *interestingUserUsername = [interestingUser objectForKey:@"username"];
            NSString *interestingUserAvatarURL = [interestingUser objectForKey:@"avatarURL"];
            UserGender interestingUserGender = [(NSNumber *)[interestingUser objectForKey:@"gender"] intValue];
            UserGender interestingUserGenderCandidate = [(NSNumber *)[interestingUser objectForKey:@"genderCandidate"] intValue];
            int interestingUserMinAgeCandidate = [(NSNumber *)[interestingUser objectForKey:@"minAgeCandidate"] intValue];
            int interestingUserMaxAgeCandidate = [(NSNumber *)[interestingUser objectForKey:@"maxAgeCandidate"] intValue];
            int interestingUserMinLenghtCandidate = [(NSNumber *)[interestingUser objectForKey:@"minHeightCandidate"] intValue];
            int interestingUserMaxLenghtCandidate = [(NSNumber *)[interestingUser objectForKey:@"maxHeightCandidate"] intValue];
            NSDate *interestingUserDateOfBirth = [NSDate dateWithTimeIntervalSince1970:[(NSNumber *)[interestingUser objectForKey:@"dateOfBirth"] intValue]];
            NSString *interestingUserCity = [interestingUser objectForKey:@"city"];
            NSString *interestingUserPresentation = [interestingUser objectForKey:@"presentation"];
            int interestingUserProfessionId = [(NSNumber *)[interestingUser objectForKey:@"professionId"] intValue];
            
            KPDUser *interestingUser = [[KPDUser alloc] initWithUsername:interestingUserUsername avatarUrl:interestingUserAvatarURL avatar:nil gender:interestingUserGender genderCandidate:interestingUserGenderCandidate dateOfBirth:interestingUserDateOfBirth city:interestingUserCity professionId:interestingUserProfessionId presentation:interestingUserPresentation minAgeCandidate:interestingUserMinAgeCandidate maxAgeCandidate:interestingUserMaxAgeCandidate minLenghtCandidate:interestingUserMinLenghtCandidate maxLenghtCandidate:interestingUserMaxLenghtCandidate];
            [self.interestingPeopleYouMayLike addObject:interestingUser];
            
            // Download and save to disk the last visitor avatar
            if([interestingUserAvatarURL length])
            {
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:interestingUserAvatarURL]];
                [[[UIImageView alloc] init] setImageWithURLRequest:request placeholderImage:candidateAvatarPlaceholder success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                 {
                     interestingUser.avatar = image;
                     [interestingUser saveToDatabase]; // Save the user avatar to disk
                     [(UITableView *)self.candidatesYouMayLikeTableViewController.view reloadData];
                     [candidatesYouMayLikeTableViewController scrollContentToLeft];
                 } failure:nil];
            }
        }

        // Stop any possible visual loading indicator
        [self.hud hide:YES];
        [scroll.pullToRefreshView stopAnimating];

    } failure:^(NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , id JSON )
    {
        NSLog(@"Error: %@", error);
        NSLog(@"JSON: %@", JSON);
        [self.hud hide:YES];
    }];

    [operation start];
}

- (void)updateLastVisitorButton
{
    if(self.lastVisitor)
    {
        [self.lastVisitorButton setBackgroundImage:self.lastVisitor.avatar forState:UIControlStateNormal];
    }
    else
    {
        [self.lastVisitorButton setBackgroundImage:nil forState:UIControlStateNormal];
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
    UsersNavigatorViewController *unvc = [[UsersNavigatorViewController alloc] initAndShowInterestingPeopleNear];
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

//
//  HomeViewController.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 06/01/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPDUser.h"
#import "KPDUserProfile.h"
#import "KPDUsersHorizontalTableViewController.h"
#import "UIScrollView+SVPullToRefresh.h"

@interface HomeViewController : UIViewController <UIScrollViewDelegate, KPDUsersHorizontalTableViewControllerDelegate>
{
    IBOutlet UIScrollView *scroll;
    IBOutlet UIImageView *background;

    IBOutlet UIImageView *faceFrontPhoto;
    IBOutlet UIImageView *faceProfilePhoto;
    IBOutlet UIImageView *bodySilouetePhoto;

    IBOutlet UIView *profileResumeView;
    IBOutlet UIView *nearToYouCandidatesView;
    IBOutlet UIView *candidatesYouMayLikeView;

    IBOutlet UIButton *lastVisitorButton;
    IBOutlet UIButton *lastMessageUserButton;
    IBOutlet UIButton *lastInterestedUserButton;

    IBOutlet UIButton *myProfileButton;
    IBOutlet UIButton *myAccountButton;

    IBOutlet UILabel *nearToYouCandidatesLabel;
    IBOutlet UILabel *candidatesYouMayLikeLabel;

    KPDUsersHorizontalTableViewController *nearToYouCandidatesTableViewController;
    KPDUsersHorizontalTableViewController *candidatesYouMayLikeTableViewController;

    KPDUserProfile *userProfile;

    KPDUser *lastVisitor;
    KPDUser *lastMessageUser;
    KPDUser *lastInterestedUser;

    NSArray *interestingPeopleLivingNear;
    NSArray *interestingPeopleYouMayLike;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (strong, nonatomic) IBOutlet UIImageView *faceFrontPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *faceProfilePhoto;
@property (strong, nonatomic) IBOutlet UIImageView *bodySilouetePhoto;
@property (strong, nonatomic) IBOutlet UIView *profileResumeView;
@property (strong, nonatomic) IBOutlet UIView *nearToYouCandidatesView;
@property (strong, nonatomic) IBOutlet UIView *candidatesYouMayLikeView;
@property (strong, nonatomic) IBOutlet UILabel *nearToYouCandidatesLabel;
@property (strong, nonatomic) IBOutlet UILabel *candidatesYouMayLikeLabel;
@property (strong, nonatomic) KPDUsersHorizontalTableViewController *nearToYouCandidatesTableViewController;
@property (strong, nonatomic) KPDUsersHorizontalTableViewController *candidatesYouMayLikeTableViewController;
@property (strong, nonatomic) KPDUserProfile *userProfile;
@property (strong, nonatomic) KPDUser *lastVisitor;
@property (strong, nonatomic) KPDUser *lastMessageUser;
@property (strong, nonatomic) KPDUser *lastInterestedUser;
@property (strong, nonatomic) IBOutlet UIButton *lastVisitorButton;
@property (strong, nonatomic) IBOutlet UIButton *lastMessageUserButton;
@property (strong, nonatomic) IBOutlet UIButton *lastInterestedUserButton;
@property (strong, nonatomic) IBOutlet UIButton *myProfileButton;
@property (strong, nonatomic) IBOutlet UIButton *myAccountButton;
@property (strong, nonatomic) NSArray *interestingPeopleLivingNear;
@property (strong, nonatomic) NSArray *interestingPeopleYouMayLike;

- (void)showPeopleLivingNearToUser:(NSString *)theUser;
- (void)showAlert;
- (IBAction)showUserProfile:(id)sender;
- (IBAction)showUserAccount:(id)sender;
- (IBAction)showUserMessages:(id)sender;
- (IBAction)showRecentVisitors:(id)sender;
- (IBAction)showRecentUsersInterestedWithMe:(id)sender;

@end

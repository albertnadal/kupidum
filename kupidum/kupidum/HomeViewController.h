//
//  HomeViewController.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 06/01/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPDUsersHorizontalTableViewController.h"
#import "UIScrollView+SVPullToRefresh.h"

@interface HomeViewController : UIViewController <UIScrollViewDelegate, KPDUsersHorizontalTableViewControllerDelegate>
{
    IBOutlet UIScrollView *scroll;
    IBOutlet UIImageView *background;
    IBOutlet UIView *profileResumeView;
    IBOutlet UIView *nearToYouCandidatesView;
    IBOutlet UIView *candidatesYouMayLikeView;

    KPDUsersHorizontalTableViewController *nearToYouCandidatesTableViewController;
    KPDUsersHorizontalTableViewController *candidatesYouMayLikeTableViewController;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (strong, nonatomic) IBOutlet UIView *profileResumeView;
@property (strong, nonatomic) IBOutlet UIView *nearToYouCandidatesView;
@property (strong, nonatomic) IBOutlet UIView *candidatesYouMayLikeView;

- (void)showPeopleLivingNearToUser:(NSString *)theUser;
- (void)showAlert;
- (IBAction)showUserProfile:(id)sender;
- (IBAction)showUserAccount:(id)sender;
- (IBAction)showUserMessages:(id)sender;
- (IBAction)showRecentVisitors:(id)sender;
- (IBAction)showRecentUsersInterestedWithMe:(id)sender;

@end

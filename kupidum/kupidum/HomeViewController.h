//
//  HomeViewController.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 06/01/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPDUsersHorizontalTableViewController.h"

@interface HomeViewController : UIViewController <UIScrollViewDelegate>
{
    IBOutlet UIScrollView *scroll;
    IBOutlet UIView *profileResumeView;
    IBOutlet UIView *nearToYouCandidatesView;
    IBOutlet UIView *candidatesYouMayLikeView;
    IBOutlet UIView *candidatesWhoYouMayLikeView;

    KPDUsersHorizontalTableViewController *nearToYouCandidatesTableViewController;
    KPDUsersHorizontalTableViewController *candidatesYouMayLikeTableViewController;
    KPDUsersHorizontalTableViewController *candidatesWhoYouMayLikeTableViewController;

}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIView *profileResumeView;
@property (strong, nonatomic) IBOutlet UIView *nearToYouCandidatesView;
@property (strong, nonatomic) IBOutlet UIView *candidatesYouMayLikeView;
@property (strong, nonatomic) IBOutlet UIView *candidatesWhoYouMayLikeView;

- (void)showPeopleLivingNearToUser:(NSString *)theUser;

@end

//
//  UserNavigatorProfileViewController.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 31/03/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfileViewController.h"
#import "KPDUser.h"

@interface UserNavigatorProfileViewController : UIViewController
{
    id<KPDUserProfileViewControllerDelegate> delegate;
}

@property (nonatomic, retain) id<KPDUserProfileViewControllerDelegate> delegate;

- (id)initWithUser:(KPDUser *)user_;
- (IBAction)showFullUserProfile:(id)sender;
- (void)reloadData;

@end

//
//  UserNavigatorProfileViewController.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 31/03/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfileViewController.h"

@interface UserNavigatorProfileViewController : UIViewController
{
    id<KPDUserProfileDelegate> delegate;
}

@property (nonatomic, retain) id<KPDUserProfileDelegate> delegate;

- (IBAction)showFullUserProfile:(id)sender;

@end

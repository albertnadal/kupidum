//
//  UsersNavigatorViewController.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 30/03/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfileViewController.h"

@interface UsersNavigatorViewController : UIViewController<UIScrollViewDelegate, KPDUserProfileDelegate>

- (id)initAndShowInterestingPeopleNear;

@end

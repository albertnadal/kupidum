//
//  ChatViewController.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 21/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPDAudioUtilities.h"

@interface MessageViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *usersTable;
}

@property (strong, nonatomic) IBOutlet UITableView *usersTable;

- (void)showNavigationBarButtons;

@end

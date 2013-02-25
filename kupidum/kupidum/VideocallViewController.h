//
//  ChatViewController.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 21/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPDClientSIP.h"
#import "KPDAudioUtilities.h"

@interface VideocallViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, KPDClientSIPDelegate>
{
    IBOutlet UITableView *usersTable;
}

@property (strong, nonatomic) IBOutlet UITableView *usersTable;

- (void)showIncomingVideocallAlertFromUser:(id)theUser;

@end

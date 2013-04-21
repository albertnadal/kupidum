//
//  KPDUsersHorizontalTableViewControllerDelegate.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 09/01/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPDUser.h"

@class KPDUsersHorizontalTableViewController;

@protocol KPDUsersHorizontalTableViewControllerDelegate <NSObject>

- (void)usersHorizontalTableViewController:(KPDUsersHorizontalTableViewController *)tableViewController didSelectUserAtIndex:(int)index;
- (void)usersHorizontalTableViewControllerDidRefresh:(KPDUsersHorizontalTableViewController *)tableViewController;
- (NSInteger)numberOfUsersForHorizontalTableViewController:(KPDUsersHorizontalTableViewController *)tableViewController;
- (KPDUser *)usersHorizontalTableViewControllerDidRefresh:(KPDUsersHorizontalTableViewController *)tableViewController userForRowAtIndex:(int)index;

@end
